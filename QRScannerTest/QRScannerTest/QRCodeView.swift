//
//  QRCodeView.swift
//  Hario
//
//  Created by Mauldy Putra on 15/05/20.
//  Copyright © 2020 innocent. All rights reserved.
//

import UIKit

class QRCodeView: UIViewController {
    
    @IBOutlet weak var imageQrCode: UIImageView!
    @IBOutlet var backgroundView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Kode QR"
        
//        let tapBackgroundView = UITapGestureRecognizer(target: self, action: #selector(dismissView))
//        backgroundView.isUserInteractionEnabled = true
//        backgroundView.addGestureRecognizer(tapBackgroundView)
        
        convertToQR()
    }
    
    func convertToQR(){
//        let stringVal = AuthManager.getEmail()
//        let data = stringVal?.data(using: String.Encoding.ascii)
        guard let qrFilter = CIFilter(name: "CIQRCodeGenerator") else { return }
//        qrFilter.setValue(data, forKey: "inputMessage")
        guard let qrImage = qrFilter.outputImage else { return }
        
        let transform = CGAffineTransform(scaleX: 10, y: 10)
        let scaleQrImage = qrImage.transformed(by: transform)
        
        let context = CIContext()
        guard let cgImage = context.createCGImage(scaleQrImage, from: scaleQrImage.extent) else { return }
        let processedImage = UIImage(cgImage: cgImage)
        
        imageQrCode.image = processedImage
    }
    
    @IBAction func closeTapped(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func dismissView(){
        dismiss(animated: true, completion: nil)
    }
}
