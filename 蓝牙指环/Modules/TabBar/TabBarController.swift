import UIKit

/// 统一的导航控制器，配置全局外观与交互
final class BaseNavigationController: UINavigationController, UIGestureRecognizerDelegate {
    override func viewDidLoad() {
        super.viewDidLoad()
        setupAppearance()
        interactivePopGestureRecognizer?.delegate = self
    }
    
    private func setupAppearance() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor(hex: 0x0E0F12)
        appearance.titleTextAttributes = [
            .foregroundColor: UIColor.white,
            .font: UIFont.systemFont(ofSize: 17, weight: .semibold)
        ]
        
        navigationBar.standardAppearance = appearance
        navigationBar.scrollEdgeAppearance = appearance
        navigationBar.compactAppearance = appearance
        navigationBar.tintColor = UIColor(hex: 0xFFD23A)
        navigationBar.isTranslucent = false
    }
    
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        // 二级页面默认隐藏底部 TabBar
        if viewControllers.count > 0 {
            viewController.hidesBottomBarWhenPushed = true
        }
        super.pushViewController(viewController, animated: animated)
    }
    
    // 仅在有上一级页面时启用侧滑返回
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return viewControllers.count > 1
    }
}

final class TabBarController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabBar()
        setupTabs()
    }
    
    private func setupTabBar() {
        tabBar.backgroundColor = UIColor(hex: 0x0E0F12)
        tabBar.tintColor = UIColor(hex: 0xFFD23A)
        tabBar.unselectedItemTintColor = UIColor.white.withAlphaComponent(0.6)
        tabBar.layer.cornerRadius = 24
        tabBar.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        tabBar.layer.masksToBounds = true
    }
    
    private func setupTabs() {
        let home = HomeViewController()
        let community = CommunityViewController()
        let settings = SettingsViewController()
        
        home.tabBarItem = UITabBarItem(title: nil, image: UIImage(systemName: "house.fill"), tag: 0)
        community.tabBarItem = UITabBarItem(title: nil, image: UIImage(systemName: "bubble.left.and.bubble.right.fill"), tag: 1)
        settings.tabBarItem = UITabBarItem(title: nil, image: UIImage(systemName: "person.fill"), tag: 2)

        // 为每个 Tab 包装统一的导航控制器，方便后续 Push
        let homeNav = BaseNavigationController(rootViewController: home)
        let communityNav = BaseNavigationController(rootViewController: community)
        let settingsNav = BaseNavigationController(rootViewController: settings)
        
        viewControllers = [homeNav, communityNav, settingsNav]
    }
}

extension UIViewController {
    /// 统一的 Push 方法：有导航时直接 Push，没有则自动包装导航
    func push(_ viewController: UIViewController, animated: Bool = true, hideTabBar: Bool = true) {
        viewController.hidesBottomBarWhenPushed = hideTabBar
        if let nav = navigationController {
            nav.pushViewController(viewController, animated: animated)
        } else {
            let nav = BaseNavigationController(rootViewController: viewController)
            nav.modalPresentationStyle = .fullScreen
            present(nav, animated: animated)
        }
    }
}