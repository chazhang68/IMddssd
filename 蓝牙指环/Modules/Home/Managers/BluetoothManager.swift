import Foundation
import CoreBluetooth

/// 蓝牙管理器协议 - 定义蓝牙搜索和连接回调
protocol BluetoothManagerDelegate: AnyObject {
    /// 发现新设备
    /// - Parameter device: 发现的设备
    func bluetoothManager(_ manager: BluetoothManager, didDiscoverDevice device: Device)
    
    /// 设备列表更新
    /// - Parameter devices: 当前发现的所有设备
    func bluetoothManager(_ manager: BluetoothManager, didUpdateDevices devices: [Device])
    
    /// 设备连接状态变化
    /// - Parameter device: 连接状态变化的设备
    func bluetoothManager(_ manager: BluetoothManager, didUpdateConnectionState device: Device)
    
    /// 蓝牙状态变化
    /// - Parameter isPoweredOn: 蓝牙是否开启
    func bluetoothManager(_ manager: BluetoothManager, didUpdateBluetoothState isPoweredOn: Bool)
    
    /// 搜索完成
    func bluetoothManagerDidFinishScanning(_ manager: BluetoothManager)
}

/// 蓝牙管理器 - 处理蓝牙设备扫描和连接
/// 使用 CoreBluetooth 框架与真实蓝牙设备交互
class BluetoothManager: NSObject {
    
    // MARK: - 属性定义
    
    /// 蓝牙中央管理器
    private var centralManager: CBCentralManager?
    
    /// 已发现的设备字典（以UUID为键）
    private var discoveredPeripherals: [UUID: (peripheral: CBPeripheral, device: Device)] = [:]
    
    /// 当前连接的设备
    private var connectedPeripheral: CBPeripheral?
    
    /// 当前连接的设备UUID
    private var connectedDeviceUUID: UUID?
    
    /// 代理对象
    weak var delegate: BluetoothManagerDelegate?
    
    /// 是否正在扫描
    private(set) var isScanning = false
    
    /// 扫描超时计时器
    private var scanTimeout: Timer?
    
    // MARK: - 初始化方法
    
    override init() {
        super.init()
        // 创建中央管理器，在主线程初始化
        DispatchQueue.main.async { [weak self] in
            self?.centralManager = CBCentralManager(delegate: self, queue: .main)
        }
    }
    
    // MARK: - 公开方法
    
    /// 开始扫描蓝牙设备
    /// 扫描超时时间为15秒
    func startScanning() {
        guard let centralManager = centralManager, centralManager.state == .poweredOn else {
            print("蓝牙未就绪，无法开始扫描")
            delegate?.bluetoothManager(self, didUpdateBluetoothState: false)
            return
        }
        
        // 清空之前的发现的设备
        discoveredPeripherals.removeAll()
        
        // 启动扫描
        isScanning = true
        
        // 只搜索支持的服务（如果为空则搜索所有设备）
        // 为了兼容性，我们搜索所有设备
        centralManager.scanForPeripherals(withServices: nil, options: [
            CBCentralManagerScanOptionAllowDuplicatesKey: false
        ])
        
        print("开始蓝牙设备扫描...")
        
        // 设置扫描超时（15秒后自动停止）
        setScanTimeout()
    }
    
    /// 停止扫描蓝牙设备
    func stopScanning() {
        guard let centralManager = centralManager else { return }
        
        if isScanning {
            centralManager.stopScan()
            isScanning = false
            scanTimeout?.invalidate()
            scanTimeout = nil
            print("蓝牙设备扫描已停止")
            delegate?.bluetoothManagerDidFinishScanning(self)
        }
    }
    
    /// 连接指定设备
    /// - Parameter device: 要连接的设备
    func connect(to device: Device) {
        guard let centralManager = centralManager,
              let uuid = UUID(uuidString: device.id),
              let peripheralInfo = discoveredPeripherals[uuid],
              centralManager.state == .poweredOn else {
            print("无法连接设备：蓝牙未就绪")
            return
        }
        
        // 停止扰描
        stopScanning()
        
        // 开始连接
        let peripheral = peripheralInfo.peripheral
        connectedPeripheral = peripheral
        connectedDeviceUUID = uuid
        
        print("正在连接设备：\(device.name)")
        centralManager.connect(peripheral, options: nil)
    }
    
    /// 断开指定设备
    /// - Parameter device: 要断开的设备
    func disconnect(from device: Device) {
        guard let centralManager = centralManager,
              let uuid = UUID(uuidString: device.id),
              let peripheralInfo = discoveredPeripherals[uuid] else {
            return
        }
        
        let peripheral = peripheralInfo.peripheral
        if peripheral.state == .connected || peripheral.state == .connecting {
            centralManager.cancelPeripheralConnection(peripheral)
            print("正在断开设备：\(device.name)")
        }
    }
    
    /// 获取所有已发现的设备
    func getDiscoveredDevices() -> [Device] {
        return discoveredPeripherals.values.map { $0.device }
    }
    
    // MARK: - 私有方法
    
    /// 设置扫描超时
    private func setScanTimeout() {
        scanTimeout?.invalidate()
        scanTimeout = Timer.scheduledTimer(withTimeInterval: 15.0, repeats: false) { [weak self] _ in
            self?.stopScanning()
        }
    }
    
