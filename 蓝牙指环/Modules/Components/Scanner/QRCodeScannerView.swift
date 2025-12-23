import SwiftUI
import UIKit

struct QRScannerView: View {

    @Environment(\.dismiss) private var dismiss
    @StateObject private var vm = ScannerViewModel()
    @State private var size: CGSize = .zero
    @State private var showPicker = false

    var onResult: (String) -> Void

    private var yellow: Color {
        Color(UIColor(hex: 0xFFDA3C))
    }

    private var scanRect: CGRect {
        let w = size.width * 0.66
        let x = (size.width - w) / 2
        let y = (size.height - w) / 2
        return CGRect(x: x, y: y, width: w, height: w)
    }

    var body: some View {
        GeometryReader { geo in
            ZStack {

                /// 摄像头预览
                CameraPreview(vm: vm, scanRect: scanRect)
                    .ignoresSafeArea()

                /// 遮罩（全屏）
                overlayMask(container: UIScreen.main.bounds.size, hole: scanRect)
                    .ignoresSafeArea()

                /// 扫码角标
                scanCorners(rect: scanRect)

                /// 底部操作区
                VStack {
                    Spacer()
                    HStack {
                        CircleButton(asset: "sun-line", color: yellow, size: 40) {
                            vm.isTorchOn.toggle()
                        }
                        Spacer()
                        CircleButton(asset: "photo", color: yellow, size: 40) {
                            showPicker = true
                        }
                    }
                    .padding(.horizontal, 40)
                    .padding(.bottom, 40)
                }
            }
            .safeAreaInset(edge: .top) {
                /// 系统导航栏位置返回按钮
                HStack {
                    Button {
                        dismiss()
                    } label: {
                        Image("left-arrows")
                            .renderingMode(.template)
                            .foregroundColor(.white)
                            .frame(width: 32, height: 32)
                    }
                    Spacer()
                }
                .padding(.horizontal, 20)
                .padding(.top, 8)
                .background(Color.clear)
            }
            .onAppear {
                size = geo.size
                vm.isContinuous = false
                vm.onResult = { code in
                    onResult(code)
                    dismiss()
                }
            }
        }
        .sheet(isPresented: $showPicker) {
            ImagePicker { image in
                vm.scanQRCode(from: image)
            }
        }
    }
}

private func overlayMask(container: CGSize, hole: CGRect) -> some View {
    Path { path in
        path.addRect(CGRect(origin: .zero, size: container))
        path.addRoundedRect(
            in: hole,
            cornerSize: CGSize(width: 10, height: 10)
        )
    }
    .fill(Color.black.opacity(0.55), style: FillStyle(eoFill: true))
}

private func scanCorners(rect: CGRect) -> some View {
    let color = Color(UIColor(hex: 0xFFDA3C))
    let size: CGFloat = 14
    let t: CGFloat = 2
    return ZStack {
        Rectangle().fill(color).frame(width: size, height: t).position(x: rect.minX + size/2, y: rect.minY + t/2)
        Rectangle().fill(color).frame(width: t, height: size).position(x: rect.minX + t/2, y: rect.minY + size/2)
        Rectangle().fill(color).frame(width: size, height: t).position(x: rect.maxX - size/2, y: rect.minY + t/2)
        Rectangle().fill(color).frame(width: t, height: size).position(x: rect.maxX - t/2, y: rect.minY + size/2)
        Rectangle().fill(color).frame(width: size, height: t).position(x: rect.minX + size/2, y: rect.maxY - t/2)
        Rectangle().fill(color).frame(width: t, height: size).position(x: rect.minX + t/2, y: rect.maxY - size/2)
        Rectangle().fill(color).frame(width: size, height: t).position(x: rect.maxX - size/2, y: rect.maxY - t/2)
        Rectangle().fill(color).frame(width: t, height: size).position(x: rect.maxX - t/2, y: rect.maxY - size/2)
    }
    .ignoresSafeArea()
}

private struct CircleButton: View {
    var asset: String
    var color: Color
    var size: CGFloat
    var action: () -> Void

    var body: some View {
        Button(action: action) {
            Image(asset)
                .renderingMode(.template)
                .foregroundColor(.black)
                .frame(width: size, height: size)
                .background(color)
                .clipShape(Circle())
        }
    }
}

//struct QRScannerView_Previews: PreviewProvider {
//    static var previews: some View {
//        QRScannerView { code in
//            print("扫码结果:", code)
//        }
//    }
//}
