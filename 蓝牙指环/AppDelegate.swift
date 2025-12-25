//
//  AppDelegate.swift
//  蓝牙指环
//
//  Created by 88 33 on 2025/11/19.
//

import UIKit
// #if canImport(BCLRingSDK)
// import BCLRingSDK
// #endif
// import GoogleSignIn
// JCore 和 JVerification 通过 Objective-C Bridging Header 导入

@main
class AppDelegate: UIResponder, UIApplicationDelegate {



    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // 初始化极光SDK
        let jpushAppKey = "accc563b6c4db58543bf04f0"
        let channel = "App Store"
        let isProduction = true

        // 开启极光SDK调试日志，方便排查问题
        JVERIFICATIONService.setDebug(true)

        // 初始化JVerification（一键登录）
        // JVerification 2.9.3 使用 setupWithConfig 方法
        // 注意：JCore 3.2.9 是基础组件，JVerification 已经依赖它
        let config = JVAuthConfig()
        config.appKey = jpushAppKey
        config.channel = channel
        config.isProduction = isProduction
        config.timeout = 10000  // 设置初始化超时时间为10秒
        config.authBlock = { result in
            if let result = result {
                let code = result["code"] as? Int ?? -1
                let message = result["message"] as? String ?? "未知错误"

                if code == 2000 {
                    print("✅ 极光SDK初始化成功")
                    // 初始化成功后，立即进行预取号，提升一键登录成功率
                    JVERIFICATIONService.preLogin(5000) { preResult in
                        if let preResult = preResult, let preCode = preResult["code"] as? Int {
                            if preCode == 2000 {
                                print("✅ 极光预取号成功")
                            } else {
                                let preMsg = preResult["message"] as? String ?? "未知错误"
                                print("⚠️ 极光预取号失败: [\(preCode)] \(preMsg)")
                            }
                        }
                    }
                } else {
                    print("❌ 极光SDK初始化失败: [\(code)] \(message)")
                }
            } else {
                print("❌ 极光SDK初始化失败: 回调结果为空")
            }
        }
        JVERIFICATIONService.setup(with: config)
        
        // 初始化 BCLRingSDK
        SDKIntegrationHelper.shared.initializeSDK()
        
        // 初始化蓝牙管理器
        let mgr = BCLRingSDKManager.shared
        mgr.prepareAutoConnect()
        mgr.startScanning()
        
        // WeChat SDK暂时禁用 - 等待CocoaPods配置修复
        // let appId = "wxYOUR_APP_ID"
        // let universalLink = "https://your.domain.com/wechat/"
        // WXApi.registerApp(appId, universalLink: universalLink)
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {}

    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        // WeChat SDK暂时禁用 - 等待CocoaPods配置修复
        // if WXApi.handleOpen(url, delegate: self) { return true }
        // return GIDSignIn.sharedInstance.handle(url)
        return true
    }

    func application(_ application: UIApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void) -> Bool {
        // WeChat SDK暂时禁用 - 等待CocoaPods配置修复
        // return WXApi.handleOpenUniversalLink(userActivity, delegate: self)
        return true
    }

    // WeChat SDK协议方法暂时禁用
    /*
    func onReq(_ req: BaseReq) {}

    func onResp(_ resp: BaseResp) {
        if let authResp = resp as? SendAuthResp {
            let userInfo: [String: Any] = [
                "code": authResp.code ?? "",
                "errCode": authResp.errCode,
                "errStr": authResp.errStr ?? ""
            ]
            NotificationCenter.default.post(name: Notification.Name("WeChatAuthCodeReceived"), object: nil, userInfo: userInfo)
        }
    }
    */
}
