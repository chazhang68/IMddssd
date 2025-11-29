import Foundation
import UIKit

/// 蓝牙设备模型 - 表示可连接的设备信息
/// 包含设备基本信息、连接状态、信号强度和电池信息
struct Device: Identifiable, Codable {
    let id: String              // 设备唯一标识符（UUID字符串）
    let name: String            // 设备名称
    let type: DeviceType        // 设备类型
    let rssi: Int               // 信号强度 (dBm)
    var isConnected: Bool       // 是否已连接
    var isConnecting: Bool      // 是否正在连接中
    var batteryPercentage: Int? // 电池百分比（如果有）
    
    /// 根据设备名称和连接状态获取背景图片
    var backgroundImage: UIImage? {
        // 根据设备名称匹配资源图片
        let imageName: String?
        
        if name.contains("MT AI Glasses") || name.contains("眼镜") {
            imageName = isConnected ? "MT-AI-Glasses-s" : "MT-AI-Glasses-n"
        } else if name.contains("Know-you pro") || name.contains("手表") {
            imageName = isConnected ? "Know-you-pro-s" : "Know-you-pro-n"
        } else if name.contains("Earphones") || name.contains("耳机") {
            imageName = "earphones2"
        } else if name.contains("ring") || name.contains("指环") || name.contains("Ring") {
            imageName = "ring"
        } else {
            imageName = nil
        }
        
        return imageName != nil ? UIImage(named: imageName!) : nil
    }
    
    /// 计算信号强度等级 (0-3)
    var signalStrength: Int {
        // RSSI范围通常在 -100 到 -30 dBm 之间
        // -30 到 -50: 强信号 (3)
        // -50 到 -70: 中信号 (2)
        // -70 到 -90: 弱信号 (1)
        // 低于 -90: 无信号 (0)
        
        if rssi >= -50 { return 3 }      // 强信号
        else if rssi >= -70 { return 2 } // 中信号
        else if rssi >= -90 { return 1 } // 弱信号
        else { return 0 }                // 无信号
    }
    
    /// 获取信号强度描述文本
    var signalDescription: String {
        switch signalStrength {
        case 3:
            return "强信号"
        case 2:
            return "中信号"
        case 1:
            return "弱信号"
        default:
            return "信号弱"
        }
    }
    
    /// 获取连接状态描述
    var connectionStatus: String {
        if isConnecting {
            return "连接中..."
        } else if isConnected {
            return "已连接"
        } else {
            return signalDescription
        }
    }
}

/// 设备类型枚举
enum DeviceType: String, CaseIterable, Codable {
    case headphones = "耳机"
    case speaker = "音箱"
    case watch = "手表"
    case glasses = "眼镜"
    case ring = "指环"
    case phone = "手机"
    case tablet = "平板"
    case laptop = "电脑"
    case camera = "相机"
    case other = "其他"
    
    /// 获取设备对应的系统图标名称
    var systemIconName: String {
        switch self {
        case .headphones:
            return "headphones"
        case .speaker:
            return "speaker"
        case .watch:
            return "applewatch"
        case .glasses:
            return "eyeglasses"
        case .ring:
            return "circle"
        case .phone:
            return "iphone"
        case .tablet:
            return "ipad"
        case .laptop:
            return "laptopcomputer"
        case .camera:
            return "video.camera"
        case .other:
            return "antenna.radiowaves.left.and.right"
        }
    }
}
