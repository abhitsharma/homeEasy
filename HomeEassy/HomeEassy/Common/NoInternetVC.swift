//
//  NoInternetVC.swift
//  KoovsOnlineFashion
//
//  Created by Koovs on 10/05/17.
//  Copyright © 2017 Koovs. All rights reserved.
//

import Foundation
import UIKit
protocol NoInternetHandler : NSObjectProtocol {
  func retryAction(object : Any?)
}

@objc protocol NoInternetVCDataSource : NSObjectProtocol {
    @objc optional func noDataImageName() -> String?
    @objc optional func noDataTitle() -> String?
    @objc optional func noDataSubTitle() -> String?
    @objc optional func noDataViewFrame() -> CGRect
    @objc optional func titleColor() -> UIColor
}



class NoInternetVC : UIViewController {
    // var completionHandler : ((Any?) -> Void)?
    var infoObject : Any?
    weak var delegate : NoInternetHandler?
    weak var dataSource : NoInternetVCDataSource?
    @IBOutlet weak var btnRetry: UIButton?
    
    @IBOutlet weak var lblinfo: UILabel?
    @IBOutlet weak var lblTitle: UILabel?
    @IBOutlet weak var imgNet: UIImageView?
    override func viewDidLoad() {

    }
    @IBAction func retryButtonTapped() {
      delegate?.retryAction(object: infoObject)
    }
    
   
    
}
