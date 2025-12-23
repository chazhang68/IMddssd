import UIKit
import AuthenticationServices
import ObjectiveC
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
        // 先检查认证环境 - checkVerifyEnable 返回 BOOL，不是闭包
        if JVERIFICATIONService.checkVerifyEnable() {
            // 环境可用，开始一键登录
            self.startJiguangLogin(completion: completion)
        } else {
            // 环境不可用（可能是未插卡、无网络等情况）
            let error = NSError(domain: "JiguangLoginError", code: -1, userInfo: [NSLocalizedDescriptionKey: "一键登录环境不可用，请检查网络和SIM卡"])
            completion(nil, error)
        }
    }
    
    /// 启动极光一键登录流程
    private func startJiguangLogin(completion: @escaping (String?, Error?) -> Void) {
        // 配置登录界面（可选）
        let config = JVUIConfig()
        config.navCustom = true  // 使用自定义导航栏
        if let bgImage = UIImage(named: "Background") {
            config.authPageBackgroundImage = bgImage  // 设置背景图
        }
        
        // 开始一键登录
        // JVerification 2.9.3 使用 getAuthorizationWithController 方法
        // 先设置UI配置
        JVERIFICATIONService.customUI(with: config)
        
        // 调用授权登录
        // 使用 JVerificationHelper 包装类来调用 Objective-C 方法
        JVerificationHelper.getAuthorization(withController: self, hide: false, completion: { (result: [AnyHashable : Any]?) in
            DispatchQueue.main.async {
                if let result = result {
                    // 检查登录结果
                    let code = result["code"] as? Int ?? -1
                    let loginToken = result["loginToken"] as? String
                    let message = result["message"] as? String ?? "未知错误"
                    
                    if code == 2000, let token = loginToken {
                        // 登录成功，获取token
                        // 注意：loginToken需要发送到您的服务器，由服务器调用极光API获取手机号
                        completion(token, nil)
                    } else if code == 6004 {
                        // 用户取消了登录
                        let error = NSError(domain: "JiguangLoginError", code: -2, userInfo: [NSLocalizedDescriptionKey: "用户取消登录"])
                        completion(nil, error)
                    } else {
                        // 登录失败
                        let error = NSError(domain: "JiguangLoginError", code: code, userInfo: [NSLocalizedDescriptionKey: message])
                        completion(nil, error)
                    }
                } else {
                    // 登录失败
                    let error = NSError(domain: "JiguangLoginError", code: -3, userInfo: [NSLocalizedDescriptionKey: "登录失败"])
                    completion(nil, error)
                }
            }
        })
    }
    
}
