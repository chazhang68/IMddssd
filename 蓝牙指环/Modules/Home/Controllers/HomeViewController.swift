import UIKit

import BCLRingSDK


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
        devices = []
        homeView.deviceCollectionView.reloadData()
        updateUI()
        
        // 监听心率测量完成通知
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(handleHeartRateMeasurementComplete(_:)),
            name: NSNotification.Name("HeartRateMeasurementComplete"),
            object: nil
        )
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
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
        sdkManager.onConnectionStateChanged = { [weak self] deviceName, isConnected in
            print("BCL SDK 设备 \(deviceName) 连接状态: \(isConnected)")
        }
    }
    
    /// 处理 BCL SDK 发现的设备
    /// - Parameter device: 新发现的 BCLDevice
    private func handleBCLDeviceDiscovered(_ device: BCLDevice) {
        // 检查设备是否已在列表中（避免重复）
        if !bclDiscoveredDevices.contains(where: { $0.peripheralID == device.peripheralID }) {
            bclDiscoveredDevices.append(device)
            print("✅ 已添加到搜索列表: \(device.name)")
            
            // 更新搜索结果视图
            updateSearchResultsViewController()
        }
    }
    
    /// 处理用户选择的 BCL 设备
    /// - Parameter bclDevice: 用户选择的设备
    private func handleSelectBCLDevice(_ bclDevice: BCLDevice) {
        // 停止搜索
        stopBCLSearch()
        
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
        } else if bclDevice.name.contains("ring") || bclDevice.name.contains("指环") || bclDevice.name.contains("Ring") {
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
            isConnecting: false,
            batteryPercentage: nil
        )
        
        // 添加到设备列表
        if !devices.contains(where: { $0.id == localDevice.id }) {
            devices.append(localDevice)
            homeView.deviceCollectionView.reloadData()
            updateUI()
        }
        
        // 设置全局管理器并连接设备
        BluetoothDeviceManager.shared.setCurrentDevice(bclDevice)
        BCLRingSDKManager.shared.connect(to: bclDevice)
        
        print("✅ 用户选择设备: \(bclDevice.name)")
    }

    /// 如果识别到的是指环，则将其添加到首页列表（仅指环显示）
    private func tryAddRingDeviceToHome(_ bclDevice: BCLDevice) {
        let isRing = bclDevice.name.contains("ring") || bclDevice.name.contains("指环") || bclDevice.name.contains("Ring")
        guard isRing else { return }
        let localDevice = Device(
            id: bclDevice.peripheralID,
            name: bclDevice.name,
            type: .ring,
            rssi: bclDevice.rssi,
            isConnected: false,
            isConnecting: false,
            batteryPercentage: nil
        )
        if !devices.contains(where: { $0.id == localDevice.id }) {
            devices.append(localDevice)
            homeView.deviceCollectionView.reloadData()
            updateUI()
        }
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
        let welcome = WelcomeViewController()
        push(welcome)
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
        
        // 显示搜索结果视图
        showSearchResultsViewController()
        
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
        
        // 设置设备选择回调
        searchVC.onDeviceSelected = { [weak self] device in
            self?.handleSelectBCLDevice(device)
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
