import Foundation
import CoreBluetooth

/// 蓝牙心率数据管理器
/// 负责接收来自BCL SDK的真实心率测量数据
final class BluetoothHeartRateManager: NSObject {
    
    weak var delegate: BluetoothHeartRateDelegate?
    
    private var device: BCLDevice?
    private var isMonitoring = false
    
    // MARK: - GATT Service/Characteristic UUIDs
    // 根据蓝牙协议：基本参数服务的私有UUID
    // 私有 UUID Base: BAE8xxxx-4F05-4503-8E65-3AF1F7329D1F
    private let serviceUUID = CBUUID(string: "BAE80001-4F05-4503-8E65-3AF1F7329D1F")      // 服务 0x0001
    private let writeCharacteristicUUID = CBUUID(string: "BAE80010-4F05-4503-8E65-3AF1F7329D1F")  // 发送命令 0x0010
    private let readCharacteristicUUID = CBUUID(string: "BAE80011-4F05-4503-8E65-3AF1F7329D1F")   // 接收数据 0x0011
    
    /// 初始化管理器
    func initialize(with device: BCLDevice) {
        self.device = device
        print("✅ 心率管理器已初始化，设备：\(device.name)")
    }
    
    /// 开始心率测量
    func startHeartRateMeasurement() {
        guard let peripheral = device?.peripheral else {
            delegate?.didReceiveBluetoothError("设备未连接")
            return
        }
        
        // 会设置 peripheral 的 delegate，它会接收各种 GATT 发现的回调
        peripheral.delegate = self
        
        print("📡 开始发送心率测量命令...")
        
        // 发现服务
        peripheral.discoverServices([serviceUUID])
    }
    
    /// 停止心率测量
    func stopHeartRateMeasurement() {
        isMonitoring = false
        print("⏸ 心率测量已停止")
    }
    
    // MARK: - 蓝牙命令发送
    
    /// 发送心率测量命令（0x31）
    private func sendHeartRateCommand(_ peripheral: CBPeripheral) {
        // 根据蓝牙协议 0x31
        // 示例数据： 000931001e32010101 ，采集时间 30 秒 ，频率 50hz ，波形上传 ，进度上传 ， 间期上传
        let measurementData: [UInt8] = [
            0x00,                      // Frame Type
            UInt8.random(in: 1...255), // Frame ID (随机)
            0x31,                      // Cmd (心率测量)
            0x00,                      // Subcmd (主动测量)
            0x1e,                      // [0] 采集时间 30秒
            0x32,                      // [1] 采集频率 50Hz
            0x01,                      // [2] 波形配置：上传
            0x01,                      // [3] 进度配置：上传
            0x01                       // [4] 间期配置：上传
        ]
        
        guard let characteristic = findCharacteristic(peripheral, uuid: writeCharacteristicUUID) else {
            delegate?.didReceiveBluetoothError("找不到写入特征")
            return
        }
        
        let data = Data(measurementData)
        peripheral.writeValue(data, for: characteristic, type: .withResponse)
        print("✅ 心率测量命令已发送: \(data.map { String(format: "%02x", $0) }.joined(separator: " "))")
        
        // 立即开始监听数据
        setupNotifications(peripheral)
    }
    
    /// 设置数据通知
    private func setupNotifications(_ peripheral: CBPeripheral) {
        guard let characteristic = findCharacteristic(peripheral, uuid: readCharacteristicUUID) else {
            delegate?.didReceiveBluetoothError("找不到读取特征")
            return
        }
        
        peripheral.setNotifyValue(true, for: characteristic)
        print("📢 已设置数据通知监听")
        isMonitoring = true
    }
    
    // MARK: - 数据解析
    
    /// 解析心率数据（0x31 响应）
    private func parseHeartRateResult(_ data: Data) {
        // 数据格式（来自蓝牙协议）：
        // [0]: 佩戴状态
        // [1]: 心率 (0=无效)
        // [2]: 心率变异性
        // [3]: 精神压力指数
        // [4:5]: 温度
        
        print("📋 解析心率数据: \(data.map { String(format: "%02x", $0) }.joined(separator: " ")) (长度: \(data.count))")
        
        guard data.count >= 2 else {
            print("⚠️ 数据不完整，至少需要 2 个字节，实际: \(data.count)")
            return
        }
        
        let wearingStatus = data[0]
        let heartRate = data[1]
        let hrv = data.count > 2 ? data[2] : 0
        let stress = data.count > 3 ? data[3] : 0
        
        var temperature: Double = 0.0
        if data.count >= 6 {
            let tempBytes = [data[4], data[5]]
            let temperature_raw = Int16(bitPattern: UInt16(tempBytes[0]) | (UInt16(tempBytes[1]) << 8))
            temperature = Double(temperature_raw) / 100.0
        }
        
        print("💓 心率数据 - 体态:\(wearingStatus) HR:\(heartRate)bpm HRV:\(hrv) 压力:\(stress) 温度:\(temperature)°C")
        
        let result = BluetoothDataParser.HeartRateResult(
            wearingStatus: wearingStatus,
            heartRate: heartRate,
            heartRateVariability: hrv,
            stressIndex: stress,
            temperature: temperature
        )
        
        delegate?.didUpdateHeartRate(result)
    }
    
