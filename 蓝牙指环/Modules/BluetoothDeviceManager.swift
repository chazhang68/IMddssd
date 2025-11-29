import Foundation

/// 全局蓝牙设备管理器 - 单例模式
/// 管理当前连接的 BCLDevice，所有功能模块都可以访问
/// 通过监听 SDK 的连接状态变化来更新管理状态
final class BluetoothDeviceManager {
    
    // MARK: - 单例
    
    static let shared = BluetoothDeviceManager()
    
    // MARK: - 属性
    
    /// 当前连接的蓝牙设备
    private(set) var currentDevice: BCLDevice?
    
    /// 当前设备的连接状态
    private(set) var isConnected: Bool = false
    
    /// 设备变化的通知名
    static let deviceDidChangeNotification = NSNotification.Name("BluetoothDeviceDidChange")
    static let connectionStateChangedNotification = NSNotification.Name("BluetoothConnectionStateChanged")
    
    // MARK: - 初始化
    
    private init() {
        setupSDKListeners()
    }
    
    // MARK: - SDK 监听器设置
    
    /// 设置 SDK 连接状态监听
    private func setupSDKListeners() {
        // 监听 BCLRingSDKManager 的连接状态变化
        BCLRingSDKManager.shared.onConnectionStateChanged = { [weak self] deviceName, isConnected in
            print("📡 SDK 连接状态变化: \(deviceName) - \(isConnected ? "已连接" : "已断开")")
            self?.handleConnectionStateChange(deviceName: deviceName, isConnected: isConnected)
        }
    }
    
    /// 处理 SDK 连接状态变化
    private func handleConnectionStateChange(deviceName: String, isConnected: Bool) {
        if isConnected {
            // 设备已连接
            // 使用 SDK 的公开方法找到对应设备
            if let bclDevice = BCLRingSDKManager.shared.findDevice(byName: deviceName) {
                self.currentDevice = bclDevice
                self.isConnected = true
                print("✅ 蓝牙设备已连接: \(deviceName)")
            }
        } else {
            // 设备已断开
            if currentDevice?.name == deviceName {
                self.isConnected = false
                print("⚠️  蓝牙设备已断开: \(deviceName)")
                // 暂不清除 currentDevice，以便保留设备信息
            }
        }
        
        // 发送连接状态变化通知
        NotificationCenter.default.post(name: BluetoothDeviceManager.connectionStateChangedNotification, object: nil)
    }
    
    // MARK: - 公开方法
    
    /// 设置当前蓝牙设备
    /// - Parameter device: BCLDevice 设备对象
    func setCurrentDevice(_ device: BCLDevice?) {
        self.currentDevice = device
        
        if let device = device {
            print("✅ 全局蓝牙设备已更新: \(device.name)")
        } else {
            print("⚠️  全局蓝牙设备已清除")
        }
        
        // 发送通知，让其他模块知道设备已变化
        NotificationCenter.default.post(name: BluetoothDeviceManager.deviceDidChangeNotification, object: nil)
    }
    
    /// 获取当前蓝牙设备
    /// - Returns: 当前连接的 BCLDevice，如果未连接则为 nil
    func getCurrentDevice() -> BCLDevice? {
        return currentDevice
    }
    
    /// 检查蓝牙设备是否已连接（基于 SDK 状态）
    /// - Returns: 如果设备已连接，则为 true
    func isDeviceConnected() -> Bool {
        return isConnected
    }
    
    /// 检查蓝牙设备是否存在
    /// - Returns: 如果设备存在且 peripheral 存在，则为 true
    func isDeviceAvailable() -> Bool {
        guard let device = currentDevice,
              device.peripheral != nil else {
            return false
        }
        return true
    }
    
    /// 清除当前设备
    func clearCurrentDevice() {
        setCurrentDevice(nil)
        isConnected = false
    }
    
    /// 订阅连接状态变化
    /// - Parameters:
    ///   - owner: 观察者对象
    ///   - handler: 连接状态变化的回调
    /// - Returns: 返回观察者令牌，用于取消订阅
    func observeConnectionStateChange(owner: Any, handler: @escaping (Bool) -> Void) -> NSObjectProtocol {
        return NotificationCenter.default.addObserver(
            forName: BluetoothDeviceManager.connectionStateChangedNotification,
            object: nil,
            queue: .main
        ) { [weak self] _ in
            handler(self?.isConnected ?? false)
        }
    }
}
