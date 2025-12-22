import SwiftUI
import AVFoundation
import Photos
import CoreImage
import UIKit

struct QRCodeScannerView: View {
    var onResult: ((String) -> Void)?
    @Environment(\.dismiss) private var dismiss
    @State private var isRunning = true
    @State private var isTorchOn = false
    @State private var showPicker = false
    @State private var containerSize: CGSize = .zero
    
    private var scanRect: CGRect {
        let w = containerSize.width * 0.66
        let h = w
        let x = (containerSize.width - w) / 2
        let y = (containerSize.height - h) / 2 - 40
        return CGRect(x: max(0, x), y: max(0, y), width: w, height: h)
    }
    
    var body: some View {
        GeometryReader { geo in
            ZStack {
                CameraPreview(isRunning: $isRunning, scanRect: scanRect, isTorchOn: $isTorchOn) { str in
                    isRunning = false
                    onResult?(str)
                    dismiss()
                }
                overlayMask(container: geo.size, hole: scanRect)
                scanCorners(rect: scanRect)
                VStack {
                    HStack {
                        Button {
                            dismiss()
                        } label: {
                            Image("left-arrows").renderingMode(.template).foregroundColor(.white)
                                .frame(width: 32, height: 32)
                        }
                        .padding(.leading, 20)
                        .padding(.top, 54)
                        Spacer()
                    }
                    Spacer()
                    HStack {
                        Button {
                            isTorchOn.toggle()
                        } label: {
                            Circle()
                                .fill(Color(UIColor(hex: 0xFFDA3C)))
                                .frame(width: 40, height: 40)
                                .overlay(
                                    Image("sun-line").renderingMode(.template).foregroundColor(.black)
                                )
                        }
                        .padding(.leading, 40)
                        Spacer()
                        Button {
                            showPicker = true
                        } label: {
                            Circle()
                                .fill(Color(UIColor(hex: 0xFFDA3C)))
                                .frame(width: 40, height: 40)
                                .overlay(
                                    Image("photo").renderingMode(.template).foregroundColor(.black)
                                )
                        }
                        .padding(.trailing, 40)
                    }
                    .padding(.bottom, 60)
                }
            }
            .onAppear { containerSize = geo.size }
        }
        .sheet(isPresented: $showPicker) {
            ImagePicker { image in
                guard let image = image, let ci = CIImage(image: image) else { return }
                let detector = CIDetector(ofType: CIDetectorTypeQRCode, context: nil, options: [CIDetectorAccuracy: CIDetectorAccuracyHigh])
                let features = detector?.features(in: ci) ?? []
                for f in features {
                    if let qr = f as? CIQRCodeFeature, let str = qr.messageString, !str.isEmpty {
                        onResult?(str)
                        dismiss()
                        break
                    }
                }
            }
        }
        .background(Color.black)
        .ignoresSafeArea()
    }
    
    private func overlayMask(container: CGSize, hole: CGRect) -> some View {
        Path { path in
            path.addRect(CGRect(origin: .zero, size: container))
            path.addRoundedRect(in: hole, cornerSize: CGSize(width: 10, height: 10))
        }
        .fill(Color.black.opacity(0.4), style: FillStyle(eoFill: true))
    }
    
    private func scanCorners(rect: CGRect) -> some View {
        let color = Color(UIColor(hex: 0xFFDA3C))
        let size: CGFloat = 12
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
    }
}

final class QRCodeScannerViewController: UIHostingController<QRCodeScannerView> {
    init(onResult: ((String) -> Void)? = nil) {
        super.init(rootView: QRCodeScannerView(onResult: onResult))
        modalPresentationStyle = .fullScreen
    }
    @MainActor required dynamic init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

struct CameraPreview: UIViewRepresentable {
    @Binding var isRunning: Bool
    var scanRect: CGRect
    @Binding var isTorchOn: Bool
    var onResult: (String) -> Void
    
    func makeCoordinator() -> Coordinator {
        Coordinator(onResult: onResult)
    }
    
    func makeUIView(context: Context) -> UIView {
        let view = PreviewView()
        context.coordinator.configureSession(on: view)
        return view
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {
        guard let layer = (uiView.layer as? AVCaptureVideoPreviewLayer), let output = context.coordinator.output else { return }
        if isRunning { context.coordinator.session?.startRunning() } else { context.coordinator.session?.stopRunning() }
        if let session = context.coordinator.session, session.isRunning {
            let interest = layer.metadataOutputRectConverted(fromLayerRect: scanRect)
            output.rectOfInterest = interest
        }
        context.coordinator.setTorch(isTorchOn)
    }
    
    final class Coordinator: NSObject, AVCaptureMetadataOutputObjectsDelegate {
        var session: AVCaptureSession?
        var output: AVCaptureMetadataOutput?
        var onResult: (String) -> Void
        
        init(onResult: @escaping (String) -> Void) {
            self.onResult = onResult
        }
        
        func configureSession(on view: UIView) {
            let session = AVCaptureSession()
            session.sessionPreset = .high
            guard let device = AVCaptureDevice.default(for: .video),
                  let input = try? AVCaptureDeviceInput(device: device) else { return }
            if session.canAddInput(input) { session.addInput(input) }
            let output = AVCaptureMetadataOutput()
            if session.canAddOutput(output) { session.addOutput(output) }
            output.setMetadataObjectsDelegate(self, queue: .main)
            output.metadataObjectTypes = [.qr]
            let layer = view.layer as! AVCaptureVideoPreviewLayer
            layer.session = session
            layer.videoGravity = .resizeAspectFill
            self.session = session
            self.output = output
            session.startRunning()
        }
        
        func setTorch(_ on: Bool) {
            guard let device = AVCaptureDevice.default(for: .video), device.hasTorch else { return }
            do {
                try device.lockForConfiguration()
                device.torchMode = on ? .on : .off
                device.unlockForConfiguration()
            } catch { }
        }
        
        func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
            for obj in metadataObjects {
                if let code = obj as? AVMetadataMachineReadableCodeObject, code.type == .qr, let str = code.stringValue, !str.isEmpty {
                    session?.stopRunning()
                    onResult(str)
                    break
                }
            }
        }
    }
}

final class PreviewView: UIView {
    override class var layerClass: AnyClass { AVCaptureVideoPreviewLayer.self }
}

struct ImagePicker: UIViewControllerRepresentable {
    var onSelected: (UIImage?) -> Void
    
    func makeCoordinator() -> Coordinator {
        Coordinator(onSelected: onSelected)
    }
    
    func makeUIViewController(context: Context) -> UIImagePickerController {
        let status = PHPhotoLibrary.authorizationStatus()
        if status == .notDetermined {
            PHPhotoLibrary.requestAuthorization { _ in }
        }
        let picker = UIImagePickerController()
        picker.sourceType = .photoLibrary
        picker.delegate = context.coordinator
        picker.modalPresentationStyle = .fullScreen
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}
    
    final class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        var onSelected: (UIImage?) -> Void
        init(onSelected: @escaping (UIImage?) -> Void) { self.onSelected = onSelected }
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) { onSelected(nil) }
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            let image = info[.originalImage] as? UIImage
            onSelected(image)
        }
    }
}


// 预览
struct QRCodeScannerView_Previews: PreviewProvider {
    static var previews: some View {
        QRCodeScannerView(onResult: { result in
            print("QR Code Scanned: \(result)")
        })
    }
}
