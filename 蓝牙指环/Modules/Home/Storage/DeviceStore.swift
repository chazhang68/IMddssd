import Foundation

/// Device 信息存储模转
/// 描述了本地保存的已配对设备
struct SavedBCLDevice: Codable {
    let id: String              // peripheral ID
    let name: String            // 设备名称
    let timestamp: TimeInterval // 保存时间戳
}

final class DeviceStore {
    static let shared = DeviceStore()
    private let deviceKey = "saved_devices"
    private let bclDeviceKey = "saved_bcl_devices"

    // MARK: - Device 存储
    
    func load() -> [Device] {
        guard let data = UserDefaults.standard.data(forKey: deviceKey) else { return [] }
        return (try? JSONDecoder().decode([Device].self, from: data)) ?? []
    }

    func save(_ devices: [Device]) {
        let data = try? JSONEncoder().encode(devices)
        UserDefaults.standard.set(data, forKey: deviceKey)
    }

    func add(_ device: Device) {
        var list = load()
        if !list.contains(where: { $0.id == device.id }) {
            list.append(device)
            save(list)
        }
    }

    func remove(id: String) {
        var list = load()
        list.removeAll { $0.id == id }
        save(list)
    }
    
    // MARK: - BCLDevice 存储
    
    /// 保存 BCLDevice
    func save(_ bclDevice: BCLDevice) {
        var devices = loadBCLDevices()
        
        // 移除已存在的同名设备，避免重复
        devices.removeAll { $0.id == bclDevice.peripheralID }
        
        // 添加新设备
        let savedDevice = SavedBCLDevice(
            id: bclDevice.peripheralID,
            name: bclDevice.name,
            timestamp: Date().timeIntervalSince1970
        )
        devices.append(savedDevice)
        
        // 保存到 UserDefaults
        if let encoded = try? JSONEncoder().encode(devices) {
            UserDefaults.standard.set(encoded, forKey: bclDeviceKey)
            print("✅ BCLDevice 已保存: \(bclDevice.name)")
        }
    }
    
    /// 加载所有已保存的 BCLDevice
    func loadBCLDevices() -> [SavedBCLDevice] {
        guard let data = UserDefaults.standard.data(forKey: bclDeviceKey),
              let devices = try? JSONDecoder().decode([SavedBCLDevice].self, from: data) else {
            return []
        }
        return devices
    }
    
    /// 获取所有已保存 BCLDevice 的 ID
    func getAllBCLDeviceIDs() -> [String] {
        return loadBCLDevices().map { $0.id }
    }
    
    /// 移除指定的 BCLDevice
    /// - Parameter id: 设备 ID
    func removeBCLDevice(id: String) {
        var devices = loadBCLDevices()
        devices.removeAll { $0.id == id }
        
        // 保存更新后的列表
        if let encoded = try? JSONEncoder().encode(devices) {
            UserDefaults.standard.set(encoded, forKey: bclDeviceKey)
            print("✅ 已移除 BCLDevice: \(id)")
        }
    }
    
    /// 清除所有已保存的 BCLDevice（用于清除测试数据）
    func clearAllBCLDevices() {
        UserDefaults.standard.removeObject(forKey: bclDeviceKey)
        print("✅ 已清除所有已保存的 BCLDevice")
    }
    
    /// 清除所有设备数据（包括 Device 和 BCLDevice）
    func clearAllDevices() {
        UserDefaults.standard.removeObject(forKey: deviceKey)
        UserDefaults.standard.removeObject(forKey: bclDeviceKey)
        print("✅ 已清除所有设备数据")
    }
}

