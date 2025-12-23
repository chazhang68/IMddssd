import Foundation
import AVFoundation
import SwiftUI
import Combine
import CoreImage

final class ScannerViewModel: NSObject, ObservableObject {

    @Published var isRunning = false
    @Published var isTorchOn = false

    let session = AVCaptureSession()
    let output = AVCaptureMetadataOutput()

    var isContinuous: Bool = true
    var debounceInterval: TimeInterval = 1.5

    var onResult: ((String) -> Void)?

    private var lastResult: String?
    private var lastScanTime: TimeInterval = 0

    func requestPermission() {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .authorized:
            setupSession()
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { granted in
                DispatchQueue.main.async {
                    if granted { self.setupSession() }
                }
            }
        default:
            break
        }
    }

    private func setupSession() {
        guard session.inputs.isEmpty else { return }

        session.beginConfiguration()
        session.sessionPreset = .high

        guard let device = AVCaptureDevice.default(for: .video),
              let input = try? AVCaptureDeviceInput(device: device) else {
            session.commitConfiguration()
            return
        }

        if session.canAddInput(input) {
            session.addInput(input)
        }

        if session.canAddOutput(output) {
            session.addOutput(output)
        }

        output.metadataObjectTypes = [.qr]
        session.commitConfiguration()

        DispatchQueue.global(qos: .userInitiated).async {
            self.session.startRunning()
            DispatchQueue.main.async {
                self.isRunning = true
            }
        }
    }

    func stopSession() {
        guard session.isRunning else { return }
        session.stopRunning()
        isRunning = false
    }

    func setTorch(_ on: Bool) {
        guard let device = AVCaptureDevice.default(for: .video),
              device.hasTorch else { return }
        try? device.lockForConfiguration()
        device.torchMode = on ? .on : .off
        device.unlockForConfiguration()
    }

    // (连续扫码 + 防抖)
    func handleScanResult(_ value: String) {
        let now = Date().timeIntervalSince1970

        if !isContinuous {
            stopSession()
            onResult?(value)
            return
        }

        if value == lastResult,
           now - lastScanTime < debounceInterval {
            return
        }

        lastResult = value
        lastScanTime = now
        onResult?(value)
    }

    // 相册扫码
    func scanQRCode(from image: UIImage) {
        guard let ciImage = CIImage(image: image) else { return }

        let detector = CIDetector(
            ofType: CIDetectorTypeQRCode,
            context: nil,
            options: [CIDetectorAccuracy: CIDetectorAccuracyHigh]
        )

        let features = detector?.features(in: ciImage) ?? []
        for feature in features {
            if let qr = feature as? CIQRCodeFeature,
               let str = qr.messageString {
                handleScanResult(str)
            }
        }
    }
}
