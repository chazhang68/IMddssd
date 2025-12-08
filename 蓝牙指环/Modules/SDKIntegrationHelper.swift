import Foundation
#if swift(>=5.10)
import BCLRingSDK
#endif

/// SDK集成辅助类 - 提供SDK初始化和常用功能
class SDKIntegrationHelper {
    
    static let shared = SDKIntegrationHelper()
    
    // MARK: - SDK 初始化
    
    /// 初始化BCLRingSDK
    func initializeSDK() {
        #if swift(>=5.10)
        _ = BCLRingManager.shared
        #else
        print("BCLRingSDKManager fallback")
        #endif
    }
    
    // MARK: - 设备搜索和连接辅助方法
    
    /// 准备开始搜索设备
    func prepareForDeviceSearch() -> Bool {
        #if swift(>=5.10)
        let mgr = BCLRingManager.shared
        mgr.scannedDevicesRelayResultBlock = { result in
            switch result {
            case .success(let list):
                for info in list {
                    let dev = BCLDevice(
                        name: info.peripheralName ?? info.localName ?? "未知设备",
                        peripheralID: info.uuidString,
                        rssi: info.rssi?.intValue ?? -60,
                        peripheral: info.peripheral
                    )
                    BCLRingSDKManager.shared.onDeviceDiscovered?(dev)
                }
            case .failure:
                break
            }
        }
        mgr.startScan { _ in }
        return true
        #else
        let manager = BCLRingSDKManager.shared
        manager.startScanning()
        return true
        #endif
    }
    
    /// 停止搜索
    func stopDeviceSearch() {
        #if swift(>=5.10)
        BCLRingManager.shared.stopScan()
        #else
        BCLRingSDKManager.shared.stopScanning()
        #endif
    }
    
    /// 连接设备
    func connectDevice(_ device: BCLDevice) {
        #if swift(>=5.10)
        BCLRingManager.shared.startConnect(uuidString: device.peripheralID, connectResultBlock: { result in
            switch result {
            case .success:
                BCLRingSDKManager.shared.onConnectionStateChanged?(device.name, true)
            case .failure:
                break
            }
        })
        #else
        BCLRingSDKManager.shared.connect(to: device)
        #endif
    }
    
    /// 断开设备
    func disconnectDevice(_ device: BCLDevice) {
        #if swift(>=5.10)
        BCLRingManager.shared.disconnect()
        #else
        BCLRingSDKManager.shared.disconnect(from: device)
        #endif
    }
    
    // MARK: - SDK 功能映射
    
    /// 获取SDK支持的功能列表
    func getSupportedFeatures() -> [String] {
        return [
            "设备搜索",
            "设备连接",
            "信号强度检测",
            "蓝牙通信",
            "数据传输",
            "生理算法支持"
        ]
    }
}