    /// 创建Device对象从CBPeripheral
    private func createDevice(from peripheral: CBPeripheral, rssi: NSNumber) -> Device {
        let uuid = peripheral.identifier
        let name = peripheral.name ?? "未知设备"
        
        // 根据设备名称推断设备类型
        let deviceType = inferDeviceType(from: name)
        
        return Device(
            id: uuid.uuidString,
            name: name,
            type: deviceType,
            rssi: rssi.intValue,
            isConnected: peripheral.state == .connected,
            isConnecting: peripheral.state == .connecting,
            batteryPercentage: nil  // CoreBluetooth不能直接获取电池信息
        )
    }
    
    /// 推断设备类型
    private func inferDeviceType(from name: String) -> DeviceType {
        let lowerName = name.lowercased()
        
        if lowerName.contains("airpods") || lowerName.contains("earphone") || lowerName.contains("headphone") {
            return .headphones
        } else if lowerName.contains("watch") || lowerName.contains("smartwatch") {
            return .watch
        } else if lowerName.contains("glass") || lowerName.contains("眼镜") {
            return .glasses
        } else if lowerName.contains("iphone") || lowerName.contains("手机") {
            return .phone
        } else if lowerName.contains("ipad") || lowerName.contains("平板") {
            return .tablet
        } else if lowerName.contains("mac") || lowerName.contains("电脑") || lowerName.contains("laptop") {
            return .laptop
        } else if lowerName.contains("camera") || lowerName.contains("相机") {
            return .camera
        } else if lowerName.contains("speaker") || lowerName.contains("音箱") {
            return .speaker
        } else {
            return .other
        }
    }
}

// MARK: - CBCentralManagerDelegate

extension BluetoothManager: CBCentralManagerDelegate {
    
    /// 蓝牙状态变化回调
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        let isPoweredOn = central.state == .poweredOn
        print("蓝牙状态: \(central.state.description)")
        
        if isPoweredOn {
            print("蓝牙已启用")
        } else {
            print("蓝牙已禁用或不可用")
            stopScanning()
        }
        
        delegate?.bluetoothManager(self, didUpdateBluetoothState: isPoweredOn)
    }
    
    /// 发现外围设备
    func centralManager(
        _ central: CBCentralManager,
        didDiscover peripheral: CBPeripheral,
        advertisementData: [String : Any],
        rssi: NSNumber
    ) {
        // 创建设备对象
        let device = createDevice(from: peripheral, rssi: rssi)
        
        // 保存设备信息
        let uuid = peripheral.identifier
        discoveredPeripherals[uuid] = (peripheral, device)
        
        print("发现设备：\(device.name) (\(device.rssi) dBm)")
        
        // 通知代理
        delegate?.bluetoothManager(self, didDiscoverDevice: device)
        
        // 更新设备列表
        let allDevices = getDiscoveredDevices()
        delegate?.bluetoothManager(self, didUpdateDevices: allDevices)
    }
    
    /// 连接设备成功
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        print("设备已连接：\(peripheral.name ?? "未知")")
        
        // 更新已连接设备
        if let uuid = discoveredPeripherals.first(where: { $0.value.peripheral.identifier == peripheral.identifier })?.key,
           var device = discoveredPeripherals[uuid]?.device {
            device.isConnected = true
            device.isConnecting = false
            discoveredPeripherals[uuid]?.device = device
            
            delegate?.bluetoothManager(self, didUpdateConnectionState: device)
            
            // 更新整个设备列表
            let allDevices = getDiscoveredDevices()
            delegate?.bluetoothManager(self, didUpdateDevices: allDevices)
        }
        
        // 可选：发现服务
        peripheral.delegate = self
        peripheral.discoverServices(nil)
    }
    
    /// 连接设备失败
    func centralManager(
        _ central: CBCentralManager,
        didFailToConnect peripheral: CBPeripheral,
        error: Error?
    ) {
        print("连接失败：\(peripheral.name ?? "未知") - \(error?.localizedDescription ?? "未知错误")")
        
        // 更新设备状态
        if let uuid = discoveredPeripherals.first(where: { $0.value.peripheral.identifier == peripheral.identifier })?.key,
           var device = discoveredPeripherals[uuid]?.device {
            device.isConnected = false
            device.isConnecting = false
            discoveredPeripherals[uuid]?.device = device
            
            delegate?.bluetoothManager(self, didUpdateConnectionState: device)
        }
    }
    
    /// 断开设备连接
    func centralManager(
        _ central: CBCentralManager,
        didDisconnectPeripheral peripheral: CBPeripheral,
        error: Error?
    ) {
        print("设备已断开：\(peripheral.name ?? "未知")")
        
        // 更新设备状态
        if let uuid = discoveredPeripherals.first(where: { $0.value.peripheral.identifier == peripheral.identifier })?.key,
           var device = discoveredPeripherals[uuid]?.device {
            device.isConnected = false
            device.isConnecting = false
            discoveredPeripherals[uuid]?.device = device
            
            delegate?.bluetoothManager(self, didUpdateConnectionState: device)
        }
        
        if connectedPeripheral?.identifier == peripheral.identifier {
            connectedPeripheral = nil
            connectedDeviceUUID = nil
        }
    }
}

// MARK: - CBPeripheralDelegate

extension BluetoothManager: CBPeripheralDelegate {
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        if let error = error {
            print("发现服务失败：\(error.localizedDescription)")
            return
        }
        
        print("已发现服务：\(peripheral.name ?? "未知")")
    }
}

// MARK: - CBManagerState 描述扩展

extension CBManagerState {
    var description: String {
        switch self {
        case .unknown:
            return "未知"
        case .resetting:
            return "重置中"
        case .unsupported:
            return "不支持"
        case .unauthorized:
            return "未授权"
        case .poweredOff:
            return "已关闭"
        case .poweredOn:
            return "已启用"
        @unknown default:
            return "未知状态"
        }
    }
}
