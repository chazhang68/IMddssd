import UIKit

final class RingFeaturesTabBarController: UITabBarController {
    var device: Device?
    var bclDevice: BCLDevice?  // 真实蓝牙设备对象

    override func viewDidLoad() {
        super.viewDidLoad()
        tabBar.backgroundColor = UIColor(hex: 0x0E0F12)
        tabBar.tintColor = UIColor(hex: 0xFFD23A)
        tabBar.unselectedItemTintColor = UIColor.white.withAlphaComponent(0.6)
        tabBar.layer.cornerRadius = 24
        tabBar.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        tabBar.layer.masksToBounds = true

        let dashboard = RingDashboardViewController()
        dashboard.device = device
        dashboard.tabBarItem = UITabBarItem(title: nil, image: UIImage(systemName: "house.fill"), tag: 0)

        let health = RingHealthViewController()
        health.device = device
        health.bclDevice = bclDevice
        health.tabBarItem = UITabBarItem(title: nil, image: UIImage(systemName: "heart.fill"), tag: 1)

        let deviceSettings = RingDeviceSettingsViewController()
        deviceSettings.device = device
        deviceSettings.tabBarItem = UITabBarItem(title: nil, image: UIImage(systemName: "gearshape.fill"), tag: 2)

        viewControllers = [dashboard, health, deviceSettings]
        selectedIndex = 0
    }
}
