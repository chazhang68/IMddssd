//
//  AppDelegate.swift
//  蓝牙指环
//
//  Created by 88 33 on 2025/11/19.
//

import UIKit
import BCLRingSDK
// import GoogleSignIn

@main
class AppDelegate: UIResponder, UIApplicationDelegate {



    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // 初始化 BCLRingSDK
        SDKIntegrationHelper.shared.initializeSDK()
        
        // 初始化蓝牙管理器
        _ = BCLRingSDKManager.shared
        
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

