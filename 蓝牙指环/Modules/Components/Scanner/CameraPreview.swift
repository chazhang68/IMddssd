//
//  CameraPreview.swift
//  蓝牙指环
//
//  Created by zz on 2025/12/23.
//

import SwiftUI
import AVFoundation

struct CameraPreview: UIViewRepresentable {

    @ObservedObject var vm: ScannerViewModel
    var scanRect: CGRect

    func makeCoordinator() -> Coordinator {
        Coordinator(vm: vm)
    }

    func makeUIView(context: Context) -> PreviewView {
        let view = PreviewView()
        let layer = view.layer as! AVCaptureVideoPreviewLayer
        layer.videoGravity = .resizeAspectFill
        layer.session = vm.session

        vm.output.setMetadataObjectsDelegate(context.coordinator, queue: .main)
        vm.requestPermission()
        return view
    }

    func updateUIView(_ uiView: PreviewView, context: Context) {
        guard scanRect.width > 0,
              let layer = uiView.layer as? AVCaptureVideoPreviewLayer else { return }

        let interest = layer.metadataOutputRectConverted(fromLayerRect: scanRect)
        vm.output.rectOfInterest = interest
        vm.setTorch(vm.isTorchOn)
    }

    final class Coordinator: NSObject, AVCaptureMetadataOutputObjectsDelegate {

        let vm: ScannerViewModel
        init(vm: ScannerViewModel) { self.vm = vm }

        func metadataOutput(_ output: AVCaptureMetadataOutput,
                            didOutput metadataObjects: [AVMetadataObject],
                            from connection: AVCaptureConnection) {

            for obj in metadataObjects {
                guard let code = obj as? AVMetadataMachineReadableCodeObject,
                      let str = code.stringValue,
                      !str.isEmpty else { continue }

                vm.handleScanResult(str)
                break
            }
        }
    }
}

