import SwiftUI

struct CustomAlertView: View {
    var title: String
    var message: String
    var cancelTitle: String
    var actionTitle: String
    var onCancel: () -> Void
    var onAction: () -> Void
    
    var body: some View {
        ZStack {
            Color.black.opacity(0.4)
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                VStack(spacing: 16) {
                    Text(title)
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(.white)
                        .padding(.top, 24)
                    
                    Text(message)
                        .font(.system(size: 14))
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 24)
                        .padding(.bottom, 24)
                }
                
                Divider()
                    .background(Color.white.opacity(0.2))
                
                HStack(spacing: 0) {
                    Button(action: onCancel) {
                        Text(cancelTitle)
                            .font(.system(size: 16))
                            .foregroundColor(.gray)
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                    }
                    
                    Divider()
                        .background(Color.white.opacity(0.2))
                        .frame(height: 50)
                    
                    Button(action: onAction) {
                        Text(actionTitle)
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(Color(UIColor(hex: 0xFFD700)))
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                    }
                }
                .frame(height: 50)
            }
            .background(Color(UIColor(hex: 0x2C2C2E))) // Dark grey background
            .cornerRadius(14)
            .frame(width: 290)
        }
    }
}

struct CustomAlertView_Previews: PreviewProvider {
    static var previews: some View {
        CustomAlertView(
                    title: "Please turn on Bluetooth",
                    message: "Bluetooth on your phone is detected as off. Would you like to turn it on?",
                    cancelTitle: "Cancel",
                    actionTitle: "Confirm",
                    onCancel: {
                        print("Confirm操作")
                    },
                    onAction: {
                        print("执行删除操作")
                    }
                )
    }
}
