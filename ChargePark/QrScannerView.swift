//
//  QrCodeView.swift
//  ChargePark
//
//  Created by apple on 08/11/21.
//
import Foundation
import UIKit
import AVFoundation

protocol QRScannerDelegate: class{
    func qrScanningDidFail()
    func qrScanningSucceededWithCode(_ str: String?)
    func qrScanningDidStop()
}
class QrScannerView:UIView {

        weak var delegate: QRScannerDelegate?
        /// capture settion which allows us to start and stop scanning.
        var captureSession: AVCaptureSession?
        
        // Init methods..
        required init?(coder aDecoder: NSCoder) {
            super.init(coder: aDecoder)
            doInitialSetup()
        }
        override init(frame: CGRect) {
            super.init(frame: frame)
            doInitialSetup()
        }
        
        //MARK: overriding the layerClass to return `AVCaptureVideoPreviewLayer`.
        override class var layerClass: AnyClass  {
            return AVCaptureVideoPreviewLayer.self
        }
        override var layer: AVCaptureVideoPreviewLayer {
            return super.layer as! AVCaptureVideoPreviewLayer
        }
}
extension QrScannerView{
    var isRunning: Bool {
        return captureSession?.isRunning ?? false
    }
    
    func startScanning() {
       captureSession?.startRunning()
    }
    
    func stopScanning() {
        captureSession?.stopRunning()
        delegate?.qrScanningDidStop()
    }
    
    /// Does the initial setup for captureSession
    private func doInitialSetup() {
        self.cornerRadius(with: 12.0)
        clipsToBounds = true
        captureSession = AVCaptureSession()
        
        guard let videoCaptureDevice = AVCaptureDevice.default(for: .video) else { return }
        let videoInput: AVCaptureDeviceInput
        do {
            videoInput = try AVCaptureDeviceInput(device: videoCaptureDevice)
        } catch let error {
            print(error)
            return
        }
        
        if (captureSession?.canAddInput(videoInput) ?? false) {
            captureSession?.addInput(videoInput)
        } else {
            scanningDidFail()
            return
        }
        
        let metadataOutput = AVCaptureMetadataOutput()
        
        if (captureSession?.canAddOutput(metadataOutput) ?? false) {
            captureSession?.addOutput(metadataOutput)
            
            metadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            metadataOutput.metadataObjectTypes = [.qr, .ean8, .ean13, .pdf417]
        } else {
            scanningDidFail()
            return
        }
        
        self.layer.session = captureSession
        self.layer.videoGravity = .resizeAspectFill
        
        captureSession?.startRunning()
    }
    func scanningDidFail() {
        delegate?.qrScanningDidFail()
        captureSession = nil
    }
    
    func found(code: String) {
      delegate?.qrScanningSucceededWithCode(code)
    }
}
extension QrScannerView: AVCaptureMetadataOutputObjectsDelegate {
    func metadataOutput(_ output: AVCaptureMetadataOutput,
                        didOutput metadataObjects: [AVMetadataObject],
                        from connection: AVCaptureConnection) {
        stopScanning()
        
        if let metadataObject = metadataObjects.first {
            guard let readableObject = metadataObject as? AVMetadataMachineReadableCodeObject else { return }
            guard let stringValue = readableObject.stringValue else { return }
            AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
            found(code: stringValue)
        }
    }
    
}
