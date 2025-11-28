import UIKit

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
        
        // 不需要NavigationController包装，每个页面根据需要自己管理导航
        viewControllers = [home, community, settings]
    }
}