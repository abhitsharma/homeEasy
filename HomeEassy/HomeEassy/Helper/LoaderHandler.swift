//
//  LoaderHandler.swift
//  KoovsOnlineFashion
//
//  Created by Koovs on 11/11/16.
//  Copyright © 2016 Koovs. All rights reserved.
//

import Foundation
import UIKit
//import Toast_Swift
let tag = "HUDLoaderView".hash

class LoaderHandler {
  
  class func showLoader(_ view: UIView?, title: String? = nil, animated: Bool = true) {
    if AppHelper.isNetworkReachble(){
      if let view = view {
        if view.viewWithTag(tag) == nil {
          DispatchQueue.main.async {
            if let customView = Bundle.main.loadNibNamed("HUDLoaderView", owner: nil, options: nil)?[0] as? UIView {
              var frame = view.bounds 
              frame.origin.x -= 50
              frame.size.width += 100
              customView.frame = frame
              customView.tag = tag
                UIView.animate(withDuration: 0.325, delay: 0, options: UIView.AnimationOptions.transitionCrossDissolve, animations: {
                view.addSubview(customView)
              }, completion: { (completed) in
              })
            }
          }}}}}
  
  class func hideLoader(_ view: UIView?, title: String? = nil, animated: Bool = true) {
    if let view = view {
      DispatchQueue.main.async {
        let customView = view.viewWithTag(tag)
          UIView.animate(withDuration: 0.325, delay: 0, options: UIView.AnimationOptions.transitionCrossDissolve, animations: {
          customView?.removeFromSuperview()
        }, completion: { (completed) in
        })
      }}}
  
  
  class func showToast(_ view : UIView?, title: String?, ttl:CGFloat = 2.0, dismissable : Bool = false) {
    let style = ToastStyle()
    ToastManager.shared.style = style
    ToastManager.shared.isTapToDismissEnabled = true
    ToastManager.shared.isQueueEnabled = true
  }}


