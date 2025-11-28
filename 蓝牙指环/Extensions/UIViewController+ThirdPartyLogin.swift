import UIKit
import AuthenticationServices
import ObjectiveC

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

    
}