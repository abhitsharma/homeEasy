//
//  UIDevice+Extension.swift
//  CricketLineGuru
//
//  Created by Abhinav Mudgal on 30/08/20.
//  Copyright © 2020 CricketLineGuru. All rights reserved.
//

import UIKit
import Foundation

public extension UIDevice {
  /// Source https://stackoverflow.com/a/46192822/774798
  var iPhoneX: Bool {
    if UIDevice.current.userInterfaceIdiom == .phone {
      switch UIScreen.main.nativeBounds.height {
      case 1136: // iPhone 5 or 5S or 5C
        return false
      case 1334: // iPhone 6/6S/7/8
        return false
      case 1920, 2208: // iPhone 6+/6S+/7+/8+
        return false
      case 2436: // iPhone X, Xs
        return true
      case 2688: // iPhone Xs Max
        return true
      case 1792: // iPhone Xr
        return true
      default: // unknown
        return false
      }
    }
    return false
  }
  var isLandscape: Bool {
    return UIDevice.current.orientation.isLandscape
  }
}

public extension UIScreen {
  /// Width of the screen
  static var width: CGFloat {
    return UIScreen.main.bounds.size.width
  }
  /// Height of the screen
  static var height: CGFloat {
    return UIScreen.main.bounds.size.height
  }
}

extension UIApplication {
  static var appVersion: String {
    if let appVersion = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") {
      return "\(appVersion)"
    } else {
      return ""
    }
  }
  
  static var build: String {
    if let buildVersion = Bundle.main.object(forInfoDictionaryKey: kCFBundleVersionKey as String) {
      return "\(buildVersion)"
    } else {
      return ""
    }
  }
  static var appIdentifier: String {
    if let buildVersion = Bundle.main.object(forInfoDictionaryKey: kCFBundleIdentifierKey as String) {
      return "\(buildVersion)"
    } else {
      return ""
    }
  }
  static var appName: String {
    if let appVersion = Bundle.main.object(forInfoDictionaryKey: "CFBundleDisplayName") {
      return "\(appVersion)"
    } else {
      return ""
    }
  }
  
  static var versionBuild: String {
    let version = UIApplication.appVersion
      let versionAndBuild = " Version - \(version)"
        return versionAndBuild
  }
  
}
