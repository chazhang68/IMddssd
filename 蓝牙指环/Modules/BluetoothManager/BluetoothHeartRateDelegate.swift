import Foundation

// MARK: - 蓝牙数据接收委托

protocol BluetoothHeartRateDelegate: AnyObject {
    
    /// 心率数据更新
    /// - Parameter result: 心率测量结果
    func didUpdateHeartRate(_ result: BluetoothDataParser.HeartRateResult)
    
    /// 进度更新
    /// - Parameter progress: 进度百分比
    func didUpdateProgress(_ progress: UInt8)
    
    /// 波形数据更新
    /// - Parameter waveform: 波形数据
    func didUpdateWaveform(_ waveform: BluetoothDataParser.WaveformData)
    
    /// RR间期数据更新
    /// - Parameter rrData: RR间期数据
    func didUpdateRRInterval(_ rrData: BluetoothDataParser.RRIntervalData)
    
    /// 蓝牙错误
    /// - Parameter error: 错误信息
    func didReceiveBluetoothError(_ error: String)
}

// 可选实现
extension BluetoothHeartRateDelegate {
    func didUpdateHeartRate(_ result: BluetoothDataParser.HeartRateResult) {}
    func didUpdateProgress(_ progress: UInt8) {}
    func didUpdateWaveform(_ waveform: BluetoothDataParser.WaveformData) {}
    func didUpdateRRInterval(_ rrData: BluetoothDataParser.RRIntervalData) {}
    func didReceiveBluetoothError(_ error: String) {}
}
