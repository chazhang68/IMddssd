import Foundation

// 蓝牙数据解析器
final class BluetoothDataParser {
    
    // MARK: - 协议定义
    
    // 心率测量命令 (0x31)
    static let HEART_RATE_CMD: UInt8 = 0x31
    
    // 子命令定义
    static let HEART_RATE_ACTIVE_MEASURE: UInt8 = 0x00     // 主动测量
    static let HEART_RATE_RESULT: UInt8 = 0x00             // 结果响应
    static let HEART_RATE_WAVEFORM: UInt8 = 0x01           // 波形响应
    static let HEART_RATE_RR_INTERVAL: UInt8 = 0x02        // RR间期响应
    static let HEART_RATE_PROGRESS: UInt8 = 0xFF           // 进度响应
    static let HEART_RATE_PUSH: UInt8 = 0x03               // 推送数据
    
    // MARK: - 数据模型
    
    struct HeartRateResult {
        /// 佩戴状态 (0=未佩戴, 1=佩戴, 2=充电中, 3=采集中, 4=繁忙)
        let wearingStatus: UInt8
        
        /// 心率值 (0=无效)
        let heartRate: UInt8
        
        /// 心率变异性 (单位ms, 0=无效)
        let heartRateVariability: UInt8
        
        /// 精神压力指数
        let stressIndex: UInt8
        
        /// 温度 (单位℃, 精度0.01)
        let temperature: Double
    }
    
    struct HeartRateProgress {
        /// 进度百分比 (0-100%)
        let percentage: UInt8
    }
    
    struct WaveformData {
        /// 序列号
        let seq: UInt8
        
        /// 数据点数
        let dataCount: UInt8
        
        /// PPG波形数据 (每个数据为有符号32位整数)
        let ppgData: [Int32]
        
        /// 加速度计数据 (X, Y, Z)
        let accelerometerData: [(Int16, Int16, Int16)]
    }
    
    struct RRIntervalData {
        /// 序列号
        let seq: UInt8
        
        /// 数据点数
        let dataCount: UInt8
        
        /// RR间期数组 (单位ms, 无符号16位整数)
        let rrIntervals: [UInt16]
    }
    
    // MARK: - 解析方法
    
    /// 解析蓝牙数据
    /// - Parameters:
    ///   - data: 原始蓝牙数据
    /// - Returns: 解析后的心率数据或nil
    static func parseData(_ data: Data) -> (type: String, result: Any?)? {
        guard data.count >= 4 else { return nil }
        
        let frameType = data[0]
        let frameId = data[1]
        let cmd = data[2]
        let subCmd = data[3]
        
        // 只处理心率命令
        guard cmd == HEART_RATE_CMD else { return nil }
        
        switch subCmd {
        case HEART_RATE_RESULT:
            // 结果响应 (6字节数据)
            if data.count >= 10 {
                let result = parseHeartRateResult(data)
                return ("heartRateResult", result)
            }
            
        case HEART_RATE_PROGRESS:
            // 进度响应 (1字节数据)
            if data.count >= 5 {
                let progress = parseProgress(data)
                return ("progress", progress)
            }
            
        case HEART_RATE_WAVEFORM:
            // 波形响应
            if data.count >= 5 {
                let waveform = parseWaveformData(data)
                return ("waveform", waveform)
            }
            
        case HEART_RATE_RR_INTERVAL:
            // RR间期响应
            if data.count >= 5 {
                let rrData = parseRRIntervalData(data)
                return ("rrInterval", rrData)
            }
            
        case HEART_RATE_PUSH:
            // 推送数据
            if data.count >= 10 {
                let result = parseHeartRatePush(data)
                return ("heartRatePush", result)
            }
            
        default:
            break
        }
        
        return nil
    }
    
    // MARK: - 私有解析方法
    
    /// 解析心率结果
    private static func parseHeartRateResult(_ data: Data) -> HeartRateResult {
        let wearingStatus = data[4]
        let heartRate = data[5]
        let heartRateVariability = data[6]
        let stressIndex = data[7]
        
        // 温度为有符号短整型 (Int16)，精度0.01
        var temperatureValue: Int16 = 0
        data.withUnsafeBytes { buffer in
            temperatureValue = buffer.load(fromByteOffset: 8, as: Int16.self)
        }
        let temperature = Double(temperatureValue) * 0.01
        
        return HeartRateResult(
            wearingStatus: wearingStatus,
            heartRate: heartRate,
            heartRateVariability: heartRateVariability,
            stressIndex: stressIndex,
            temperature: temperature
        )
    }
    
    /// 解析进度
    private static func parseProgress(_ data: Data) -> HeartRateProgress {
        let percentage = data[4]
        return HeartRateProgress(percentage: percentage)
    }
    
