import UIKit
import AuthenticationServices
import ObjectiveC
import SystemConfiguration
import CoreTelephony
// JVerification 2.9.3 是 Objective-C 库，通过 BridgingHeader 导入
// 需要在 BridgingHeader.h 中添加 #import <JVerification/JVERIFICATIONService.h>

extension UIViewController {
    func loginWithWeChat(scope: String = "snsapi_userinfo", completion: @escaping (String?, Int32, String?) -> Void) {
        // 模拟微信登录成功，直接发送授权码
        let mockCode = "mock_wechat_auth_code_" + UUID().uuidString
        
        // 发送微信授权成功通知
        NotificationCenter.default.post(
            name: Notification.Name("WeChatAuthCodeReceived"),
            object: nil,
            userInfo: [
                "code": mockCode,
                "errCode": Int32(0),
                "errStr": "登录成功"
            ]
        )
        
        // 调用完成回调
        completion(mockCode, 0, "登录成功")
        
        /*
        let name = Notification.Name("WeChatAuthCodeReceived")
        var token: NSObjectProtocol?
        token = NotificationCenter.default.addObserver(forName: name, object: nil, queue: .main) { n in
            if let t = token { NotificationCenter.default.removeObserver(t) }
            let code = n.userInfo?["code"] as? String
            let errCode = n.userInfo?["errCode"] as? Int32 ?? 0
            let errStr = n.userInfo?["errStr"] as? String
            completion(code, errCode, errStr)
        }
        let req = SendAuthReq()
        req.scope = scope
        req.state = UUID().uuidString
        WXApi.send(req)
        */
    }

