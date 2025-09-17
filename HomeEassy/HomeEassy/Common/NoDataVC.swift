//
//  NoDataVC.swift
//  KoovsOnlineFashion
//
//  Created by Koovs on 29/11/16.
//  Copyright © 2016 Koovs. All rights reserved.
//

import Foundation
import UIKit

@objc protocol NoDataVCDelegate : NSObjectProtocol {
     @objc optional func didTapActionButton()
}

@objc protocol NoDataVCDataSource : NSObjectProtocol {
    @objc optional func noDataImageName() -> String?
    @objc optional func noDataTitle() -> String?
    @objc optional func noDataSubTitle() -> String?
    @objc optional func noDataViewFrame() -> CGRect
    @objc optional func titleColor() -> UIColor
}

class NoDataVC : UIViewController {
    @IBOutlet weak var imageView : UIImageView?
    @IBOutlet weak var textLabel : UILabel?
    @IBOutlet weak var subTextLabel : UILabel?
    weak var dataSource : NoDataVCDataSource?
    weak var delegate : NoDataVCDelegate?
//  override func setUpTheme() {
//    super.setUpTheme()
//    textLabel?.font=Poppins.Bold.of(size: 24)
//    subTextLabel?.font=Poppins.regular.of(size: 16)
//  }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureVisibleItems()
        textLabel?.font=NiveauGrotesk.Bold.of(size: 24)
        subTextLabel?.font=NiveauGrotesk.regular.of(size: 16)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
      //  gradientLayer?.removeFromSuperlayer()
    }
    func configureVisibleItems() {
        if let color = dataSource?.titleColor?() {
            textLabel?.textColor = .black
            subTextLabel?.textColor = .black
        }
        else {
            textLabel?.textColor = .black
            subTextLabel?.textColor = .black
        }
        
        if let image = dataSource?.noDataImageName?() {
            imageView?.image = UIImage(named: "noOrderHistory")
        }
        else {
            imageView?.image = UIImage(named: "noOrderHistory")
        }

        if let title = dataSource?.noDataTitle?() {
            textLabel?.text = "UH oh, you have no orders"
        }
//        else {
//            textLabel?.text = "Ml.SORRY".localized()
//
//        }

        if let subTitle = dataSource?.noDataSubTitle?() {
            subTextLabel?.text = "Let's fix that right away. Shop your favourites brands now."
        }
//        else {
//            subTextLabel?.text = "Ml.SQUADNOT".localized()
//
//        }
    }
    
    
    @IBAction func buttonAction() {
        delegate?.didTapActionButton?()
    }
}
