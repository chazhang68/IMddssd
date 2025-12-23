import UIKit
import CoreBluetooth
import SwiftUI


/// 首页视图控制器 - 设备搜索和管理
/// 负责蓝牙设备扫描、连接管理、用户交互处理
class HomeViewController: UIViewController {
    
    // MARK: - 属性定义
    
    /// 首页视图 - 包含设备搜索界面
    private let homeView = HomeView()
    
    /// 数据模型 - 管理应用状态
    private var model = HomeModel()
    
    /// 蓝牙管理器 - 处理蓝牙设备搜索和连接
    private lazy var bluetoothManager: BluetoothManager = {
        let manager = BluetoothManager()
        manager.delegate = self
        return manager
    }()
    
    /// 设备列表 - 存储搜索到的设备
    private var devices: [Device] = []
    
    /// 已连接设备 - 存储当前连接的设备
    private var connectedDevice: Device?
    
    /// 是否正在搜索 - 搜索状态标记
    private var isSearching = false
    
    /// BCL SDK搜索到的设备列表
    private var bclDiscoveredDevices: [BCLDevice] = []
    
    /// 搜索结果弹框
    private var searchResultsAlert: UIAlertController?
    
    /// 搜索结果视图控制器（用于更新）
    private var searchResultsViewController: SearchResultsViewController?
    private var isHandlingConnectionSuccess = false  // 防止重复处理连接成功
    
    // MARK: - 生命周期方法
    
    override func loadView() { 
        view = homeView 
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // 隐藏导航栏
        navigationController?.navigationBar.isHidden = true
        setupCollectionView()  // 配置集合视图
        wireActions()     // 绑定用户交互
        setupBCLSDK()    // 配置BCL SDK
        
        // 清除之前的测试数据（如果不需要清除，可以注释掉下面这行）
        #if DEBUG
        // 在调试模式下，可以选择清除测试数据
        // DeviceStore.shared.clearAllBCLDevices()
        #endif
        
        loadSavedDevices()  // 加载已保存的设备（注意：这会在 devices 数组中添加设备）
        // 不需要清空 devices，因为 loadSavedDevices() 已经加载了已保存的设备
        homeView.deviceCollectionView.reloadData()
        updateUI()
        
        // 启动自动重连（应用启动时自动连接已保存的设备）
        startAutoReconnect()
        
        // 监听心率测量完成通知
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(handleHeartRateMeasurementComplete(_:)),
            name: NSNotification.Name("HeartRateMeasurementComplete"),
            object: nil
        )
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // 每次页面显示时，检查已连接的设备
        checkConnectedDevices()
        // 刷新设备列表显示
        homeView.deviceCollectionView.reloadData()
        updateUI()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    /// 处理蓝牙连接状态变化通知
    @objc private func handleBluetoothConnectionStateChanged(_ notification: Notification) {
        // 从通知中获取设备信息
        let userInfo = notification.userInfo
        let deviceName = userInfo?["deviceName"] as? String
        let isConnected = userInfo?["isConnected"] as? Bool ?? false
        
        if isConnected, let deviceName = deviceName {
            print("📡 收到连接状态变化通知: \(deviceName) - 已连接")
            
            // 更新设备列表中的连接状态
            updateDeviceConnectionState(deviceName: deviceName, isConnected: true)
            
            // 如果连接成功，关闭搜索结果视图并返回首页
            DispatchQueue.main.async { [weak self] in
                self?.handleDeviceConnectedSuccessfully(deviceName: deviceName)
            }
        } else if BluetoothDeviceManager.shared.isDeviceConnected(),
                  let device = BluetoothDeviceManager.shared.getCurrentDevice() {
            // 备用方案：如果没有从通知中获取到设备名，从 BluetoothDeviceManager 获取
            let deviceName = device.name
            print("📡 收到连接状态变化通知（备用）: \(deviceName) - 已连接")
            
            // 更新设备列表中的连接状态
            updateDeviceConnectionState(deviceName: deviceName, isConnected: true)
            
            // 如果连接成功，关闭搜索结果视图并返回首页
            DispatchQueue.main.async { [weak self] in
                self?.handleDeviceConnectedSuccessfully(deviceName: deviceName)
            }
        }
    }
    
    @objc private func handleHeartRateMeasurementComplete(_ notification: Notification) {
        if let userInfo = notification.object as? [String: Any],
           let heartRate = userInfo["heartRate"] as? Int {
            print("✅ 接收到心率测量完成: \(heartRate)bpm")
            // 更新首页中的心率数据
            updateHeartRateData(heartRate: heartRate)
        }
    }
    
