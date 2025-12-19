import SwiftUI

struct BluetoothDevice: Identifiable {
    let id = UUID()
    let name: String
}

struct BluetoothSelectionView: View {
    var devices: [BluetoothDevice]

    var onBluetoothSelected: (String) -> Void
    var onConnect: () -> Void
    var onCancel: () -> Void

    @State private var selectedDeviceId: UUID?
    @State private var listContentHeight: CGFloat = 0

    let yellowColor = Color(UIColor(hex: 0xFFD700))
    let darkOverlayColor = Color(UIColor(hex: 0x1C1C1E))
    let separatorColor = Color.white.opacity(0.15)

    var body: some View {
        ZStack {
            Color.black.opacity(0.2)
                .ignoresSafeArea()
                .onTapGesture {
                    onCancel()
                }

            VStack(spacing: 0) {
                Spacer()

                VStack(spacing: 0) {
                    Text("新的设备")
                        .font(.system(size: 16, weight: .regular))
                        .foregroundColor(.white)
                        .padding(.vertical, 14)
                    
                    Divider()
                        .background(separatorColor)

                    // Bluetooth List
                    ScrollView {
                        VStack(spacing: 0) {
                            ForEach(devices) { device in
                                VStack(spacing: 0) {
                                    Button(action: {
                                        selectedDeviceId = device.id
                                        onBluetoothSelected(device.name)
                                    }) {
                                        Text(device.name)
                                            .font(.system(size: 18, weight: .regular))
                                            .foregroundColor(yellowColor)
                                            .frame(maxWidth: .infinity)
                                            .padding(.vertical, 18)
                                    }
                                    .background(selectedDeviceId == device.id ? Color.white.opacity(0.1) : Color.clear)
                                  
                                    if device.id != devices.last?.id {
                                        Divider().background(separatorColor)
                                    }
                                }
                            }
                        }
                        .background(GeometryReader { geometry in
                            Color.clear.preference(key: HeightPreferenceKey.self, value: geometry.size.height)
                        })
                    }
                    .frame(height: listContentHeight > 0 ? min(listContentHeight, 300) : 0)
                    .onPreferenceChange(HeightPreferenceKey.self) { height in
                        listContentHeight = height
                    }
                }
                .background(darkOverlayColor)
                .cornerRadius(14)
//                .padding(.horizontal, 16)

                Spacer().frame(height: 12)

                Button(action: onConnect) {
                    Text("添加")
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(yellowColor)
                        .frame(maxWidth: .infinity)
                        .frame(height: 56)
                        .background(darkOverlayColor)
                        .cornerRadius(14)
                }
//                .padding(.horizontal, 16)
                .padding(.bottom, 40)
            }
        }
        .ignoresSafeArea(edges: .top)
    }
}

struct HeightPreferenceKey: PreferenceKey {
    static var defaultValue: CGFloat = 0
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = max(value, nextValue())
    }
}

// Preview
struct BluetoothSelectionView_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            Image("Background")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()
            
            BluetoothSelectionView(
                devices: [
                    BluetoothDevice(name: "BCL6031ABE"),
                    BluetoothDevice(name: "Test Device")
                ],
                onBluetoothSelected: { name in
                    print("Selected: \(name)")
                },
                onConnect: {
                    print("Add tapped")
                },
                onCancel: {
                    print("Cancel tapped")
                }
            )
        }
    }
}
