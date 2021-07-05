//
//  QRCodeScannerViewController.swift
//  Hario
//
//  Created by Mauldy Putra on 20/05/20.
//  Copyright © 2020 innocent. All rights reserved.
//

import UIKit
import AVFoundation

class QRCodeScannerViewController: UIViewController, AVCaptureMetadataOutputObjectsDelegate {
    
    @IBOutlet weak var previewView: UIView!
    @IBOutlet weak var flashButton: UIButton!
    @IBOutlet weak var kodeQRButton: UIButton!
    
    var video = AVCaptureVideoPreviewLayer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Pindai"
        
        //Creating Session
        let session = AVCaptureSession()
        
        //Define Capture Device
        guard let captureDevice = AVCaptureDevice.default(for: .video) else { return }
        
        do {
            let input = try AVCaptureDeviceInput(device: captureDevice)
            session.addInput(input)
        } catch {
            print("error")
        }
        
        let output = AVCaptureMetadataOutput()
        session.addOutput(output)
        
        output.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
        
        output.metadataObjectTypes = [.qr]
        
        video = AVCaptureVideoPreviewLayer(session: session)
        video.frame = view.layer.bounds
        video.videoGravity = .resizeAspectFill
        view.layer.addSublayer(video)
        
        kodeQRButton.backgroundColor = UIColor.rgb(red: 58, green: 184, blue: 160)
        flashButton.layer.cornerRadius = flashButton.frame.height / 2
        
        view.bringSubviewToFront(previewView)
        view.bringSubviewToFront(flashButton)
        view.bringSubviewToFront(kodeQRButton)
        
        session.startRunning()
    }
    @IBAction func flashButton(_ sender: UIButton) {
        guard let device = AVCaptureDevice.default(for: AVMediaType.video) else { return }
        guard device.hasTorch else { return }
        
        do {
            try device.lockForConfiguration()
            
            if (device.torchMode == AVCaptureDevice.TorchMode.on) {
                device.torchMode = AVCaptureDevice.TorchMode.off
//                flashButton.setImage(R.image.flashOut(), for: .normal)
            } else {
                do {
                    try device.setTorchModeOn(level: 1.0)
//                    flashButton.setImage(R.image.flashIn(), for: .normal)
                } catch {
                    print(error)
                }
            }
            
            device.unlockForConfiguration()
        } catch {
            print(error)
        }
    }
    
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        if metadataObjects != nil && metadataObjects.count != 0{
            if let object = metadataObjects[0] as? AVMetadataMachineReadableCodeObject {
                if object.type == .qr {
                    let alert = UIAlertController(title: "QR Code", message: object.stringValue, preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Open", style: .default, handler: { (nil) in
                        let application = UIApplication.shared
                        let appUrl = URL(string: object.stringValue!)
                        if #available(iOS 11.0, *){
                            application.open(appUrl!, options: [:], completionHandler: nil)
                        } else {
                            if application.canOpenURL(appUrl! as URL){
                                application.openURL(appUrl! as URL)
                            }
                        }
//                        application.open(appUrl!, options: [:], completionHandler: nil)
                    }))
                    alert.addAction(UIAlertAction(title: "Retake", style: .default, handler: nil))
                    alert.addAction(UIAlertAction(title: "Copy", style: .default, handler: { (nil) in
                        UIPasteboard.general.string = object.stringValue
                    }))
                    present(alert, animated: true, completion: nil)
                }
            }
        }
    }
    
    @IBAction func kodeQRButton(_ sender: UIButton) {
        let modal = QRCodeView()
        
        modal.modalPresentationStyle = .overCurrentContext
        modal.modalTransitionStyle = .crossDissolve
        
        navigationController?.present(modal, animated: true, completion: nil)
    }
}

extension UIColor {
    static func rgb(red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat = 1) -> UIColor {
        return UIColor(red: red/255, green: green/255, blue: blue/255, alpha: alpha)
    }
}
