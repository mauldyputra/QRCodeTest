//
//  ImagePreview.swift
//  QRScannerTest
//
//  Created by Mauldy Putra on 05/07/21.
//

import UIKit

class ImagePreview: UIViewController {

    @IBOutlet weak var imagePreview: UIImageView!
    
    var image: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "Hasil Foto"
        self.imagePreview.image = image
    }
}