    private func updateHeartRateData(heartRate: Int) {
        // 根据你的应用逻辑更新心率数据
        // 事例：更新模型或UI最后刷新首页
        print("💳 更新心率数据: \(heartRate)bpm")
        // TODO: 实现您的业务逻辑，例如保存到数据库、更新UI等
    }
    
    // MARK: - 配置方法
    
    /// 配置 BCL SDK 搜索回调
    private func setupBCLSDK() {
        let sdkManager = BCLRingSDKManager.shared
        
        // 设置设备发现回调
        sdkManager.onDeviceDiscovered = { [weak self] device in
            print("BCL SDK 发现设备: \(device.name)")
            self?.handleBCLDeviceDiscovered(device)
            self?.tryAddRingDeviceToHome(device)
        }
        
        // 设置连接状态回调
        // 注意：BluetoothDeviceManager 也会设置这个回调，可能会覆盖
        // 所以我们同时监听通知来确保能收到连接状态变化
        sdkManager.onConnectionStateChanged = { [weak self] deviceName, isConnected in
            print("🔵 BCL SDK 设备 \(deviceName) 连接状态: \(isConnected ? "已连接" : "已断开")")
            
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                
                // 更新设备列表中的连接状态
                self.updateDeviceConnectionState(deviceName: deviceName, isConnected: isConnected)
                
                // 如果连接成功，关闭搜索结果视图并返回首页
                if isConnected {
                    print("✅ 检测到设备连接成功，准备返回首页: \(deviceName)")
                    self.handleDeviceConnectedSuccessfully(deviceName: deviceName)
                } else {
                    // 连接失败或断开，恢复连接中状态
                    self.handleDeviceConnectionFailed(deviceName: deviceName)
                }
            }
        }
        
