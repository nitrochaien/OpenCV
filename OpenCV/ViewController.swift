//
//  ViewController.swift
//  OpenCV
//
//  Created by Nam Vu on 4/5/18.
//  Copyright © 2018 Grooo International Inc. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    var counter = 0
    
    var defaultImage: UIImage!
    var thresholdImage: UIImage!
    var blackAndWhiteImage: UIImage!
    var edgeImage: UIImage!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let tap = UITapGestureRecognizer()
        tap.addTarget(self, action: #selector(onTapImage))
        imageView.addGestureRecognizer(tap)
        
        let openCV = OpenCVWrapper()
        defaultImage = imageView.image
        thresholdImage = openCV.thresholding(defaultImage)
        blackAndWhiteImage = openCV.blackAndWhite(defaultImage)
        edgeImage = openCV.edgeDetection(defaultImage)
        print("Completed!")
    }
    
    @objc func onTapImage() {
        counter += 1
        switch counter {
        case 0:
            imageView.image = defaultImage
            break;
        case 1:
            imageView.image = thresholdImage
            break;
        case 2:
            imageView.image = blackAndWhiteImage
            break;
        case 3:
            imageView.image = edgeImage
            break;
        default:
            counter = -1
            onTapImage()
        }
    }
}