    /// 解析波形数据（0x31 0x01 响应）
    private func parseWaveformData(_ data: Data) {
        guard data.count >= 2 else { return }
        
        let seq = data[0]
        let dataNum = data[1]
        
        print("📈 波形数据 - seq:\(seq) 数据个数:\(dataNum)")
        
        // 使用标准解析器解析波形数据
        // 这里的data是去掉命令头后的数据
        var fullData = Data()
        fullData.append(0x00)  // Frame Type
        fullData.append(0x00)  // Frame ID
        fullData.append(0x31)  // Cmd
        fullData.append(0x01)  // Subcmd (波形响应)
        fullData.append(contentsOf: data)  // 添加波形数据
        
        // 使用 BluetoothDataParser 解析
        if let parseResult = BluetoothDataParser.parseData(fullData),
           parseResult.type == "waveform",
           let waveformData = parseResult.result as? BluetoothDataParser.WaveformData {
            delegate?.didUpdateWaveform(waveformData)
        }
    }
    
    /// 解析 RR 间期数据（0x31 0x02 响应）
    private func parseRRIntervalData(_ data: Data) {
        guard data.count >= 2 else { return }
        
        let seq = data[0]
        let dataNum = data[1]
        
        print("📊 RR间期数据 - seq:\(seq) 数据个数:\(dataNum)")
        
        // 解析 RR 间期数组（每个 2 字节）
        var rrIntervals: [UInt16] = []
        var offset = 2
        
        for i in 0..<Int(dataNum) {
            let nextOffset = offset + 2
            if nextOffset <= data.count {
                let lowByte = UInt16(data[offset])
                let highByte = UInt16(data[offset + 1])
                let rrValue = lowByte | (highByte << 8)  // 小端模式
                rrIntervals.append(rrValue)
                offset = nextOffset
            } else {
                print("⚠️ RR间期数据不完整，预期 \(dataNum) 个，实际 \(i) 个")
                break
            }
        }
        
        print("📊 RR间期数组: \(rrIntervals) (ms)")
        
        let rrData = BluetoothDataParser.RRIntervalData(
            seq: seq,
            dataCount: UInt8(rrIntervals.count),
            rrIntervals: rrIntervals
        )
        
        delegate?.didUpdateRRInterval(rrData)
    }
    
    /// 解析进度数据（0x31 0xFF 或 0x32 0xFF 响应）
    private func parseProgressData(_ data: Data) {
        guard data.count >= 1 else { 
            print("⚠️ 进度数据为空")
            return 
        }
        
        let progress = data[0]
        print("⏳ 测量进度: \(progress)% (原始数据: \(data.map { String(format: "%02x", $0) }.joined(separator: " ")))")
        print("⏳ [调试] 进度百分比: \(progress)/100 = \(CGFloat(progress)/100.0)")
        
        delegate?.didUpdateProgress(progress)
    }
    
    /// 发送心率推送应答（0x31 0x03）
    /// 当收到设备的心率推送时，APP 需要在 2 秒内发送应答
    private func sendHeartRatePushAck(_ peripheral: CBPeripheral, frameID: UInt8) {
        // 根据蓝牙协议 0x31 0x03 应答
        let ackData: [UInt8] = [
            0x00,   // Frame Type
            frameID, // Frame ID (使用来自推送的 ID)
            0x31,   // Cmd (心率测量)
            0x03    // Subcmd (推送应答)
            // Data: 无
        ]
        
        guard let characteristic = findCharacteristic(peripheral, uuid: writeCharacteristicUUID) else {
            print("❌ 找不到写入特征")
            return
        }
        
        let data = Data(ackData)
        peripheral.writeValue(data, for: characteristic, type: .withResponse)
        print("✅ 心率推送应答已发送: \(data.map { String(format: "%02x", $0) }.joined(separator: " "))")
    }
    
    // MARK: - 辅助方法
    
    private func findCharacteristic(_ peripheral: CBPeripheral, uuid: CBUUID) -> CBCharacteristic? {
        for service in peripheral.services ?? [] {
            for characteristic in service.characteristics ?? [] {
                if characteristic.uuid == uuid {
                    return characteristic
                }
            }
        }
        return nil
    }
}

// MARK: - CBPeripheralDelegate

extension BluetoothHeartRateManager: CBPeripheralDelegate {
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        if let error = error {
            delegate?.didReceiveBluetoothError("发现服务失败: \(error.localizedDescription)")
            return
        }
        
