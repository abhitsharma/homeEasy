//
//  SplashScreenVC.swift
//  HomeEassy
//
//  Created by Macbook on 20/10/23.
//

import UIKit
import SwiftGifOrigin
class SplashScreenVC: UIViewController {
    var tabbarController: CLGTabBarViewController?
    @IBOutlet weak var imgTvScreen: UIImageView?
    var isBannerLoaded = false
    override func viewDidLoad() {
        super.viewDidLoad()
        let img = try? UIImage(gifName: "finalanimation.gif")
        imgTvScreen?.setGifImage(img!  , loopCount: 1)
       
    }

}