    func loginWithApple(completion: @escaping (String?, Error?) -> Void) {
        class AppleCoordinator: NSObject, ASAuthorizationControllerDelegate, ASAuthorizationControllerPresentationContextProviding {
            let completion: (String?, Error?) -> Void
            weak var presenter: UIViewController?
            init(presenter: UIViewController, completion: @escaping (String?, Error?) -> Void) {
                self.presenter = presenter
                self.completion = completion
            }
            func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
                presenter?.view.window ?? UIWindow()
            }
            func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
                if let credential = authorization.credential as? ASAuthorizationAppleIDCredential,
                   let tokenData = credential.identityToken,
                   let token = String(data: tokenData, encoding: .utf8) {
                    completion(token, nil)
                } else {
                    completion(nil, nil)
                }
            }
            func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
                completion(nil, error)
            }
        }
        let provider = ASAuthorizationAppleIDProvider()
        let request = provider.createRequest()
        request.requestedScopes = [.fullName, .email]
        let controller = ASAuthorizationController(authorizationRequests: [request])
        let coord = AppleCoordinator(presenter: self, completion: completion)
        controller.delegate = coord
        controller.presentationContextProvider = coord
        objc_setAssociatedObject(self, UnsafeRawPointer(bitPattern: 0xA11CE)!, coord, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        controller.performRequests()
    }

    /// 极光一键登录
    /// - Parameters:
    ///   - completion: 登录结果回调，成功返回token，失败返回error
    func loginWithJiguang(completion: @escaping (String?, Error?) -> Void) {
        // JVerification 2.9.3 通过 Objective-C Bridging Header 导入
        // 直接使用，不需要 canImport 检查

        // 先检查SDK是否已经初始化完成
        if !JVERIFICATIONService.isSetupClient() {
            let error = NSError(domain: "JiguangLoginError", code: -4, userInfo: [NSLocalizedDescriptionKey: "极光SDK尚未初始化完成，请稍后再试"])
            print("❌ 极光SDK未初始化")
            completion(nil, error)
            return
        }

        // 详细诊断运营商信息
        diagnosisCarrierInfo()

        // 检查网络状态 - 必须使用蜂窝数据
        let networkStatus = checkNetworkStatus()
        print("🌐 当前网络状态: \(networkStatus.rawValue)")

        if networkStatus == .wifi {
            let error = NSError(domain: "JiguangLoginError", code: -5, userInfo: [
                NSLocalizedDescriptionKey: "⚠️ 一键登录必须使用蜂窝数据\n\n检测到您正在使用WiFi网络！\n\n请执行以下操作：\n1. 打开控制中心\n2. 关闭WiFi（长按WiFi图标选择关闭）\n3. 确保蜂窝数据已开启\n4. 等待状态栏显示运营商名称\n5. 重新点击登录按钮"
            ])
            print("❌ 当前使用WiFi，一键登录需要蜂窝数据")
            completion(nil, error)
            return
        }

        // 检查认证环境 - checkVerifyEnable 返回 BOOL，不是闭包
        print("🔍 检查一键登录环境...")
        if JVERIFICATIONService.checkVerifyEnable() {
            print("✅ 一键登录环境可用")
            // 环境可用，先进行预取号（如果之前失败的话），然后开始一键登录
            JVERIFICATIONService.preLogin(3000) { preResult in
                if let preResult = preResult, let preCode = preResult["code"] as? Int {
                    if preCode == 2000 {
                        print("✅ 预取号成功，开始一键登录")
                    } else {
                        let preMsg = preResult["message"] as? String ?? "未知错误"
                        print("⚠️ 预取号失败: [\(preCode)] \(preMsg)，尝试继续登录")
                    }
                }

                // 无论预取号是否成功，都尝试登录
                self.startJiguangLogin(completion: completion)
            }
        } else {
            // 环境不可用（可能是未插卡、无网络等情况）
            print("❌ 一键登录环境不可用")

            // 根据网络状态提供更详细的错误信息
            var errorMessage = "❌ 一键登录环境不可用\n\n"
            if networkStatus == .notReachable {
                errorMessage += "检测到无网络连接\n\n请检查：\n1. 是否开启飞行模式\n2. 蜂窝数据是否开启"
            } else {
                errorMessage += "⚠️ 无法识别运营商信息\n\n可能的原因：\n"
                errorMessage += "1. 当前使用WiFi而非蜂窝数据\n"
                errorMessage += "2. SIM卡未正确插入或未激活\n"
                errorMessage += "3. 使用的是虚拟运营商（非移动/联通/电信）\n"
                errorMessage += "4. eSIM配置未完成\n\n"
                errorMessage += "解决方法：\n"
                errorMessage += "• 关闭WiFi，使用蜂窝数据\n"
                errorMessage += "• 检查状态栏是否显示运营商名称\n"
                errorMessage += "• 双卡用户请确认数据卡已激活\n"
                errorMessage += "• 尝试重启手机"
            }

            let error = NSError(domain: "JiguangLoginError", code: -1, userInfo: [NSLocalizedDescriptionKey: errorMessage])
            completion(nil, error)
        }
    }

    /// 诊断运营商信息
    private func diagnosisCarrierInfo() {
        print("\n========== 📱 运营商诊断信息 ==========")
        let networkInfo = CTTelephonyNetworkInfo()

        if #available(iOS 12.0, *) {
            // iOS 12+ 支持多卡
            if let providers = networkInfo.serviceSubscriberCellularProviders {
                print("📶 检测到 \(providers.count) 张SIM卡")
                for (key, carrier) in providers {
                    print("\n卡槽: \(key)")
                    print("  运营商名称: \(carrier.carrierName ?? "未知")")
                    print("  国家代码: \(carrier.mobileCountryCode ?? "无")")
                    print("  网络代码: \(carrier.mobileNetworkCode ?? "无")")
                    print("  ISO国家码: \(carrier.isoCountryCode ?? "无")")
                    print("  允许VoIP: \(carrier.allowsVOIP)")
                }

                // 检查数据服务使用的卡
                if let dataIdentifier = networkInfo.dataServiceIdentifier {
                    print("\n📡 数据服务使用的卡槽: \(dataIdentifier)")
                    if let dataCarrier = providers[dataIdentifier] {
                        print("  数据卡运营商: \(dataCarrier.carrierName ?? "未知")")
                    }
                }
            } else {
                print("⚠️ 无法获取SIM卡信息")
            }

            // 检查当前网络类型
            if let radioTech = networkInfo.serviceCurrentRadioAccessTechnology {
                print("\n📶 当前网络类型:")
                for (key, tech) in radioTech {
                    let techName = getRadioTechName(tech)
                    print("  卡槽\(key): \(techName)")
                }
            }
        } else {
            // iOS 12以下
            if let carrier = networkInfo.subscriberCellularProvider {
                print("  运营商名称: \(carrier.carrierName ?? "未知")")
                print("  国家代码: \(carrier.mobileCountryCode ?? "无")")
                print("  网络代码: \(carrier.mobileNetworkCode ?? "无")")
            }
        }

        print("======================================\n")
    }

    /// 获取网络制式名称
    private func getRadioTechName(_ tech: String) -> String {
        switch tech {
        case CTRadioAccessTechnologyGPRS: return "GPRS (2G)"
        case CTRadioAccessTechnologyEdge: return "EDGE (2G)"
        case CTRadioAccessTechnologyWCDMA: return "WCDMA (3G)"
        case CTRadioAccessTechnologyHSDPA: return "HSDPA (3G)"
        case CTRadioAccessTechnologyHSUPA: return "HSUPA (3G)"
        case CTRadioAccessTechnologyCDMA1x: return "CDMA (2G)"
        case CTRadioAccessTechnologyCDMAEVDORev0: return "EVDO Rev0 (3G)"
        case CTRadioAccessTechnologyCDMAEVDORevA: return "EVDO RevA (3G)"
        case CTRadioAccessTechnologyCDMAEVDORevB: return "EVDO RevB (3G)"
        case CTRadioAccessTechnologyeHRPD: return "eHRPD (3G)"
        case CTRadioAccessTechnologyLTE: return "LTE (4G)"
        default:
            if #available(iOS 14.1, *) {
                if tech == CTRadioAccessTechnologyNRNSA || tech == CTRadioAccessTechnologyNR {
                    return "5G"
                }
            }
            return "未知网络类型: \(tech)"
        }
    }

    /// 检查当前网络状态
    /// - Returns: 网络状态类型
    private func checkNetworkStatus() -> NetworkStatus {
        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(MemoryLayout<sockaddr_in>.size)
        zeroAddress.sin_family = sa_family_t(AF_INET)

        guard let reachability = withUnsafePointer(to: &zeroAddress, {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {
                SCNetworkReachabilityCreateWithAddress(nil, $0)
            }
        }) else {
            return .notReachable
        }

        var flags: SCNetworkReachabilityFlags = []
        if !SCNetworkReachabilityGetFlags(reachability, &flags) {
            return .notReachable
        }

        let isReachable = flags.contains(.reachable)
        let needsConnection = flags.contains(.connectionRequired)
        let isWWAN = flags.contains(.isWWAN)

        if !isReachable {
            return .notReachable
        }

        if isWWAN {
            return .cellular
        }

        if !needsConnection {
            return .wifi
        }

        return .notReachable
    }

    /// 网络状态枚举
    private enum NetworkStatus: String {
        case notReachable = "无网络"
        case wifi = "WiFi"
        case cellular = "蜂窝数据"
    }

    /// 启动极光一键登录流程
    private func startJiguangLogin(completion: @escaping (String?, Error?) -> Void) {
        // 配置登录界面（可选）
        let config = JVUIConfig()
        config.navCustom = true  // 使用自定义导航栏
        if let bgImage = UIImage(named: "Background") {
            config.authPageBackgroundImage = bgImage  // 设置背景图
        }
        config.autoLayout = false  // 不使用AutoLayout，使用传统布局
        config.shouldAutorotate = true  // 支持自动旋转
        config.dismissAnimationFlag = true  // 关闭授权页时显示动画

        // 先设置UI配置
        JVERIFICATIONService.customUI(with: config)

        print("🚀 拉起一键登录授权页...")

        // 调用授权登录
        // 使用 JVerificationHelper 包装类来调用 Objective-C 方法
        JVerificationHelper.getAuthorization(withController: self, hide: false, completion: { (result: [AnyHashable : Any]?) in
            DispatchQueue.main.async {
                if let result = result {
                    // 检查登录结果
                    let code = result["code"] as? Int ?? -1
                    let loginToken = result["loginToken"] as? String
                    let message = result["message"] as? String ?? "未知错误"
                    let operatorType = result["operator"] as? String ?? "unknown"

                    print("📱 一键登录回调: code=\(code), message=\(message), operator=\(operatorType)")

                    if code == 2000, let token = loginToken {
                        // 登录成功，获取token
                        // 注意：loginToken需要发送到您的服务器，由服务器调用极光API获取手机号
                        print("✅ 一键登录成功，token: \(token)")
                        completion(token, nil)
                    } else if code == 6004 {
                        // 用户取消了登录
                        print("⚠️ 用户取消登录")
                        let error = NSError(domain: "JiguangLoginError", code: -2, userInfo: [NSLocalizedDescriptionKey: "用户取消登录"])
                        completion(nil, error)
                    } else {
                        // 登录失败，打印详细错误信息
                        print("❌ 一键登录失败: [\(code)] \(message)")
                        var errorMessage = "一键登录失败: \(message)"

                        // 根据错误码提供更友好的提示
                        switch code {
                        case 6001:
                            errorMessage = "网络连接失败，请检查网络后重试"
                        case 6002:
                            errorMessage = "未检测到SIM卡，请插入SIM卡后重试"
                        case 6003:
                            errorMessage = "蜂窝网络未开启，请在设置中开启蜂窝数据"
                        case 6000:
                            errorMessage = "当前运营商不支持一键登录，请使用其他登录方式"
                        default:
                            errorMessage = "一键登录失败 [\(code)]: \(message)"
                        }

                        let error = NSError(domain: "JiguangLoginError", code: code, userInfo: [NSLocalizedDescriptionKey: errorMessage])
                        completion(nil, error)
                    }
                } else {
                    // 登录失败
                    print("❌ 一键登录回调结果为空")
                    let error = NSError(domain: "JiguangLoginError", code: -3, userInfo: [NSLocalizedDescriptionKey: "登录失败，回调结果为空"])
                    completion(nil, error)
                }
            }
        })
    }
    
}
