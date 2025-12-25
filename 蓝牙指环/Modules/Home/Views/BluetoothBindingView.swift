import SwiftUI
import UIKit

struct BluetoothBindingView: View {
    @Environment(\.presentationMode) var presentationMode
    @State private var discoveredDevices: [BCLDevice] = []
    @State private var isScanning: Bool = false

    private let yellowColor = Color(uiColor: UIColor(hex: 0xFFD700))
    private let darkBgColor = Color(uiColor: UIColor(hex: 0x0E0F12))
    private let brandColor = Color(uiColor: UIColor(hex: 0x6A5600))
    private let badgeBgBlack = Color.black
    private let badgeBgGray = Color(uiColor: UIColor(hex: 0x1F1F1F))
    
    var body: some View {
        ZStack {
            Image("Background")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Top Yellow Card
                ZStack(alignment: .top) {
                    // Background Image
                    yellowColor
                        .ignoresSafeArea()
                    
                    VStack(alignment: .leading, spacing: 0) {
                        // Top Right Badges - Adjusted to top navigation bar position
                        HStack(spacing: 15) {
                            Spacer()
                            Image("头像")
                                .resizable()
                                .scaledToFill()
                                .frame(width: 40, height: 40)
                                .clipShape(Circle())
                            Image("头像")
                                .resizable()
                                .scaledToFill()
                                .frame(width: 40, height: 40)
                                .clipShape(Circle())
                        }
                        .padding(.top, 60)
                        .padding(.trailing, 25)
                        
                        Spacer()
                        
                        // Welcome Image (Replaces Text)
                        Image("Welcome")
                            .resizable()
                            .scaledToFit()
                            .padding(.horizontal, 30)
                        
                        Spacer()
                        
                        // Pairing Devices Button
                        Button(action: {
                            // Action for pairing
                        }) {
                            HStack {
                                Text(isScanning ? "Searching..." : "Pairing devices")
                                    .font(.system(size: 22, weight: .semibold))
                                    .foregroundColor(.white)

                                Spacer()

                                if isScanning {
                                    ProgressView()
                                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                                        .scaleEffect(0.8)
                                } else {
                                    Image("connect")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 24, height: 24)
                                }
                            }
                            .padding(.horizontal, 30)
                            .frame(height: 64)
                            .background(darkBgColor)
                            .cornerRadius(20)
                            .padding(.horizontal, 30)
                            .padding(.bottom, 36)
                            .onTapGesture {
                                print("点击搜索蓝牙设备")
                                startBluetoothScanning()
                            }
                        }
                    }
                }
                .frame(height: UIScreen.main.bounds.height * 0.62)
                .clipShape(RoundedCorner(radius: 48, corners: [.bottomLeft, .bottomRight]))
                
                // Bottom Content
                VStack(alignment: .leading) {
                    Spacer().frame(height: 28)
                    
                    Text("Trendy & Fun Designs, All Here.")
                        .font(.system(size: 20, weight: .heavy))
                        .foregroundColor(Color.white.opacity(0.28))
                        .padding(.horizontal, 24)

//                    Text("Automatically find devices, Please turn on Bluetooth")
//                        .font(.system(size: 20, weight: .heavy))
//                        .foregroundColor(Color.white.opacity(0.28))
//                        .padding(.horizontal, 24)
                    
                    Spacer().frame(height: 18)

                    // 设备列表或图标
                    if discoveredDevices.isEmpty {
                        // Device Icons
                        HStack(spacing: 8) {
                            ForEach(["headphones", "externaldrive", "iphone.gen2", "gamecontroller", "earbuds"], id: \.self) { icon in
                                Image(systemName: icon)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 28, height: 24)
                                    .foregroundColor(Color.white.opacity(0.35))
                            }
                        }
                        .padding(.horizontal, 24)
                    } else {
                        // 发现的设备列表
                        ScrollView {
                            VStack(spacing: 12) {
                                ForEach(discoveredDevices, id: \.peripheralID) { device in
                                    HStack {
                                        Image(systemName: "circle.fill")
                                            .font(.system(size: 8))
                                            .foregroundColor(yellowColor)

                                        VStack(alignment: .leading, spacing: 2) {
                                            Text(device.name)
                                                .font(.system(size: 16, weight: .semibold))
                                                .foregroundColor(.white)

                                            Text("信号: \(device.signalDescription) (\(device.rssi) dBm)")
                                                .font(.system(size: 12))
                                                .foregroundColor(.white.opacity(0.6))
                                        }

                                        Spacer()

                                        Button(action: {
                                            connectToDevice(device)
                                        }) {
                                            Text("连接")
                                                .font(.system(size: 14, weight: .medium))
                                                .foregroundColor(darkBgColor)
                                                .padding(.horizontal, 16)
                                                .padding(.vertical, 8)
                                                .background(yellowColor)
                                                .cornerRadius(12)
                                        }
                                    }
                                    .padding(.horizontal, 20)
                                    .padding(.vertical, 12)
                                    .background(Color.white.opacity(0.1))
                                    .cornerRadius(12)
                                }
                            }
                            .padding(.horizontal, 24)
                        }
                        .frame(maxHeight: 200)
                    }
                    
                    Spacer()
                    
                    // Back Button
                    HStack {
                        Spacer()
                        Button(action: {
                            presentationMode.wrappedValue.dismiss()
                        }) {
                            Text("Back")
                                .font(.system(size: 20, weight: .semibold))
                                .foregroundColor(Color.white.opacity(0.6))
                        }
                        .padding(.bottom, 40)
                        .padding(.trailing, 30)
                    }
                }
            }
            .ignoresSafeArea(edges: .top)
        }
        .onAppear {
            setupBluetoothCallback()
        }
        .onDisappear {
            stopBluetoothScanning()
        }
    }

    // MARK: - 蓝牙搜索功能

    /// 开始搜索蓝牙设备
    private func startBluetoothScanning() {
        print("🔍 开始搜索蓝牙设备")
        isScanning = true
        discoveredDevices.removeAll()

        // 使用SDK的蓝牙管理器开始扫描
        BCLRingSDKManager.shared.startScanning()

        // 10秒后自动停止搜索
        DispatchQueue.main.asyncAfter(deadline: .now() + 10) {
            if isScanning {
                stopBluetoothScanning()
            }
        }
    }

    /// 停止搜索蓝牙设备
    private func stopBluetoothScanning() {
        print("⏹️ 停止搜索蓝牙设备")
        isScanning = false
        BCLRingSDKManager.shared.stopScanning()
    }

    /// 设置蓝牙设备发现回调
    private func setupBluetoothCallback() {
        BCLRingSDKManager.shared.onDeviceDiscovered = { [self] device in
            DispatchQueue.main.async {
                print("✅ 发现设备: \(device.name), RSSI: \(device.rssi)")
                // 避免重复添加
                if !discoveredDevices.contains(where: { $0.peripheralID == device.peripheralID }) {
                    discoveredDevices.append(device)
                }
            }
        }
    }

    /// 连接到指定设备
    private func connectToDevice(_ device: BCLDevice) {
        print("🔗 尝试连接设备: \(device.name)")
        BCLRingSDKManager.shared.connect(to: device)

        // 停止搜索
        stopBluetoothScanning()

        // TODO: 这里可以添加连接成功后的跳转逻辑
        // 例如: 跳转到设备详情页
    }
}

// Custom Shape for rounded corners on specific corners
struct RoundedCorner: Shape {
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}

// Preview
struct BluetoothBindingView_Previews: PreviewProvider {
    static var previews: some View {
        BluetoothBindingView()
    }
}
