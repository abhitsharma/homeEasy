//
//  NetworkStatusHandler.swift
//  KoovsOnlineFashion
//
//  Created by Koovs on 11/11/16.
//  Copyright © 2016 Koovs. All rights reserved.
//

import Foundation
import UIKit
//import CRToast
import Reachability

class NetworkStatusHandler {
  static var isInternetRechable: Bool = false
  static var crtoastIdentifier = "CRtoastIdentifier"
  static var reachability: Reachability?
  
  class func startNetworkReachabilityTesting(){
    
    reachability = try! Reachability.init()
    NotificationCenter.default.addObserver(self, selector: #selector(NetworkStatusHandler.reachabilityChanged), name: Notification.Name.reachabilityChanged, object: reachability)
    do {
      try reachability?.startNotifier()
    } catch {}
  }
  
  @objc class func reachabilityChanged(_ note: Notification) {
    let reachability = note.object as! Reachability
    if reachability.connection != .none {
      isInternetRechable = true
      DispatchQueue.main.async(execute: {
        StatusToast.shared.hideToast()
      })}
    else
    {
      isInternetRechable = false
      StatusToast.shared.showToast()
    }}
}
