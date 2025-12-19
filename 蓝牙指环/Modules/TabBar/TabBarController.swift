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
        appearance.shadowColor = .clear
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
        view.backgroundColor = .black
        setupTabBar()
        setupTabs()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        var frame = tabBar.frame
        let baseHeight: CGFloat = 64
        let safeBottom = view.safeAreaInsets.bottom
        frame.size.height = baseHeight + safeBottom
        frame.origin.y = view.bounds.height - frame.size.height
        tabBar.frame = frame
    }
    
    private func setupTabBar() {
        tabBar.isTranslucent = false
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor(hex: 0x2B2B2B)
        appearance.shadowColor = .clear
        tabBar.standardAppearance = appearance
        tabBar.scrollEdgeAppearance = appearance
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
        
        let homeImage = UIImage(named: "home")?.withRenderingMode(.alwaysOriginal)
        let homeSelectedImage = UIImage(named: "home2")?.withRenderingMode(.alwaysOriginal)
        home.tabBarItem = UITabBarItem(title: nil, image: homeImage, selectedImage: homeSelectedImage)
        home.tabBarItem.imageInsets = UIEdgeInsets(top: 8, left: 0, bottom: -8, right: 0)

        let communityImage = UIImage(named: "community")?.withRenderingMode(.alwaysOriginal)
        let communitySelectedImage = UIImage(named: "community2")?.withRenderingMode(.alwaysOriginal)
        community.tabBarItem = UITabBarItem(title: nil, image: communityImage, selectedImage: communitySelectedImage)
        community.tabBarItem.imageInsets = UIEdgeInsets(top: 8, left: 0, bottom: -8, right: 0)

        let settingsImage = UIImage(named: "my")?.withRenderingMode(.alwaysOriginal)
        let settingsSelectedImage = UIImage(named: "my2")?.withRenderingMode(.alwaysOriginal)
        settings.tabBarItem = UITabBarItem(title: nil, image: settingsImage, selectedImage: settingsSelectedImage)
        settings.tabBarItem.imageInsets = UIEdgeInsets(top: 8, left: 0, bottom: -8, right: 0)

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
