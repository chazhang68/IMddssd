import UIKit

final class RingFeaturesTabBarController: UITabBarController {
    var device: Device?
    var bclDevice: BCLDevice?  // 真实蓝牙设备对象

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(hex: 0x0E0F12)
        tabBar.isTranslucent = false
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor(hex: 0x2B2B2B)
        appearance.shadowColor = .clear
        tabBar.standardAppearance = appearance
        tabBar.scrollEdgeAppearance = appearance
        tabBar.tintColor = UIColor(hex: 0xFFD23A)
        tabBar.unselectedItemTintColor = UIColor.white.withAlphaComponent(0.6)
        tabBar.layer.cornerRadius = 40
        tabBar.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        tabBar.layer.masksToBounds = true

        let dashboard = RingDashboardViewController()
        dashboard.device = device
        dashboard.tabBarItem = UITabBarItem(title: nil, image: UIImage(systemName: "house.fill"), tag: 0)
        dashboard.tabBarItem.imageInsets = UIEdgeInsets(top: 8, left: 0, bottom: -8, right: 0)

        let health = RingHealthViewController()
        health.device = device
        health.bclDevice = bclDevice
        health.tabBarItem = UITabBarItem(title: nil, image: UIImage(systemName: "heart.fill"), tag: 1)
        health.tabBarItem.imageInsets = UIEdgeInsets(top: 8, left: 0, bottom: -8, right: 0)

        let deviceSettings = RingDeviceSettingsViewController()
        deviceSettings.device = device
        deviceSettings.tabBarItem = UITabBarItem(title: nil, image: UIImage(systemName: "gearshape.fill"), tag: 2)
        deviceSettings.tabBarItem.imageInsets = UIEdgeInsets(top: 8, left: 0, bottom: -8, right: 0)

        viewControllers = [dashboard, health, deviceSettings]
        selectedIndex = 0
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
}
