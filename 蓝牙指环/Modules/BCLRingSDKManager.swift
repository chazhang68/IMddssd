import Foundation
import BCLRingSDK
import CoreBluetooth

/// 勇芯智能戒指SDK管理器
class BCLRingSDKManager: NSObject, CBCentralManagerDelegate {
    
    static let shared = BCLRingSDKManager()
    
    private var centralManager: CBCentralManager?
    private var discoveredDevices: [BCLDevice] = []
    var onDeviceDiscovered: ((BCLDevice) -> Void)?
    var onConnectionStateChanged: ((String, Bool) -> Void)?
    
    override init() {
        super.init()
        setupBluetooth()
    }
    
    // MARK: - 蓝牙初始化
    
    private func setupBluetooth() {
        // 初始化中央设备管理器
        centralManager = CBCentralManager(delegate: self, queue: .main)
    }
    
    // MARK: - 设备搜索
    
    // 私有服务UUID: BAE80001-4F05-4503-8E65-3AF1F7329D1F (GATT Service 0x0001)
    private let ringServiceUUID = CBUUID(string: "BAE80001-4F05-4503-8E65-3AF1F7329D1F")
    // 私有UUID Base: BAE8xxxx-4F05-4503-8E65-3AF1F7329D1F
    private let ringUUIDBase = "BAE8"
    
    /// 开始搜索蓝牙设备
    func startScanning() {
        guard let centralManager = centralManager, centralManager.state == .poweredOn else {
            print("蓝牙未就绪")
            return
        }
        
        discoveredDevices.removeAll()
        
        // 搜索所有蓝牙设备（广播数据中可能不包含服务UUID，需通过制造商数据识别）
        centralManager.scanForPeripherals(withServices: nil, options: [
            CBCentralManagerScanOptionAllowDuplicatesKey: NSNumber(value: false)
        ])
        
        print("🔍 开始搜索所有蓝牙设备")
        print("   指环服务UUID: \(ringServiceUUID.uuidString)")
        print("   制造商识别符: 0xFF00-0xFF0F")
    }
    
    /// 停止搜索
    func stopScanning() {
        centralManager?.stopScan()
    }
    
    // MARK: - 设备连接
    
    /// 连接指定设备
    func connect(to device: BCLDevice) {
        if let peripheral = device.peripheral {
            centralManager?.connect(peripheral, options: nil)
        }
    }
    
    /// 断开连接
    func disconnect(from device: BCLDevice) {
        if let peripheral = device.peripheral {
            centralManager?.cancelPeripheralConnection(peripheral)
        }
    }
    
