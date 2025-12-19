import UIKit
#if canImport(BCLRingSDK)
import BCLRingSDK
#endif

/// 欢迎页界面 - 对应提供的设计稿（含三种状态交互）
 class WelcomeViewController: UIViewController {
    
    enum State {
        case idle
        case searching
    }
    
    // MARK: - UI
    private let topCard = UIView()
    private let badgeStack = UIStackView()
    private let welcomeLabel = UILabel()
    private let brandLabel = UILabel()
    
    private let ctaContainer = UIControl()
    private let ctaLeftLabel = UILabel()
    private let ctaRightButton = UIButton(type: .system)
    
    private let stripesContainer = UIView()
    private let subtitleLabel = UILabel()
    private let tipTitleLabel = UILabel()
    private let tipSubLabel = UILabel()
    private let iconsStack = UIStackView()
    
    private let bottomCard = UIView()
    private let bottomStack = UIStackView()
    
    // 数据：模拟扫描结果
//    private var devices: [String] = ["MT AI Glasses", "Earphones", "Earphones", "Earphones", "Earphones"]
    private var state: State = .idle {
        didSet { applyState() }
    }
    
    
    
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
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(hex: 0x0E0F12)
        setupTopCard()
        setupContent()
        setupStripes()
//        setupBottomCard()
        setupBCLSDK()
        applyState()
    }
    
    // MARK: - UI Setup
    private func setupTopCard() {
        topCard.backgroundColor = UIColor(hex: 0xFFD23A)
        topCard.layer.cornerRadius = 48
        topCard.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        topCard.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(topCard)
        
        NSLayoutConstraint.activate([
            topCard.topAnchor.constraint(equalTo: view.topAnchor),
            topCard.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            topCard.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            topCard.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.62)
        ])
        
        // 顶部头像/图标
        badgeStack.axis = .horizontal
        badgeStack.alignment = .center
        badgeStack.spacing = 16
        badgeStack.translatesAutoresizingMaskIntoConstraints = false
        topCard.addSubview(badgeStack)
        
        let firstBadge = makeBadge(image: UIImage(systemName: "bolt.fill"), tint: .white, bg: UIColor.black)
        let secondBadge = makeBadge(image: UIImage(systemName: "face.smiling"), tint: .white, bg: UIColor(hex: 0x1F1F1F))
        badgeStack.addArrangedSubview(firstBadge)
        badgeStack.addArrangedSubview(secondBadge)
        
        // 标题
        welcomeLabel.text = "Welcome to"
        welcomeLabel.font = .systemFont(ofSize: 36, weight: .bold)
        welcomeLabel.textColor = UIColor(hex: 0x0E0F12)
        welcomeLabel.numberOfLines = 1
        welcomeLabel.translatesAutoresizingMaskIntoConstraints = false
        topCard.addSubview(welcomeLabel)
        
        brandLabel.text = "SKYEAGLE"
        brandLabel.font = .systemFont(ofSize: 56, weight: .heavy)
        brandLabel.textColor = UIColor(hex: 0x6A5600)
        brandLabel.numberOfLines = 1
        brandLabel.translatesAutoresizingMaskIntoConstraints = false
        topCard.addSubview(brandLabel)
        
        // CTA 容器
        ctaContainer.backgroundColor = UIColor(hex: 0x0E0F12)
        ctaContainer.layer.cornerRadius = 28
        ctaContainer.addTarget(self, action: #selector(ctaTapped), for: .touchUpInside)
        ctaContainer.translatesAutoresizingMaskIntoConstraints = false
        topCard.addSubview(ctaContainer)
        
        let ctaStack = UIStackView(arrangedSubviews: [ctaLeftLabel, UIView(), ctaRightButton])
        ctaStack.axis = .horizontal
        ctaStack.alignment = .center
        ctaStack.spacing = 12
        ctaStack.translatesAutoresizingMaskIntoConstraints = false
        ctaContainer.addSubview(ctaStack)
        
        ctaLeftLabel.font = .systemFont(ofSize: 22, weight: .semibold)
        ctaLeftLabel.textColor = .white
        
        ctaRightButton.titleLabel?.font = .systemFont(ofSize: 20, weight: .semibold)
        ctaRightButton.setTitleColor(UIColor(hex: 0xFF4B4B), for: .normal)
        ctaRightButton.addTarget(self, action: #selector(cancelTapped), for: .touchUpInside)
        ctaRightButton.contentEdgeInsets = .zero
        
        NSLayoutConstraint.activate([
            badgeStack.topAnchor.constraint(equalTo: topCard.safeAreaLayoutGuide.topAnchor, constant: 16),
            badgeStack.trailingAnchor.constraint(equalTo: topCard.trailingAnchor, constant: -20),
            
            welcomeLabel.leadingAnchor.constraint(equalTo: topCard.leadingAnchor, constant: 24),
            welcomeLabel.topAnchor.constraint(equalTo: badgeStack.bottomAnchor, constant: 60),
            
            brandLabel.leadingAnchor.constraint(equalTo: welcomeLabel.leadingAnchor),
            brandLabel.topAnchor.constraint(equalTo: welcomeLabel.bottomAnchor, constant: 12),
            
            ctaContainer.leadingAnchor.constraint(equalTo: topCard.leadingAnchor, constant: 24),
            ctaContainer.trailingAnchor.constraint(equalTo: topCard.trailingAnchor, constant: -24),
            ctaContainer.bottomAnchor.constraint(equalTo: topCard.bottomAnchor, constant: -36),
            ctaContainer.heightAnchor.constraint(equalToConstant: 64),
            
            ctaStack.leadingAnchor.constraint(equalTo: ctaContainer.leadingAnchor, constant: 18),
            ctaStack.trailingAnchor.constraint(equalTo: ctaContainer.trailingAnchor, constant: -18),
            ctaStack.topAnchor.constraint(equalTo: ctaContainer.topAnchor),
            ctaStack.bottomAnchor.constraint(equalTo: ctaContainer.bottomAnchor)
        ])
    }
    
    private func setupContent() {
        subtitleLabel.text = "Trendy & Fun Designs, All Here."
        subtitleLabel.font = .systemFont(ofSize: 22, weight: .heavy)
        subtitleLabel.textColor = UIColor.white.withAlphaComponent(0.28)
        subtitleLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(subtitleLabel)
        
        tipTitleLabel.text = "Automatically find devices"
        tipTitleLabel.font = .systemFont(ofSize: 22, weight: .heavy)
        tipTitleLabel.textColor = UIColor(white: 1, alpha: 0.6)
        tipTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        tipTitleLabel.isHidden = true
        view.addSubview(tipTitleLabel)
        
        tipSubLabel.text = "Please turn on Bluetooth"
        tipSubLabel.font = .systemFont(ofSize: 24, weight: .heavy)
        tipSubLabel.textColor = UIColor(hex: 0xFFD23A)
        tipSubLabel.translatesAutoresizingMaskIntoConstraints = false
        tipSubLabel.isHidden = true
        view.addSubview(tipSubLabel)
        
        iconsStack.axis = .horizontal
        iconsStack.alignment = .center
        iconsStack.distribution = .equalSpacing
        iconsStack.spacing = 18
        iconsStack.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(iconsStack)
        
        let iconNames = ["headphones", "externaldrive", "iphone.gen2", "gamecontroller", "earbuds"]
        iconNames.forEach { name in
            let img = UIImageView(image: UIImage(systemName: name))
            img.tintColor = UIColor.white.withAlphaComponent(0.35)
            img.contentMode = .scaleAspectFit
            img.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                img.widthAnchor.constraint(equalToConstant: 28),
                img.heightAnchor.constraint(equalToConstant: 24)
            ])
            iconsStack.addArrangedSubview(img)
        }
        
        NSLayoutConstraint.activate([
            subtitleLabel.topAnchor.constraint(equalTo: topCard.bottomAnchor, constant: 28),
            subtitleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            subtitleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            
            tipTitleLabel.topAnchor.constraint(equalTo: topCard.bottomAnchor, constant: 28),
            tipTitleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            tipTitleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            
            tipSubLabel.topAnchor.constraint(equalTo: tipTitleLabel.bottomAnchor, constant: 8),
            tipSubLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            tipSubLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            
            iconsStack.topAnchor.constraint(equalTo: subtitleLabel.bottomAnchor, constant: 18),
            iconsStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            iconsStack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40)
        ])
    }
    
    private func setupStripes() {
        stripesContainer.translatesAutoresizingMaskIntoConstraints = false
        stripesContainer.backgroundColor = .clear
        view.insertSubview(stripesContainer, belowSubview: subtitleLabel)
        
        NSLayoutConstraint.activate([
            stripesContainer.topAnchor.constraint(equalTo: topCard.bottomAnchor),
            stripesContainer.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            stripesContainer.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            stripesContainer.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        addStripesLayer(to: stripesContainer)
    }
    
    private func setupBottomCard() {
        bottomCard.backgroundColor = UIColor(hex: 0x2B2B2B)
        bottomCard.layer.cornerRadius = 28
        bottomCard.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        bottomCard.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(bottomCard)
        
        bottomStack.axis = .horizontal
        bottomStack.alignment = .center
        bottomStack.distribution = .equalSpacing
        bottomStack.spacing = 48
        bottomStack.translatesAutoresizingMaskIntoConstraints = false
        bottomCard.addSubview(bottomStack)
        
        let bottomIcons: [(String, UIColor)] = [
            ("square.fill.on.square.fill", UIColor(hex: 0xFFD23A)),
            ("ellipsis.bubble", UIColor.white.withAlphaComponent(0.7)),
            ("person.crop.circle", UIColor.white.withAlphaComponent(0.7))
        ]
        bottomIcons.forEach { (name, tint) in
            let img = UIImageView(image: UIImage(systemName: name))
            img.tintColor = tint
            img.contentMode = .scaleAspectFit
            img.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                img.widthAnchor.constraint(equalToConstant: 28),
                img.heightAnchor.constraint(equalToConstant: 28)
            ])
            bottomStack.addArrangedSubview(img)
        }
        
        NSLayoutConstraint.activate([
            bottomCard.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            bottomCard.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            bottomCard.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            bottomCard.heightAnchor.constraint(equalToConstant: 140),
            
            bottomStack.centerXAnchor.constraint(equalTo: bottomCard.centerXAnchor),
            bottomStack.centerYAnchor.constraint(equalTo: bottomCard.centerYAnchor)
        ])
    }
    
    // MARK: - Actions
    @objc private func ctaTapped() {
        switch state {
        case .idle:
            startSearching()
        case .searching:
            presentDeviceSelector()
        }
    }
    
    @objc private func cancelTapped() {
        state =  state == .idle ? .searching : .idle
    }
    
    // MARK: - State Handling
    private func applyState() {
        switch state {
        case .idle:
            ctaLeftLabel.text = "Pairing devices"
            ctaRightButton.setImage(UIImage(systemName: "link"), for: .normal)
            ctaRightButton.setTitle(nil, for: .normal)
            ctaRightButton.tintColor = .white
            subtitleLabel.isHidden = false
            tipTitleLabel.isHidden = true
            tipSubLabel.isHidden = true
            NSLayoutConstraint.activate([
                iconsStack.topAnchor.constraint(equalTo: subtitleLabel.bottomAnchor, constant: 18)
            ])
            stopBCLSearch()
        case .searching:
            ctaLeftLabel.text = "Searching ..."
            ctaRightButton.setImage(nil, for: .normal)
            ctaRightButton.setTitle("cancel", for: .normal)
            ctaRightButton.setTitleColor(UIColor(hex: 0xFF4B4B), for: .normal)
            subtitleLabel.isHidden = true
            tipTitleLabel.isHidden = false
            tipSubLabel.isHidden = false
            NSLayoutConstraint.activate([
                iconsStack.topAnchor.constraint(equalTo: tipSubLabel.bottomAnchor, constant: 18)
            ])
            startSearching()
        }
    }
    
    private func startSearching() {
//        state = .searching
        // 这里可以接入真实蓝牙扫描逻辑，并在回调中展示设备列表
        // 演示：延迟后弹出选择列表
//        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
//            guard let self = self, self.state == .searching else { return }
//            self.presentDeviceSelector()
//        }
        startBCLSearch()
    }
    
    private func presentDeviceSelector() {
        let selector = DeviceSelectViewController()
        selector.modalPresentationStyle = .overFullScreen
        selector.devices = devices
        selector.onCancel = { [weak self] in
            self?.state = .idle
        }
        selector.onConnect = { [weak self] selected in
            print("Connect to: \(selected ?? "None")")
            self?.state = .idle
        }
        present(selector, animated: true)
    }
    
    // MARK: - Helpers
    private func makeBadge(image: UIImage?, tint: UIColor, bg: UIColor) -> UIView {
        let container = UIView()
        container.backgroundColor = bg
        container.layer.cornerRadius = 24
        container.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            container.widthAnchor.constraint(equalToConstant: 48),
            container.heightAnchor.constraint(equalToConstant: 48)
        ])
        
        let imageView = UIImageView(image: image)
        imageView.tintColor = tint
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(imageView)
        
        NSLayoutConstraint.activate([
            imageView.centerXAnchor.constraint(equalTo: container.centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: container.centerYAnchor),
            imageView.widthAnchor.constraint(equalToConstant: 24),
            imageView.heightAnchor.constraint(equalToConstant: 24)
        ])
        
        return container
    }
    
    private func addStripesLayer(to view: UIView) {
        let stripeWidth: CGFloat = 24
        let stripeSpacing: CGFloat = 24
        let angle = CGFloat(-25.0 * .pi / 180.0)
        
        let stripeLayer = CAShapeLayer()
        stripeLayer.strokeColor = UIColor.white.withAlphaComponent(0.04).cgColor
        stripeLayer.lineWidth = stripeWidth
        stripeLayer.lineCap = .square
        
        let path = UIBezierPath()
        let diagonal = sqrt(UIScreen.main.bounds.width * UIScreen.main.bounds.width + UIScreen.main.bounds.height * UIScreen.main.bounds.height)
        path.move(to: CGPoint(x: -diagonal, y: diagonal))
        path.addLine(to: CGPoint(x: diagonal, y: -diagonal))
        stripeLayer.path = path.cgPath
        
        let replicator = CAReplicatorLayer()
        replicator.instanceCount = Int((UIScreen.main.bounds.width + UIScreen.main.bounds.height) / (stripeWidth + stripeSpacing)) + 6
        replicator.instanceTransform = CATransform3DMakeTranslation(stripeWidth + stripeSpacing, 0, 0)
        replicator.addSublayer(stripeLayer)
        replicator.setAffineTransform(CGAffineTransform(rotationAngle: angle))
        
        view.layer.addSublayer(replicator)
    }
    
    
    
    /// 配置 BCL SDK 搜索回调
    private func setupBCLSDK() {
        let sdkManager = BCLRingSDKManager.shared
        
        // 设置设备发现回调
        sdkManager.onDeviceDiscovered = { [weak self] device in
            print("BCL SDK 发现设备: \(device.name)")
            self?.handleBCLDeviceDiscovered(device)
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
    
    
    /// 更新搜索结果视图
    private func updateSearchResultsViewController() {
        guard let searchVC = searchResultsViewController else { return }
        searchVC.discoveredDevices = bclDiscoveredDevices
        searchVC.isSearching = isSearching
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
//        updateUI()
    }
     
     func updateUI(){
         
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
    
//    /// 更新搜索结果视图
//    private func updateSearchResultsViewController() {
//        guard let searchVC = searchResultsViewController else { return }
//        searchVC.discoveredDevices = bclDiscoveredDevices
//        searchVC.isSearching = isSearching
//    }
    
    /// 刷新设备列表
    /// 重新搜索设备
    @objc private func refreshDevices() {
        if !isSearching {
            startBCLSearch()
        }
    }
    
    /// 显示指环详情页面
    private func showRingDetail(_ device: Device) {
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
//            homeView.deviceCollectionView.reloadItems(at: [IndexPath(item: index, section: 0)])
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
//            homeView.deviceCollectionView.reloadItems(at: [IndexPath(item: index, section: 0)])
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
//            homeView.deviceCollectionView.reloadItems(at: [IndexPath(item: index, section: 0)])
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
//            homeView.deviceCollectionView.reloadData()
//            updateUI()
        }
        
        // 设置全局管理器并连接设备
        BluetoothDeviceManager.shared.setCurrentDevice(bclDevice)
        BCLRingSDKManager.shared.connect(to: bclDevice)
        
        print("✅ 用户选择设备: \(bclDevice.name)")
    }


}

// MARK: - BluetoothManager代理

extension WelcomeViewController: BluetoothManagerDelegate {
    /// 螄牙管理器 - 发现新设备
    func bluetoothManager(_ manager: BluetoothManager, didDiscoverDevice device: Device) {
        print("发现了设备: \(device.name)")
    }
    
    /// 螄牙管理器 - 设备列表更新
    func bluetoothManager(_ manager: BluetoothManager, didUpdateDevices devices: [Device]) {
        self.devices = devices
//        homeView.deviceCollectionView.reloadData()
//        updateUI()
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
//            homeView.deviceCollectionView.reloadItems(at: [IndexPath(item: index, section: 0)])
//            updateUI()
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
//            updateUI()
        }
    }
    
    /// 螄牙管理器 - 扰描完成
    func bluetoothManagerDidFinishScanning(_ manager: BluetoothManager) {
        isSearching = false
//        updateUI()
        print("螄牙扰描完成")
    }
}
