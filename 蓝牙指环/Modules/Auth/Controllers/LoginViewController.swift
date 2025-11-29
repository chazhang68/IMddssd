import UIKit

/// 登录视图控制器 - 处理用户登录逻辑
/// 负责管理登录界面和第三方登录回调处理
class LoginViewController: UIViewController {
    
    // MARK: - UI组件定义
    
    /// 登录视图 - 包含所有登录界面元素
    private let loginView = LoginView()
    
    // MARK: - 生命周期方法
    
    /// 加载自定义登录视图
    override func loadView() {
        view = loginView
    }
    
    /// 视图加载完成后的初始化
    /// 注册微信授权回调通知监听
    override func viewDidLoad() {
        super.viewDidLoad()
        // 监听微信授权码接收通知
        NotificationCenter.default.addObserver(self, selector: #selector(handleWeChatAuth(_:)), name: Notification.Name("WeChatAuthCodeReceived"), object: nil)
    }
    
    // MARK: - 事件处理方法
    
    /// 处理微信授权回调
    /// - 从通知中提取授权码
    /// - 打印授权码用于调试
    /// - 直接跳转到首页（设备搜索页面）
    @objc private func handleWeChatAuth(_ notification: Notification) {
        // 从通知中提取用户信息和授权码
        guard let userInfo = notification.userInfo,
              let code = userInfo["code"] as? String else { return }
        
        print("WeChat auth code: \(code)")  // 调试输出授权码
        
        // 直接跳转到首页（设备搜索页面）
        navigateToHome()
    }
    
    /// 跳转到首页（设备搜索页面）
    /// 创建并展示HomeViewController作为根视图控制器
    private func navigateToHome() {
        NotificationCenter.default.post(name: Notification.Name("LoginSuccess"), object: nil)
    }
}