        // 同时监听 BluetoothDeviceManager 的连接状态变化通知（作为备用，确保能收到连接状态）
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(handleBluetoothConnectionStateChanged(_:)),
            name: BluetoothDeviceManager.connectionStateChangedNotification,
            object: nil
        )
    }
    
    /// 处理 BCL SDK 发现的设备
    /// - Parameter device: 新发现的 BCLDevice
    private func handleBCLDeviceDiscovered(_ device: BCLDevice) {
        // 检查设备是否已在列表中（避免重复）
        if !bclDiscoveredDevices.contains(where: { $0.peripheralID == device.peripheralID }) {
            bclDiscoveredDevices.append(device)
            print("✅ 已添加到搜索列表: \(device.name)")
            
            // 如果还没有显示搜索结果视图，且找到第一个设备时，显示搜索结果视图
            if searchResultsViewController == nil && bclDiscoveredDevices.count == 1 {
                showSearchResultsViewController()
            }
            
            // 更新搜索结果视图
            updateSearchResultsViewController()
        }
    }
    
    /// 开始连接设备（点击 Connect 按钮后调用）
    /// - Parameter bclDevice: 要连接的设备
    private func startConnectingDevice(_ bclDevice: BCLDevice) {
        // 停止搜索
        stopBCLSearch()
        
        // 更新搜索结果视图，显示连接中状态
        if let searchVC = searchResultsViewController {
            searchVC.isConnecting = true
        }
        
        // 保存设备以便下次自动连接
        DeviceStore.shared.save(bclDevice)
        
        // 根据设备名称自动识别设备类型
        let deviceType: DeviceType
        if bclDevice.name.contains("MT AI Glasses") || bclDevice.name.contains("眼镜") {
            deviceType = .glasses
        } else if bclDevice.name.contains("Know-you pro") || bclDevice.name.contains("手表") {
            deviceType = .watch
        } else if bclDevice.name.contains("Earphones") || bclDevice.name.contains("耳机") {
            deviceType = .headphones
        } else if Device.isRingDevice(name: bclDevice.name) {
            deviceType = .ring
        } else {
            deviceType = .other
        }
        
        // 创建本地Device对象用于展示
        let localDevice = Device(
            id: bclDevice.peripheralID,
            name: bclDevice.name,
            type: deviceType,
            rssi: bclDevice.rssi,
            isConnected: false,
            isConnecting: true,  // 标记为连接中
            batteryPercentage: nil
        )
        
        // 添加到设备列表
        if !devices.contains(where: { $0.id == localDevice.id }) {
            devices.append(localDevice)
            homeView.deviceCollectionView.reloadData()
            updateUI()
        } else {
            // 如果设备已存在，更新为连接中状态
            if let index = devices.firstIndex(where: { $0.id == localDevice.id }) {
                devices[index] = localDevice
                homeView.deviceCollectionView.reloadItems(at: [IndexPath(item: index, section: 0)])
            }
        }
        
        // 设置全局管理器并连接设备
        BluetoothDeviceManager.shared.setCurrentDevice(bclDevice)
        BCLRingSDKManager.shared.connect(to: bclDevice)
        
        print("🔄 开始连接设备: \(bclDevice.name)")
        
        // 注意：不在这里关闭视图，等连接成功后再关闭
    }
    
    /// 处理用户选择的 BCL 设备（保留此方法用于兼容性）
    /// - Parameter bclDevice: 用户选择的设备
    private func handleSelectBCLDevice(_ bclDevice: BCLDevice) {
        startConnectingDevice(bclDevice)
    }

    /// 如果识别到的是指环，则将其添加到首页列表（仅指环显示）
    private func tryAddRingDeviceToHome(_ bclDevice: BCLDevice) {
        // 使用 Device 类统一的指环判断逻辑
        guard Device.isRingDevice(name: bclDevice.name) else { 
            print("⚠️ 设备 \(bclDevice.name) 不是指环设备，不添加到首页")
            return 
        }
        
        // 检查设备是否已连接
        let isConnected = BluetoothDeviceManager.shared.isDeviceConnected() && 
                         BluetoothDeviceManager.shared.getCurrentDevice()?.peripheralID == bclDevice.peripheralID
        
        let localDevice = Device(
            id: bclDevice.peripheralID,
            name: bclDevice.name,
            type: .ring,
            rssi: bclDevice.rssi,
            isConnected: isConnected,
            isConnecting: false,
            batteryPercentage: nil
        )
        
        if let existingIndex = devices.firstIndex(where: { $0.id == localDevice.id }) {
            // 如果设备已存在，更新状态
            devices[existingIndex] = localDevice
            if isConnected {
                connectedDevice = localDevice
            }
            print("✅ 更新已存在的指环设备: \(bclDevice.name), 连接状态: \(isConnected)")
        } else {
            // 如果设备不存在，添加到列表
            devices.append(localDevice)
            if isConnected {
                connectedDevice = localDevice
            }
            print("✅ 添加新的指环设备到首页: \(bclDevice.name), 连接状态: \(isConnected)")
        }
        
        homeView.deviceCollectionView.reloadData()
        updateUI()
    }
    
    /// 配置设备网格集合视图
    /// 设置数据源、代理和初始状态
    private func setupCollectionView() {
        homeView.deviceCollectionView.dataSource = self
        homeView.deviceCollectionView.delegate = self
        
        // 设置Collection View的大小
        if let layout = homeView.deviceCollectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            let itemWidth = (UIScreen.main.bounds.width - 48) / 2  // 2列，16pt的左右边距和16pt的间距
            let itemHeight = itemWidth * 1.35  // 长宽比
            layout.itemSize = CGSize(width: itemWidth, height: itemHeight)
        }
        
        updateUI()  // 更新初始UI状态
    }
    
    /// 绑定用户交互事件
    /// 连接按钮点击、搜索、刷新等操作
    private func wireActions() {
        // 返回按钮隐藏（在TabBar中不需要）
        homeView.backButton.isHidden = true
        
        // 菜单按钮事件
        homeView.menuButton.addTarget(self, action: #selector(menuTapped), for: .touchUpInside)
        
        // 设备控制按钮
        homeView.searchButton.addTarget(self, action: #selector(startDeviceSearch), for: .touchUpInside)
        homeView.refreshButton.addTarget(self, action: #selector(refreshDevices), for: .touchUpInside)
        homeView.scannerButton.addTarget(self, action: #selector(openScanner), for: .touchUpInside)
    }
    
    /// 更新UI状态
    /// 根据设备列表和搜索状态更新界面显示
    private func updateUI() {
        let hasDevices = !devices.isEmpty
        homeView.deviceCollectionView.isHidden = !hasDevices  // 有设备时显示集合视图
        homeView.emptyStateView.isHidden = hasDevices    // 有设备时隐藏空状态
        
//        // 更新搜索按钮状态
//        homeView.searchButton.setTitle(isSearching ? "停止搜索" : "搜索设备", for: .normal)
//        homeView.searchButton.backgroundColor = isSearching ? UIColor(hex: 0xFF5252) : UIColor(hex: 0xFFD700)
    }
    
    // MARK: - 数据管理
    
    /// 加载已保存的设备
    /// 从本地存储加载之前保存的设备，并在首页显示
    private func loadSavedDevices() {
        // 加载已保存的 BCL 设备
        let savedBCLDevices = DeviceStore.shared.loadBCLDevices()
        
        for savedDevice in savedBCLDevices {
            // 根据设备名称识别设备类型
            let deviceType: DeviceType
            if savedDevice.name.contains("MT AI Glasses") || savedDevice.name.contains("眼镜") {
                deviceType = .glasses
            } else if savedDevice.name.contains("Know-you pro") || savedDevice.name.contains("手表") {
                deviceType = .watch
            } else if savedDevice.name.contains("Earphones") || savedDevice.name.contains("耳机") {
                deviceType = .headphones
            } else if Device.isRingDevice(name: savedDevice.name) {
                // 使用统一的指环判断逻辑
                deviceType = .ring
            } else {
                deviceType = .other
            }
            
            // 创建本地 Device 对象
            let localDevice = Device(
                id: savedDevice.id,
                name: savedDevice.name,
                type: deviceType,
                rssi: -60,  // 默认信号强度
                isConnected: false,  // 初始状态为未连接，等待连接状态更新
                isConnecting: false,
                batteryPercentage: nil
            )
            
            // 添加到设备列表（仅显示指环设备，包括 BCL 开头的设备）
            if deviceType == .ring && !devices.contains(where: { $0.id == localDevice.id }) {
                devices.append(localDevice)
                print("✅ 已加载已保存的设备到首页: \(localDevice.name)")
            }
        }
        
        // 检查是否有已连接的设备
        checkConnectedDevices()
        
        print("✅ 已加载 \(devices.count) 个已保存的设备")
    }
    
    /// 检查已连接的设备
    /// 从 BCL SDK 管理器获取已连接的设备并更新状态
    private func checkConnectedDevices() {
        // 获取 BCL SDK 中已发现的设备
        let discoveredDevices = BCLRingSDKManager.shared.getDiscoveredDevices()
        
        // 在主线程中检查连接状态
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            
            for bclDevice in discoveredDevices {
                // 检查设备是否已连接
                // 使用可选绑定安全地访问 peripheral
                if let peripheral = bclDevice.peripheral {
                    // 检查 peripheral 的连接状态
                    let isConnected = (peripheral.state == .connected)
                    if isConnected {
                        // 更新设备连接状态
                        self.updateDeviceConnectionState(deviceName: bclDevice.name, isConnected: true)
                    }
                }
            }
        }
    }
    
    /// 更新设备连接状态
    /// - Parameters:
    ///   - deviceName: 设备名称
    ///   - isConnected: 是否已连接
    private func updateDeviceConnectionState(deviceName: String, isConnected: Bool) {
        // 在设备列表中查找匹配的设备（通过名称或ID）
        var targetIndex: Int?
        var targetDevice: Device?
        
        // 先尝试通过名称查找
        if let index = devices.firstIndex(where: { $0.name == deviceName }) {
            targetIndex = index
            targetDevice = devices[index]
        } else {
            // 如果名称不匹配，尝试通过 BCL SDK 查找设备ID
            if let bclDevice = BCLRingSDKManager.shared.findDevice(byName: deviceName),
               let index = devices.firstIndex(where: { $0.id == bclDevice.peripheralID }) {
                targetIndex = index
                targetDevice = devices[index]
            }
        }
        
        if let index = targetIndex, var device = targetDevice {
            // 更新连接状态
            device = Device(
                id: device.id,
                name: device.name,
                type: device.type,
                rssi: device.rssi,
                isConnected: isConnected,
                isConnecting: false,
                batteryPercentage: device.batteryPercentage
            )
            
            devices[index] = device
            
            // 更新已连接设备引用
            if isConnected {
                connectedDevice = device
            } else if connectedDevice?.id == device.id {
                connectedDevice = nil
            }
            
            // 更新 UI
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                self.homeView.deviceCollectionView.reloadItems(at: [IndexPath(item: index, section: 0)])
                self.updateUI()
            }
            
            print("✅ 已更新设备 \(deviceName) 的连接状态: \(isConnected ? "已连接" : "已断开")")
        } else {
            // 如果设备不在列表中，可能是新连接的设备，尝试从 BCL SDK 获取并添加
            if let bclDevice = BCLRingSDKManager.shared.findDevice(byName: deviceName) {
                // 添加到设备列表
                tryAddRingDeviceToHome(bclDevice)
                // 如果已连接，更新状态
                if isConnected {
                    // 延迟一下，确保设备已添加到列表
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { [weak self] in
                        self?.updateDeviceConnectionState(deviceName: deviceName, isConnected: true)
                    }
                }
            } else {
                print("⚠️ 未找到设备 \(deviceName)，无法更新连接状态")
            }
        }
    }
    
    /// 处理设备连接成功
    /// - Parameter deviceName: 已连接的设备名称
    private func handleDeviceConnectedSuccessfully(deviceName: String) {
        print("🔄 处理设备连接成功: \(deviceName)")
        print("   searchResultsViewController: \(searchResultsViewController != nil ? "存在" : "nil")")
        print("   presentedViewController: \(presentedViewController != nil ? "存在" : "nil")")
        
        // 防止重复处理（使用标志位）
        if isHandlingConnectionSuccess {
            print("⚠️ 正在处理连接成功，跳过重复调用")
            return
        }
        isHandlingConnectionSuccess = true
        
        // 确保设备已保存到缓存（连接成功后再次保存，确保缓存是最新的）
        if let bclDevice = BCLRingSDKManager.shared.findDevice(byName: deviceName) {
            DeviceStore.shared.save(bclDevice)
            print("✅ 设备已保存到缓存: \(bclDevice.name)")
        }
        
        // 关闭搜索结果视图并返回首页
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            
            // 关闭搜索结果视图（如果存在）
            if let searchVC = self.searchResultsViewController {
                print("✅ 找到搜索结果视图，准备关闭")
                // 恢复连接状态
                searchVC.isConnecting = false
                
                // 延迟一点关闭，让用户看到连接成功的反馈
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) { [weak self] in
                    guard let self = self else { return }
                    searchVC.dismiss(animated: true) { [weak self] in
                        self?.searchResultsViewController = nil
                        self?.isHandlingConnectionSuccess = false
                        // 刷新首页 UI
                        self?.refreshHomePageAfterConnection()
                        print("✅ 设备 \(deviceName) 连接成功，已返回首页")
                    }
                }
            } else {
                print("⚠️ 搜索结果视图不存在，检查是否有其他模态视图需要关闭")
                
                // 检查是否有其他模态视图需要关闭
                if let presentedVC = self.presentedViewController {
                    print("   发现其他模态视图: \(type(of: presentedVC))")
                    
                    // 如果是 SearchResultsViewController，先更新其状态
                    if let searchVC = presentedVC as? SearchResultsViewController {
                        searchVC.isConnecting = false
                        self.searchResultsViewController = nil
                    }
                    
                    // 关闭模态视图
                    presentedVC.dismiss(animated: true) { [weak self] in
                        // 确保返回到 TabBar 首页
                        self?.navigateToHomeTab()
                        // 延迟一点，确保视图切换完成后再刷新
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) { [weak self] in
                            // 刷新首页并显示指环
                            self?.refreshHomePageAfterConnection()
                            self?.isHandlingConnectionSuccess = false
                            print("✅ 已关闭模态视图，返回 TabBar 首页并显示指环")
                        }
                    }
                } else {
                    // 确保返回到 TabBar 首页
                    self.navigateToHomeTab()
                    // 延迟一点，确保视图切换完成后再刷新
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) { [weak self] in
                        // 刷新首页并显示指环
                        self?.refreshHomePageAfterConnection()
                        self?.isHandlingConnectionSuccess = false
                        print("✅ 已刷新首页，显示已连接的指环设备")
                    }
                }
            }
        }
    }
    
    /// 确保返回到首页
    private func ensureReturnToHomePage() {
        // 如果当前不在首页，导航回首页
        if let navController = navigationController {
            // 如果导航栈中有多个视图控制器，返回到根视图（首页）
            if navController.viewControllers.count > 1 {
                navController.popToRootViewController(animated: true)
                print("✅ 已导航回首页")
            }
        }
        
        // 确保当前视图控制器可见
        if !isViewLoaded || view.window == nil {
            print("⚠️ 首页视图未加载或不可见，可能需要重新加载")
        }
    }
    
    /// 导航到 TabBar 首页
    private func navigateToHomeTab() {
        // 获取 TabBar 控制器
        if let tabBarController = self.tabBarController {
            // 切换到首页 Tab（索引 0）
            tabBarController.selectedIndex = 0
            
            // 如果首页的导航栈中有多个视图控制器，返回到根视图
            if let homeNav = tabBarController.selectedViewController as? UINavigationController {
                if homeNav.viewControllers.count > 1 {
                    homeNav.popToRootViewController(animated: true)
                }
            }
            
            print("✅ 已切换到 TabBar 首页")
        } else if let window = view.window, let rootVC = window.rootViewController {
            // 如果没有 TabBar，尝试找到 TabBar 控制器
            if let tabBarController = findTabBarController(from: rootVC) {
                tabBarController.selectedIndex = 0
                if let homeNav = tabBarController.selectedViewController as? UINavigationController {
                    if homeNav.viewControllers.count > 1 {
                        homeNav.popToRootViewController(animated: true)
                    }
                }
                print("✅ 已切换到 TabBar 首页（通过查找）")
            }
        }
    }
    
    /// 递归查找 TabBar 控制器
    private func findTabBarController(from viewController: UIViewController) -> UITabBarController? {
        if let tabBarController = viewController as? UITabBarController {
            return tabBarController
        }
        
        if let navController = viewController as? UINavigationController {
            return findTabBarController(from: navController.viewControllers.first ?? navController)
        }
        
        if let presentedVC = viewController.presentedViewController {
            return findTabBarController(from: presentedVC)
        }
        
        return nil
    }
    
    /// 连接成功后刷新首页
    /// 确保首页显示已连接的设备
    private func refreshHomePageAfterConnection() {
        print("🔄 开始刷新首页，当前设备列表数量: \(devices.count)")
        
        // 确保已连接的指环设备添加到首页
        if let currentBCLDevice = BluetoothDeviceManager.shared.getCurrentDevice() {
            print("🔄 确保已连接的设备显示在首页: \(currentBCLDevice.name)")
            
            // 保存设备以便下次自动连接（重要：确保设备信息被保存）
            DeviceStore.shared.save(currentBCLDevice)
            print("✅ 设备已保存到缓存: \(currentBCLDevice.name)")
            
            // 添加到设备列表（如果还没有）
            tryAddRingDeviceToHome(currentBCLDevice)
            
            // 更新设备连接状态
            if let index = devices.firstIndex(where: { $0.id == currentBCLDevice.peripheralID }) {
                var device = devices[index]
                device = Device(
                    id: device.id,
                    name: device.name,
                    type: device.type,
                    rssi: device.rssi,
                    isConnected: true,
                    isConnecting: false,
                    batteryPercentage: device.batteryPercentage
                )
                devices[index] = device
                self.connectedDevice = device
                print("✅ 已更新设备连接状态: \(device.name), 已连接: \(device.isConnected)")
            } else {
                print("⚠️ 设备 \(currentBCLDevice.name) 不在列表中，尝试重新添加")
                // 如果不在列表中，再次尝试添加
                tryAddRingDeviceToHome(currentBCLDevice)
            }
        } else {
            print("⚠️ 当前没有已连接的设备")
        }
        
        print("🔄 刷新前设备列表数量: \(devices.count)")
        
        // 刷新设备列表
        homeView.deviceCollectionView.reloadData()
        
        // 更新 UI
        updateUI()
        
        // 检查已连接的设备
        checkConnectedDevices()
        
        print("✅ 首页已刷新，显示设备数量: \(devices.count)")
        if !devices.isEmpty {
            print("   设备列表: \(devices.map { "\($0.name)(\($0.isConnected ? "已连接" : "未连接"))" }.joined(separator: ", "))")
        }
    }
    
    /// 处理设备连接失败或断开
    /// - Parameter deviceName: 设备名称
    private func handleDeviceConnectionFailed(deviceName: String) {
        // 如果正在连接中，恢复状态
        if let searchVC = searchResultsViewController, searchVC.isConnecting {
            DispatchQueue.main.async {
                searchVC.isConnecting = false
            }
        }
    }
    
    /// 启动自动重连
    /// 应用启动时自动连接已保存的设备
    private func startAutoReconnect() {
        // 获取已保存的设备列表
        let savedDevices = DeviceStore.shared.loadBCLDevices()
        
        if !savedDevices.isEmpty {
            print("🔄 发现 \(savedDevices.count) 个已保存的设备，准备自动重连")
            
            // 使用 BCL SDK 的自动重连功能
            BCLRingSDKManager.shared.prepareAutoConnect()
            
            // 延迟一点时间，等待蓝牙就绪
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
                // 检查是否有已连接的设备
                self?.checkConnectedDevices()
            }
        } else {
            print("ℹ️ 没有已保存的设备，跳过自动重连")
        }
    }
    
    /// 加载模拟设备数据
    /// 用于开发和测试的设备列表
    private func loadMockDevices() { /* 已按需求禁用首页模拟数据，仅识别到指环后显示 */ }
    
    /// 搜索蓝牙设备（保留原有方法兼容性）
    /// 开始真实设备搜索过程
    private func performDeviceSearch() {
        startBCLSearch()
    }
    
    // MARK: - 事件处理方法
    
    /// 菜单按钮点击事件
    /// 打开菜单页面
    @objc private func menuTapped() { 
        let bindingView = BluetoothBindingView()
        let hostingController = UIHostingController(rootView: bindingView)
        hostingController.modalPresentationStyle = .fullScreen
        present(hostingController, animated: true, completion: nil)
    }
    
    /// 开始/停止设备搜索
    /// 切换搜索状态
    @objc private func startDeviceSearch() {
        if isSearching {
            // 停止搜索
            stopBCLSearch()
        } else {
            // 开始搜索
            startBCLSearch()
        }
    }
    
    /// 启动 BCL SDK 搜索
    private func startBCLSearch() {
        isSearching = true
        bclDiscoveredDevices.removeAll()  // 清空旧的设备列表
        updateUI()
        
        // 先不立即弹出，等找到设备后再弹出
        // 如果已经有搜索结果视图打开，则更新它
        if searchResultsViewController != nil {
            updateSearchResultsViewController()
        }
        
        // 调用 BCL SDK 搜索
        SDKIntegrationHelper.shared.prepareForDeviceSearch()
    }
    
    /// 停止 BCL SDK 搜索
    private func stopBCLSearch() {
        isSearching = false
        SDKIntegrationHelper.shared.stopDeviceSearch()
        updateUI()
    }
    
    /// 显示搜索结果视图控制器
    private func showSearchResultsViewController() {
        let searchVC = SearchResultsViewController()
        searchVC.discoveredDevices = bclDiscoveredDevices
        searchVC.isSearching = isSearching
        
        // 设置设备选择回调（点击 Connect 按钮时触发）
        searchVC.onDeviceSelected = { [weak self] device in
            // 开始连接设备，但不立即关闭视图
            self?.startConnectingDevice(device)
        }
        
        // 设置取消回调
        searchVC.onCancel = { [weak self] in
            self?.stopBCLSearch()
        }
        
        // 全屏蒙版显示
        searchVC.modalPresentationStyle = .overFullScreen
        searchVC.modalTransitionStyle = .crossDissolve
        
        // 存储引用以便更新
        self.searchResultsViewController = searchVC
        
        present(searchVC, animated: true)
    }
    
    /// 更新搜索结果视图
    private func updateSearchResultsViewController() {
        guard let searchVC = searchResultsViewController else { return }
        searchVC.discoveredDevices = bclDiscoveredDevices
        searchVC.isSearching = isSearching
    }
    
    /// 刷新设备列表
    /// 重新搜索设备
    @objc private func refreshDevices() {
        if !isSearching {
            startBCLSearch()
        }
    }
    
    @objc private func openScanner() {
        let view = QRScannerView { [weak self] code in
            print("扫码结果: \(code)")
            self?.dismiss(animated: true)
        }
        let hosting = UIHostingController(rootView: view)
        hosting.modalPresentationStyle = .fullScreen
        present(hosting, animated: true)
    }
    
    /// 显示指环详情页面
    private func showRingDetail(_ device: Device) {
        guard device.type == .ring else { return }
        let detailVC = RingDetailViewController()
        detailVC.device = device
        
        // 交给统一的导航控制器处理 Push
        push(detailVC)
    }
    
    /// 连接指定设备
    /// - Parameter device: 要连接的设备
    private func connectToDevice(_ device: Device) {
        // 断开当前连接
        if let connected = connectedDevice {
            disconnectDevice(connected)
        }
        
        // 更新设备状态为连接中
        if let index = devices.firstIndex(where: { $0.id == device.id }) {
            devices[index] = Device(
                id: device.id,
                name: device.name,
                type: device.type,
                rssi: device.rssi,
                isConnected: false,
                isConnecting: true,
                batteryPercentage: device.batteryPercentage
            )
            homeView.deviceCollectionView.reloadItems(at: [IndexPath(item: index, section: 0)])
        }
        
        // 优先使用BCL SDK连接
        if let bclDevice = bclDiscoveredDevices.first(where: { $0.peripheralID == device.id }) {
            SDKIntegrationHelper.shared.connectDevice(bclDevice)
        } else {
            // 备选：使用蓝牙管理器连接
            bluetoothManager.connect(to: device)
        }
    }
    
    /// 完成设备连接
    /// - Parameter device: 已连接的设备
    private func completeDeviceConnection(_ device: Device) {
        if let index = devices.firstIndex(where: { $0.id == device.id }) {
            devices[index] = Device(
                id: device.id,
                name: device.name,
                type: device.type,
                rssi: device.rssi,
                isConnected: true,
                isConnecting: false,
                batteryPercentage: device.batteryPercentage
            )
            connectedDevice = devices[index]
            homeView.deviceCollectionView.reloadItems(at: [IndexPath(item: index, section: 0)])
        }
    }
    
    /// 断开设备连接
    /// - Parameter device: 要断开的设备
    private func disconnectDevice(_ device: Device) {
        if let index = devices.firstIndex(where: { $0.id == device.id }) {
            devices[index] = Device(
                id: device.id,
                name: device.name,
                type: device.type,
                rssi: device.rssi,
                isConnected: false,
                isConnecting: false,
                batteryPercentage: device.batteryPercentage
            )
            if connectedDevice?.id == device.id {
                connectedDevice = nil
            }
            homeView.deviceCollectionView.reloadItems(at: [IndexPath(item: index, section: 0)])
        }
        
        // 使用蓝牙管理器断开
        bluetoothManager.disconnect(from: device)
    }
    
    /// 显示断开连接确认弹窗
    /// - Parameter device: 要断开的设备
    private func showDisconnectAlert(for device: Device) {
        let alert = UIAlertController(
            title: "断开连接",
            message: "确定要断开与 \(device.name) 的连接吗？",
            preferredStyle: .alert
        )
        
        alert.addAction(UIAlertAction(title: "取消", style: .cancel))
        alert.addAction(UIAlertAction(title: "断开", style: .destructive) { [weak self] _ in
            self?.disconnectDevice(device)
        })
        
        present(alert, animated: true)
    }
}

