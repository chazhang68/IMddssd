//
//  PreviewView.swift
//  蓝牙指环
//
//  Created by zz on 2025/12/23.
//
import UIKit
import AVFoundation

final class PreviewView: UIView {

    override class var layerClass: AnyClass {
        AVCaptureVideoPreviewLayer.self
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        (layer as? AVCaptureVideoPreviewLayer)?.frame = bounds
    }
}