    // MARK: - CBCentralManagerDelegate
    
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        switch central.state {
        case .poweredOn:
            print("蓝牙已打开")
        case .poweredOff:
            print("蓝牙已关闭")
        case .resetting:
            print("蓝牙正在重置")
        case .unauthorized:
            print("蓝牙权限未授权")
        case .unknown:
            print("蓝牙状态未知")
        case .unsupported:
            print("设备不支持蓝牙")
        @unknown default:
            print("蓝牙状态未知")
        }
    }
    
    func centralManager(
        _ central: CBCentralManager,
        didDiscover peripheral: CBPeripheral,
        advertisementData: [String : Any],
        rssi RSSI: NSNumber
    ) {
        let deviceName = peripheral.name ?? "未知设备"
        
        // 打印所有发现的设备
        print("\n📱 发现设备: \(deviceName)")
        print("   UUID: \(peripheral.identifier.uuidString)")
        print("   RSSI: \(RSSI) dBm")
        
        // 打印广播服务UUID
        if let serviceUUIDs = advertisementData[CBAdvertisementDataServiceUUIDsKey] as? [CBUUID] {
            print("   广播服务: \(serviceUUIDs.map { $0.uuidString }.joined(separator: ", "))")
        } else {
            print("   广播服务: 无")
        }
        
        // 打印制造商数据（关键识别信息）
        var hasManufacturerData = false
        if let manufacturerData = advertisementData[CBAdvertisementDataManufacturerDataKey] as? Data {
            hasManufacturerData = true
            let hexString = manufacturerData.map { String(format: "%02x", $0) }.joined(separator: " ")
            print("   制造商数据: \(hexString) (\(manufacturerData.count) bytes)")
            
            // 解析制造商数据结构：前6字节MAC + 后2字节识别符
            if manufacturerData.count >= 8 {
                let macBytes = manufacturerData.prefix(6)
                let macString = macBytes.map { String(format: "%02x", $0) }.joined(separator: ":")
                print("   MAC地址: \(macString)")
                
                let identifierBytes = manufacturerData.suffix(2)
                let identifier = UInt16(identifierBytes[identifierBytes.startIndex]) | 
                                (UInt16(identifierBytes[identifierBytes.index(after: identifierBytes.startIndex)]) << 8)
                print("   识别符: 0x\(String(format: "%04X", identifier))")
            }
        } else {
            print("   制造商数据: 无")
        }
        
        // 判断是否为指环设备
        var isRingDevice = false
        var matchReason = ""
        
        // 方法1: 检查制造商识别符 (0xFF00-0xFF0F) - 根据协议优先级最高
        if hasManufacturerData,
           let manufacturerData = advertisementData[CBAdvertisementDataManufacturerDataKey] as? Data,
           manufacturerData.count >= 8 {
            let identifierBytes = manufacturerData.suffix(2)
            let identifier = UInt16(identifierBytes[identifierBytes.startIndex]) | 
                            (UInt16(identifierBytes[identifierBytes.index(after: identifierBytes.startIndex)]) << 8)
            
            // 协议文档中的识别符: 0xFF00-0xFF0F
            if identifier >= 0xFF00 && identifier <= 0xFF0F {
                isRingDevice = true
                matchReason = "制造商识别符匹配(0x\(String(format: "%04X", identifier)))"
            }
        }
        
        // 方法2: 检查服务UUID（包含BAE8开头的私有UUID）
        if !isRingDevice, let serviceUUIDs = advertisementData[CBAdvertisementDataServiceUUIDsKey] as? [CBUUID] {
            for uuid in serviceUUIDs {
                let uuidString = uuid.uuidString
                if uuidString.uppercased().hasPrefix(ringUUIDBase) {
                    isRingDevice = true
                    matchReason = "服务UUID匹配(\(uuidString))"
                    break
                }
            }
        }
        
        // 方法3: 设备名称关键字（辅助判断，优先级最低）
        if !isRingDevice, !deviceName.isEmpty && deviceName != "未知设备" {
            let ringKeywords = ["ring", "指环", "smart", "bcl", "ysh"]
            if ringKeywords.contains(where: { deviceName.lowercased().contains($0.lowercased()) }) {
                isRingDevice = true
                matchReason = "设备名称关键字匹配"
            }
        }
        
        // 只将指环设备添加到列表
        if isRingDevice {
            let device = BCLDevice(
                name: deviceName,
                peripheralID: peripheral.identifier.uuidString,
                rssi: RSSI.intValue,
                peripheral: peripheral
            )
            
            if !discoveredDevices.contains(where: { $0.peripheralID == device.peripheralID }) {
                discoveredDevices.append(device)
                print("✅ 识别为智能指环设备！")
                print("   匹配原因: \(matchReason)")
                print("   已添加到搜索列表")
                onDeviceDiscovered?(device)
            }
        } else {
            print("❌ 非指环设备，已过滤")
        }
        
        print("" + String(repeating: "-", count: 60))
    }
    
    func centralManager(
        _ central: CBCentralManager,
        didConnect peripheral: CBPeripheral
    ) {
        print("已连接设备: \(peripheral.name ?? "未知")")
        if let device = discoveredDevices.first(where: { $0.peripheralID == peripheral.identifier.uuidString }) {
            onConnectionStateChanged?(device.name, true)
        }
    }
    
    func centralManager(
        _ central: CBCentralManager,
        didDisconnectPeripheral peripheral: CBPeripheral,
        error: Error?
    ) {
        print("已断开设备: \(peripheral.name ?? "未知")")
        if let device = discoveredDevices.first(where: { $0.peripheralID == peripheral.identifier.uuidString }) {
            onConnectionStateChanged?(device.name, false)
        }
    }
    
    func centralManager(
        _ central: CBCentralManager,
        didFailToConnect peripheral: CBPeripheral,
        error: Error?
    ) {
        print("连接失败: \(peripheral.name ?? "未知"), 错误: \(error?.localizedDescription ?? "未知错误")")
    }
}

// MARK: - 设备数据模型

struct BCLDevice {
    let name: String
    let peripheralID: String
    let rssi: Int
    let peripheral: CBPeripheral?
    
    /// 信号强度等级 (0-100)
    var signalStrength: Int {
        let strength = max(0, rssi + 100)
        return min(100, strength)
    }
    
    /// 信号强度描述
    var signalDescription: String {
        switch rssi {
        case -50...0:
            return "优秀"
        case -70...(-51):
            return "良好"
        case -90...(-71):
            return "一般"
        default:
            return "较弱"
        }
    }
}