// MARK: - UICollectionView数据源

extension HomeViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return devices.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DeviceGridCell", for: indexPath) as! DeviceGridCell
        let device = devices[indexPath.item]
        
        // 配置单元格
        cell.configure(
            name: device.name,
            batteryPercentage: device.batteryPercentage,
            deviceType: device.type.systemIconName,
            backgroundImage: device.backgroundImage,
            isConnected: device.isConnected
        )
        
        return cell
    }
}

// MARK: - UICollectionView代理

extension HomeViewController: UICollectionViewDelegateFlowLayout {
    /// 设置单元格大小
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        // 2列布局，左右各16pt边距，中间16pt间距
        let padding: CGFloat = 16
        let spacing: CGFloat = 16
        let totalPadding = padding * 2 + spacing
        let cellWidth = (collectionView.frame.width - totalPadding) / 2
        let cellHeight: CGFloat = 200 // 设备卡片高度
        return CGSize(width: cellWidth, height: cellHeight)
    }
}

extension HomeViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let device = devices[indexPath.item]
        let tab = RingFeaturesTabBarController()
        tab.device = device
        
        // 使用 SDK 的公开方法找到对应的 BCLDevice
        if let bclDevice = BCLRingSDKManager.shared.findDevice(byName: device.name) {
            tab.bclDevice = bclDevice
            // 设置到全局管理器
            BluetoothDeviceManager.shared.setCurrentDevice(bclDevice)
            print("✅ 找到对应的 BCLDevice: \(bclDevice.name)")
        } else {
            print("❌ 未找到对应的 BCLDevice，设备名称: \(device.name)")
        }
        
        tab.modalPresentationStyle = .fullScreen
        present(tab, animated: true)
        
        collectionView.deselectItem(at: indexPath, animated: true)
    }
}

