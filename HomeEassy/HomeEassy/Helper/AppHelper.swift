//
//  AppHelper.swift
//  FITOPPO
//
//  Created by swatantra on 2/7/17.
//  Copyright © 2017 swatantra. All rights reserved.
//

import Foundation
import QuartzCore
import UIKit
import SystemConfiguration


typealias  DidSelectedAction = ((_ selectedAction: String) -> Void)

class AppHelper {
    static let appDelegate = (UIApplication.shared.delegate! as! AppDelegate)
    static let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as! SceneDelegate
    static let sharedInstance = AppHelper()
    var  shippingChargeText:String?
    private init() {
        //let navi: UINavigationController? = AppHelper.navigationController()
    }

    class func navigationController() -> UINavigationController {
      return (AppHelper.sceneDelegate.tabbarController!.selectedViewController as! UINavigationController)
    }
  
    static  func shareAction(_ shareView:UIViewController, share:[Any]) {
        DispatchQueue.main.async {
            let activityViewController = UIActivityViewController(activityItems: share , applicationActivities: nil)
            activityViewController.popoverPresentationController?.sourceView = shareView.view
            activityViewController.completionWithItemsHandler = { (activityType, completed:Bool, returnedItems:[Any]?, error: Error?) in
                if completed {
                    // Do something
                    DispatchQueue.main.async {
                        
                        shareView.dismiss(animated: false, completion: nil)
                    }
                }
            }
            shareView.present(activityViewController, animated: true, completion: nil)
        }
    }
    
    class func rootViewController() -> UIViewController{
        if #available(iOS 13.0, *) {
            let sceneDelegate = UIApplication.shared.connectedScenes
                .first!.delegate as! SceneDelegate
            return  (sceneDelegate.window?.rootViewController)!
        } else {
            // Fallback on earlier versions

           return UIApplication.shared.windows.first!.rootViewController as! UIViewController
        }
    }
    
    class func getDeviceID() -> String {
       return UIDevice.current.identifierForVendor!.uuidString
    }
    
    //MARK: USER DEFAULT
    
    class func saveToUserDefaults(value: Any?, withKey key: String) {
        if let value=value{
            let standardUserDefaults = UserDefaults.standard
            standardUserDefaults.set(value, forKey: key)
        }
    }
    
    class func userDefaultsForKey(key: String) -> Any? {
        let standardUserDefaults = UserDefaults.standard
        var val: Any?
        val = standardUserDefaults.value(forKey: key)
        
        return val
    }
    
    class func removeFromUserDefaultsWithKey(key: String) {
        let  standardUserDefaults = UserDefaults.standard
        standardUserDefaults.removeObject(forKey: key)
        //standardUserDefaults.synchronize()
    }
   
    //MARK:-network reachablity
    func showAlertView(title:String , message:String , cancelButtonTille:String ,otherButtonTitles:String ,andSelectedValuesCallBack selectedItemsCallBack:DidSelectedAction? = nil){
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        // alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
        
        if !otherButtonTitles.isEmpty {
            let cancelAction = UIAlertAction.init(title: otherButtonTitles, style: .default, handler: { (act) in
                NSLog("Cancel Pressed")
                selectedItemsCallBack?("2")
            })
            
            alert.addAction(cancelAction)
            
        }
        let okAction = UIAlertAction(title: cancelButtonTille, style: UIAlertAction.Style.default) {
            UIAlertAction in
            NSLog("OK Pressed")
            selectedItemsCallBack?("1")
        }
        
        alert.addAction(okAction)
        AppHelper.rootViewController().present(alert, animated: true, completion: nil)
    }
    
    static func isNetworkReachble()->Bool{
      var  isNet = false
      
      if NSObject.currentReachabilityStatusApp != .notReachable{
        isNet=true
      }
      else{
        //showToast(ERROR_INTERNET)
        isNet = false
      }
      return isNet
    }
