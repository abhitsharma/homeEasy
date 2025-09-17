//
//  StatusToast.swift
//  CollectionDemo
//
//  Created by Swatantra on 25/03/19.
//  Copyright © 2019 Swatantra. All rights reserved.
//

import Foundation
import UIKit

class StatusToast {
  static let shared = StatusToast()
  var viewStatusBar:UIView?
  private  init() {}
  func showToast() {
    if viewStatusBar==nil{
      let stor=UIStoryboard.init(name: "Discovery", bundle: nil)
      let vc=stor.instantiateViewController(withIdentifier: "StatusVc")
      viewStatusBar=vc.view
    }
    let heiht=UIApplication .shared.statusBarFrame.size.height
    let rect = CGRect(origin: CGPoint(x: 0, y: 0), size:CGSize(width: SCREEN_WIDTH, height:0))
    viewStatusBar?.frame=rect
    viewStatusBar!.backgroundColor = UIColor.red //Replace value with your required background color
    UIApplication.shared.keyWindow!.addSubview(viewStatusBar!)
    UIView.animate(withDuration: 0.2) {
      let rect = CGRect(origin: CGPoint(x: 0, y: 0), size:CGSize(width: SCREEN_WIDTH, height:heiht))
      self.viewStatusBar?.frame=rect
    }}
  
  func hideToast() {
    UIView.animate(withDuration: 0.2, animations: {
      let rect = CGRect(origin: CGPoint(x: 0, y: 0), size:CGSize(width: SCREEN_WIDTH, height:0))
      self.viewStatusBar?.frame=rect
    }) { (tr) in
      self.viewStatusBar?.removeFromSuperview()
    }
  }
}
