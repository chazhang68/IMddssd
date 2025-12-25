import SwiftUI
import UIKit

struct BluetoothBindingView: View {
    @Environment(\.presentationMode) var presentationMode
    
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
                                Text("Pairing devices")
                                    .font(.system(size: 22, weight: .semibold))
                                    .foregroundColor(.white)
                                
                                Spacer()
                                
                                Image("connect")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 24, height: 24)
                            }
                            .padding(.horizontal, 30)
                            .frame(height: 64)
                            .background(darkBgColor)
                            .cornerRadius(20)
                            .padding(.horizontal, 30)
                            .padding(.bottom, 36)
                            .onTapGesture {
                                print("点击111")
                                // Action for pairing
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