// MARK: - BluetoothManager代理

extension HomeViewController: BluetoothManagerDelegate {
    /// 螄牙管理器 - 发现新设备
    func bluetoothManager(_ manager: BluetoothManager, didDiscoverDevice device: Device) {
        print("发现了设备: \(device.name)")
    }
    
    /// 螄牙管理器 - 设备列表更新
    func bluetoothManager(_ manager: BluetoothManager, didUpdateDevices devices: [Device]) {
        self.devices = devices.filter { $0.type == .ring }
        homeView.deviceCollectionView.reloadData()
        updateUI()
    }
    
    /// 螄牙管理器 - 设备连接状态变化
    func bluetoothManager(_ manager: BluetoothManager, didUpdateConnectionState device: Device) {
        // 更新本地设备数据
        if let index = devices.firstIndex(where: { $0.id == device.id }) {
            devices[index] = device
            
            if device.isConnected {
                connectedDevice = device
            } else if connectedDevice?.id == device.id {
                connectedDevice = nil
            }
            
            // 更新 UI
            homeView.deviceCollectionView.reloadItems(at: [IndexPath(item: index, section: 0)])
            updateUI()
        }
    }
    
    /// 螄牙管理器 - 螄牙状态变化
    func bluetoothManager(_ manager: BluetoothManager, didUpdateBluetoothState isPoweredOn: Bool) {
        if isPoweredOn {
            print("螄牙已启用")
        } else {
            print("螄牙已禁用或不可用")
            // 清空设备列表
            devices.removeAll()
            updateUI()
        }
    }
    
    /// 螄牙管理器 - 扰描完成
    func bluetoothManagerDidFinishScanning(_ manager: BluetoothManager) {
        isSearching = false
        updateUI()
        print("螄牙扰描完成")
    }
}
