//
//  SwiftViewController.swift
//  ImageGenerator
//
//  Created by youger on 2022/9/8.
//

import UIKit

class SwiftViewController: UIViewController {
    
    @IBOutlet weak var _imageView0: UIImageView!
    @IBOutlet weak var _imageView1: UIImageView!
    @IBOutlet weak var _imageView2: UIImageView!
    @IBOutlet weak var _imageView3: UIImageView!
    @IBOutlet weak var _imageView4: UIImageView!
    @IBOutlet weak var _imageView5: UIImageView!
    @IBOutlet weak var _imageView6: UIImageView!
    @IBOutlet weak var _imageView7: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        _imageView0.image = LYImageGenerator.circle("70_70_07B222_3_F7B222")
        _imageView1.image = LYImageGenerator.borderCircle("70_70_07B333_5")
        _imageView2.image = LYImageGenerator.intersectLine("60_60_07B333_5")
        _imageView3.image = LYImageGenerator.gradientImage("70_70_2_0B7200_FFFFFF")
        _imageView4.image = LYImageGenerator.popover(size: CGSize(width: 70, height: 50), triangleSize: CGSize(width: 12, height: 7), triangleInsets: UIEdgeInsets.init(top: 0, left: 10, bottom: 0, right: 0), cornerRadius: 4, fillColor: scanColor(with: "07B333"))
        _imageView5.image = LYImageGenerator.circle("70_70_07B222", shadow: "0_-6_F7B222_0.2_1")
        //_imageView5.image = [LYImageGenerator featureDecorationImage];
        _imageView6.image = LYImageGenerator.rectangle("70_70_07B222_0_10", corners: [.topLeft, .bottomRight])
        
    }
}
