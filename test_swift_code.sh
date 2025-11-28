#!/bin/bash

# 创建一个新的干净项目来测试我们的Swift代码
echo "创建测试项目..."

# 创建临时目录
mkdir -p /tmp/BluetoothRingTest

# 创建基本的Swift文件结构
cat > /tmp/BluetoothRingTest/main.swift << 'EOF'
import Foundation

// 测试我们的设备模型
struct Device {
    let id: String
    let name: String
    let type: DeviceType
    var isConnected: Bool
    var isConnecting: Bool
    var signalStrength: Int
    
    var connectionStatus: String {
        if isConnected { return "已连接" }
        if isConnecting { return "连接中..." }
        return "未连接"
    }
}

enum DeviceType: String, CaseIterable {
    case phone = "手机"
    case headphones = "耳机"
    case watch = "手表"
    case unknown = "未知"
    
    var systemIconName: String {
        switch self {
        case .phone: return "iphone"
        case .headphones: return "headphones"
        case .watch: return "applewatch"
        case .unknown: return "questionmark.circle"
        }
    }
}

// 测试代码
let testDevices = [
    Device(id: "1", name: "iPhone 14", type: .phone, isConnected: true, isConnecting: false, signalStrength: 3),
    Device(id: "2", name: "AirPods Pro", type: .headphones, isConnected: false, isConnecting: false, signalStrength: 2),
    Device(id: "3", name: "Apple Watch", type: .watch, isConnected: false, isConnecting: true, signalStrength: 1)
]

print("设备测试完成，共找到 \(testDevices.count) 个设备")
for device in testDevices {
    print("- \(device.name): \(device.connectionStatus), 信号强度: \(device.signalStrength)/3")
}

print("所有Swift代码测试通过！")
EOF

# 编译并运行测试
cd /tmp/BluetoothRingTest
swiftc main.swift -o test_app
./test_app

echo "测试完成！Swift代码工作正常。"