//    static func getSelectedViewControler()->UIViewController{
//      var vc=AppHelper.appDelegate.tabBarController?.selectedViewController
//      while let presentedViewController = vc?.presentedViewController {
//        vc = presentedViewController
//      }
//      if let vcd=vc as? UINavigationController{
//        vc=vcd.visibleViewController
//      }
//      return vc!
//    }
}

//MARK:UILABLE INXTENSION FOR TAPLABLE
extension UILabel {
    func gettingTapLable(owner:AnyObject) {
        self.numberOfLines=0
        self.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: owner, action: #selector(singleTap(gesture:)))
        self.addGestureRecognizer(tapGesture)
    }
    @objc func singleTap(gesture: UITapGestureRecognizer) {
        CLGLog.debug("single tap called")
    }
}

extension UITapGestureRecognizer {
    
    func didTapAttributedTextInLabel(label: UILabel, inRange targetRange: NSRange) -> Bool {
        // Create instances of NSLayoutManager, NSTextContainer and NSTextStorage
        let layoutManager = NSLayoutManager()
        let textContainer = NSTextContainer(size: CGSize.zero)
        let textStorage = NSTextStorage(attributedString: label.attributedText!)
        
        // Configure layoutManager and textStorage
        layoutManager.addTextContainer(textContainer)
        textStorage.addLayoutManager(layoutManager)
        
        // Configure textContainer
        textContainer.lineFragmentPadding = 0.0
        textContainer.lineBreakMode = label.lineBreakMode
        textContainer.maximumNumberOfLines = label.numberOfLines
        let labelSize = label.bounds.size
        textContainer.size = labelSize
        // Find the tapped character location and compare it to the specified range
        let locationOfTouchInLabel = self.location(in: label)
        let textBoundingBox = layoutManager.usedRect(for: textContainer)
        let textContainerOffset = CGPoint(x:((labelSize.width - textBoundingBox.size.width) * 0.5 - textBoundingBox.origin.x),y:((labelSize.height - textBoundingBox.size.height) * 0.5 - textBoundingBox.origin.y));
        let locationOfTouchInTextContainer = CGPoint(x:locationOfTouchInLabel.x - textContainerOffset.x,
                                                     y:locationOfTouchInLabel.y - textContainerOffset.y);
        let indexOfCharacter = layoutManager.characterIndex(for: locationOfTouchInTextContainer, in: textContainer, fractionOfDistanceBetweenInsertionPoints: nil)
        
        return NSLocationInRange(indexOfCharacter, targetRange)
    }
}

protocol Utilities {
}

extension NSObject:Utilities{
  enum ReachabilityStatus {
    case notReachable
    case reachableViaWWAN
    case reachableViaWiFi
  }
  
  class  var currentReachabilityStatusApp: ReachabilityStatus {
    
    var zeroAddress = sockaddr_in()
    zeroAddress.sin_len = UInt8(MemoryLayout<sockaddr_in>.size)
    zeroAddress.sin_family = sa_family_t(AF_INET)
    
    guard let defaultRouteReachability = withUnsafePointer(to: &zeroAddress, {
      $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {
        SCNetworkReachabilityCreateWithAddress(nil, $0)
      }
    }) else {
      return .notReachable
    }
    
    var flags: SCNetworkReachabilityFlags = []
    if !SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags) {
      return .notReachable
    }
    
    if flags.contains(.reachable) == false {
      // The target host is not reachable.
      return .notReachable
    }
    else if flags.contains(.isWWAN) == true {
      // WWAN connections are OK if the calling application is using the CFNetwork APIs.
      return .reachableViaWWAN
    }
    else if flags.contains(.connectionRequired) == false {
      // If the target host is reachable and no connection is required then we'll assume that you're on Wi-Fi...
      return .reachableViaWiFi
    }
    else if (flags.contains(.connectionOnDemand) == true || flags.contains(.connectionOnTraffic) == true) && flags.contains(.interventionRequired) == false {
      // The connection is on-demand (or on-traffic) if the calling application is using the CFSocketStream or higher APIs and no [user] intervention is needed
      return .reachableViaWiFi
    }
    else {
      return .notReachable
    }}}