        print("✅ 发现服务")
        
        // 发现特征
        for service in peripheral.services ?? [] {
            if service.uuid == serviceUUID {
                peripheral.discoverCharacteristics([writeCharacteristicUUID, readCharacteristicUUID], for: service)
            }
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        if let error = error {
            delegate?.didReceiveBluetoothError("发现特征失败: \(error.localizedDescription)")
            return
        }
        
        print("✅ 发现特征")
        
        // 发送心率测量命令
        sendHeartRateCommand(peripheral)
    }
    
    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
        if let error = error {
            delegate?.didReceiveBluetoothError("数据更新失败: \(error.localizedDescription)")
            return
        }
        
        guard let data = characteristic.value else {
            print("❌ 特性值为Nil")
            return
        }
        
        print("📦 收到蓝牙数据 (\(data.count) 字节): \(data.map { String(format: "%02x", $0) }.joined(separator: " "))")
        
        // 根据命令类型解析数据
        if data.count < 3 {
            print("❌ 数据太短, 至少需要 3 个字节 (frameType, frameID, cmd), 实际: \(data.count)")
            return
        }
        
        let frameType = data[0]
        let frameID = data[1]
        let cmd = data[2]
        
        print("🔍 解析数据: frameType=0x\(String(format: "%02x", frameType)), frameID=0x\(String(format: "%02x", frameID)), cmd=0x\(String(format: "%02x", cmd))")
        
        switch cmd {
        case 0x31:  // 心率测量响应
            print("📋 处理 0x31 心率命令")
            if data.count >= 4 {
                let subcmd = data[3]
                if subcmd == 0x00 {  // 心率结果
                    let resultData = data.subdata(in: 4..<data.count)
                    print("❓ 心率结果数据: \(resultData.map { String(format: "%02x", $0) }.joined(separator: " "))")
                    parseHeartRateResult(resultData)
                } else if subcmd == 0x01 {  // 波形数据
                    let waveformData = data.subdata(in: 4..<data.count)
                    print("❓ 波形数据: \(waveformData.map { String(format: "%02x", $0) }.joined(separator: " "))")
                    parseWaveformData(waveformData)
                } else if subcmd == 0x02 {  // RR间期数据
                    let rrData = data.subdata(in: 4..<data.count)
                    print("❓ RR间期数据: \(rrData.map { String(format: "%02x", $0) }.joined(separator: " "))")
                    parseRRIntervalData(rrData)
                } else if subcmd == 0x03 {  // 有体发送（最近测量）
                    let pushData = data.subdata(in: 4..<data.count)
                    print("📋 心率推送数据: \(pushData.map { String(format: "%02x", $0) }.joined(separator: " "))")
                    // 解析心率推送数据
                    parseHeartRateResult(pushData)
                    // 自动发送应答（心率推送应答 0x31 0x03）
                    if let peripheral = device?.peripheral {
                        sendHeartRatePushAck(peripheral, frameID: frameID)
                    }
                } else if subcmd == 0xFF {  // 进度响应
                    let progressData = data.subdata(in: 4..<data.count)
                    print("❓ 进度数据: \(progressData.map { String(format: "%02x", $0) }.joined(separator: " "))")
                    parseProgressData(progressData)
                } else {
                    print("⚠️  未知 subcmd: 0x\(String(format: "%02x", subcmd))")
                }
            }
            
        case 0x32:  // 血氧/进度等
            print("📋 处理 0x32 血氧/进度命令")
            if data.count >= 4 {
                let subcmd = data[3]
                if subcmd == 0xFF {  // 进度响应
                    let progressData = data.subdata(in: 4..<data.count)
                    print("❓ 进度数据: \(progressData.map { String(format: "%02x", $0) }.joined(separator: " "))")
                    parseProgressData(progressData)
                } else {
                    print("⚠️  未知 subcmd: 0x\(String(format: "%02x", subcmd))")
                }
            }
            
        default:
            print("⚠️  未知命令: 0x\(String(format: "%02x", cmd))")
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didWriteValueFor characteristic: CBCharacteristic, error: Error?) {
        if let error = error {
            print("❌ 写入失败: \(error.localizedDescription)")
            delegate?.didReceiveBluetoothError("命令发送失败: \(error.localizedDescription)")
        } else {
            print("✅ 命令已确认")
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didUpdateNotificationStateFor characteristic: CBCharacteristic, error: Error?) {
        if let error = error {
            print("❌ 通知设置失败: \(error.localizedDescription)")
            delegate?.didReceiveBluetoothError("通知设置失败: \(error.localizedDescription)")
        } else {
            if characteristic.isNotifying {
                print("✅ 通知已启用")
                // 通知启用后，设备会自动推送数据
            } else {
                print("⚠️  通知已禁用")
            }
        }
    }
}