    /// 解析波形数据
    private static func parseWaveformData(_ data: Data) -> WaveformData {
        let seq = data[4]
        let dataCount = data[5]
        
        var ppgData: [Int32] = []
        var accelerometerData: [(Int16, Int16, Int16)] = []
        
        // 每个数据点包含：PPG(4字节) + X加速度(2字节) + Y加速度(2字节) + Z加速度(2字节) = 10字节
        let bytesPerPoint = 10
        var offset = 6
        
        for _ in 0..<dataCount {
            if offset + bytesPerPoint <= data.count {
                // 解析PPG数据 (有符号32位整数) - 使用小端模式
                let ppgByte0 = UInt32(data[offset])
                let ppgByte1 = UInt32(data[offset + 1])
                let ppgByte2 = UInt32(data[offset + 2])
                let ppgByte3 = UInt32(data[offset + 3])
                let ppgRaw = ppgByte0 | (ppgByte1 << 8) | (ppgByte2 << 16) | (ppgByte3 << 24)
                let ppgValue = Int32(bitPattern: ppgRaw)
                ppgData.append(ppgValue)
                offset += 4
                
                // 解析加速度计数据 - 使用小端模式
                let xRaw = UInt16(data[offset]) | (UInt16(data[offset + 1]) << 8)
                let x = Int16(bitPattern: xRaw)
                let yRaw = UInt16(data[offset + 2]) | (UInt16(data[offset + 3]) << 8)
                let y = Int16(bitPattern: yRaw)
                let zRaw = UInt16(data[offset + 4]) | (UInt16(data[offset + 5]) << 8)
                let z = Int16(bitPattern: zRaw)
                
                accelerometerData.append((x, y, z))
                offset += 6
            }
        }
        
        return WaveformData(
            seq: seq,
            dataCount: dataCount,
            ppgData: ppgData,
            accelerometerData: accelerometerData
        )
    }
    
    /// 解析RR间期数据
    private static func parseRRIntervalData(_ data: Data) -> RRIntervalData {
        let seq = data[4]
        let dataCount = data[5]
        
        var rrIntervals: [UInt16] = []
        
        // 每个RR间期占2字节 (无符号16位整数)
        var offset = 6
        
        for _ in 0..<dataCount {
            if offset + 2 <= data.count {
                var rrValue: UInt16 = 0
                data.withUnsafeBytes { buffer in
                    rrValue = buffer.load(fromByteOffset: offset, as: UInt16.self)
                }
                rrIntervals.append(rrValue)
                offset += 2
            }
        }
        
        return RRIntervalData(
            seq: seq,
            dataCount: dataCount,
            rrIntervals: rrIntervals
        )
    }
    
    /// 解析心率推送数据
    private static func parseHeartRatePush(_ data: Data) -> HeartRateResult {
        // 推送数据结构与结果响应相同
        let wearingStatus = data[4]
        let heartRate = data[5]
        let heartRateVariability = data[6]
        let stressIndex = data[7]
        
        var temperatureValue: Int16 = 0
        data.withUnsafeBytes { buffer in
            temperatureValue = buffer.load(fromByteOffset: 8, as: Int16.self)
        }
        let temperature = Double(temperatureValue) * 0.01
        
        return HeartRateResult(
            wearingStatus: wearingStatus,
            heartRate: heartRate,
            heartRateVariability: heartRateVariability,
            stressIndex: stressIndex,
            temperature: temperature
        )
    }
    
    // MARK: - 命令生成
    
    /// 生成心率测量命令
    static func generateHeartRateMeasurementCommand(
        duration: UInt8 = 30,      // 采集时间 (秒)
        frequency: UInt8 = 50,      // 采集频率 (Hz)
        uploadWaveform: Bool = true, // 是否上传波形
        uploadProgress: Bool = true, // 是否上传进度
        uploadRRInterval: Bool = true // 是否上传RR间期
    ) -> Data {
        var data = Data()
        data.append(0x00)  // Frame Type: 单帧
        data.append(UInt8.random(in: 1...255))  // Frame ID: 随机
        data.append(HEART_RATE_CMD)  // Cmd: 0x31
        data.append(HEART_RATE_ACTIVE_MEASURE)  // Subcmd: 0x00
        data.append(duration)  // 采集时间
        data.append(frequency)  // 采集频率
        data.append(uploadWaveform ? 0x01 : 0x00)  // 波形配置
        data.append(uploadProgress ? 0x01 : 0x00)  // 进度配置
        data.append(uploadRRInterval ? 0x01 : 0x00)  // 间期配置
        return data
    }
}
