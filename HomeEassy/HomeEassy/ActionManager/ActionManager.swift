//
//  ActionManager.swift
//  KoovsOnlineFashion
//
//  Created by Koovs on 17/08/16.
//  Copyright © 2016 Koovs. All rights reserved.
//

import Foundation
import UIKit
import MediaPlayer
import AVKit

class ProductRequestParams : NSObject {
  var requestUrl : String?
  var product : ProductObj?
  var anchorString : String?
  var productId : String?
  var skuId : String?
  var isFromBag = false
  var prevScreenName :String?
  var isBuyAgain = false
  
}
enum ProductEditType : String {
  case exchange = "exchange",
  wishlist = "wishlist",
  cart = "cart",
  PDP = "pdp",
  ShopTheLook = "ShopTheLook",
  unknown = "unknown"
}

enum RedirectionType : String {
  case InitiateSearch,

  SearchResult = "SearchResult" ,
  PaymentOption = "PaymentOption" ,
  ProductListing = "PRODUCT_LISTING",
  PRODUCT_LISTING_SEARCH="PRODUCT_LISTING_SEARCH",
  ProductDetail = "PRODUCT_DISPLAY",
  WebView = "WEB_VIEW",
  CategoryListing = "CATEGORY_LISTING",
  Share = "SHARE",
  InternalVideo = "INATERNAL_VIDEO",
  Video = "VIDEO",
  Login = "LOGIN",
  LoginRegister = "LOGINREGISTER",
  Recent = "RECENT",
  Address = "ADDRESS",
  SetDefaultAddress = "SetDefaultAddress",
  ChangePickupAddress = "ChangePickupAddress",
  ChangeExchangeDeliveryAddress = "ChangeExchangeDeliveryAddress",
  NewAddress = "NEWADDRESS",
  NewReversePickUpAddress = "NewReversePickUpAddress",
  EditAddress = "EDITADDRESS",
  EditReversePickAddress = "EDITREVERSEPICKUPADDRESS",
  Register = "REGISTER",
  Wishlist = "WISHLIST",
  MyOrders = "MYORDERS",
  EditProfile = "EDITPROFILE",
  FutureBalance = "FutureBalance",
  Coupons = "COUPONS",
  MenHome = "MENHOME",
  Home = "HOME",
  WomenHome = "WOMENHOME",
  ResetPassword = "RESETPASSWORD",
  WishlistUpdateAction = "WISHLISTUPDATEACTION",
  MyAccount = "ACCOUNT_ACTION",
  Bag = "BAG_ACTION",
  EditProduct = "EDIT_PRODUCT",
  PlayVideo = "PLAY_VIDEO" ,
  Brands = "BRANDS",
  ContinueShopping = "CONTINUE_SHOPPING",
  SelectCoupon = "SELECT_COUPONS",
  ProceedToCheckout = "PROCEEDTOCHECKOUT",
  CustomWidgetPage = "CUSTOM_HOME" ,
  Recommendation = "RECOMMENDATION",
  NoInternetConnection = "NOINTERNETCONNECTION",
  TrackDtl = "TRACK_DETAILS" ,
  OrderDtl = "ORDER_DETAILS" ,
  PrivacyPlcy = "Privacy Policy" ,
  FAQ = "FAQ" ,
  signUpProfile = "signUpProfile",
  Offers = "Offers",
  Payment="Payment",
  TermAndCondition="TermAndCondition",
  ThankuPage="ThankuPage",
  SaveCardList="SaveCardList",
  ReturnList="returnList",
  ReturnSumary="returnSumary",
  ExchangeSumary="exchangeSumary",
  ReturnExchangeSummary="returnExchangeSummary",
  AddCard="addCard",
  GiftCard="GiftCard",
  AddGiftCard="AddGiftCard",
  Transaction="Transaction",
  VoiceSearch="VoiceSearch",
  Referral="Referral",
  CATEGORYHOME = "CATEGORY_HOME",
 INAPPMESSAGE = "INAPPMESSAGE",
  QRcodeScaner="QRcodeScaner",

  None
}

enum PresentationType {
  case push, present, subView
}

enum AccountPageType {
  case login, register
}


class EditProductActionParams : NSObject {
  var skuid : String?
  var productId : String?
  //var pdpModel:PDPViewModel?
  var editType : ProductEditType?
  var qty = 1
  var isSelected = false
  var product : ProductObj?
  
}

class NoInternetConnectionActionParams : NSObject {
  //var completionHandler : ((Any?) -> Void)?
  var infoObject : Any?
}

class LoginRegisterActionParams : NSObject {
  var object : Any?
  //var pageType : LoginRegisterSection?
}

class WebViewActionParams : NSObject {
  var url : String?
  var title : String?
}

class ResetPasswordActionParams : NSObject {
  var deeplinkURL : String?
}

class CustomWidgetPageActionParams : NSObject {
  var link : String?
  var title : String?
  var identifier : String?
}

class Action : NSObject {
  var redirectionType : RedirectionType = .None
  var infoObject : Any?
  var presentationType = PresentationType.push
  var completionHandler : ((AnyObject?) -> ())?
  var  searchType:String?
  var  title:String?
  var  isVoiceSearch=false
}

class ActionManager : NSObject {
  static var viewC : UIViewController?
  class func performAction(_ action : Action, source : AnyObject?) {
    switch action.redirectionType {

      case .WebView:
           performWebAction(action,source: source)
    
    case .NoInternetConnection:
      performNoInternetConnectionAction(action, source: source)
    
    default:
      
      break
    }}

  fileprivate class func performShareAction(_ action : Action, source : AnyObject?) {
    if let activityItems = action.infoObject as? [AnyObject] {
      let activityVC = UIActivityViewController(activityItems: activityItems, applicationActivities: nil)
      activityVC.popoverPresentationController?.sourceView = (source as? UIViewController)?.view
      (source as? UIViewController)?.present(activityVC, animated: true, completion: nil)
    }
  }
  
  
  fileprivate class func performWebAction(_ action : Action, source : AnyObject?) {
    if let webViewVC = StoryBoardHelper.controller(.cart , type: WebViewVC.self) {
      webViewVC.urlString = (action.infoObject as? WebViewActionParams)?.url
      webViewVC.navigationTitle = (action.infoObject as? WebViewActionParams)?.title
      self.show(webViewVC, action: action, source: source as? UIViewController)
    }
  }
  
   fileprivate class func performViewAccountAction(_ action : Action, source : AnyObject?) {

      
              if let tabBarController = (source as? UIViewController)?.tabBarController {
                  tabBarController.selectedIndex = 3
                  let navController = tabBarController.selectedViewController as? UINavigationController
                  navController?.popToRootViewController(animated: true)
              }
    }
    

  
  
  fileprivate class func performNoInternetConnectionAction(_ action : Action, source : AnyObject?) {
    //  if (source as? BaseVC)?.noInternetVC == nil {
          let handler = source as? NoInternetHandler
          if let noInternetVC = StoryBoardHelper.controller(.main , type: NoInternetVC.self) {
              noInternetVC.delegate = handler
              noInternetVC.infoObject = (action.infoObject as? NoInternetConnectionActionParams)?.infoObject
              if let viewController = source as? UIViewController {
                  noInternetVC.view.frame = viewController.view.bounds
                  viewController.view.addSubview(noInternetVC.view)
                  (source as? BaseVC)?.noInternetVC = noInternetVC
              }
        //  }
      }
  }
    

  fileprivate class func show(_ controller : UIViewController?, action : Action?, source : UIViewController?) {
    if controller != nil && source != nil {
      if let navigationController = (source as? UINavigationController) ?? source?.navigationController {
        if action == nil || action?.presentationType == .push {
          navigationController.pushViewController(controller!, animated:true)
        }
        else if action?.presentationType == .present {
          let presentableNavVC = KVSNavigationController(rootViewController: controller!)
          presentableNavVC.modalPresentationStyle = .fullScreen
          navigationController.present(presentableNavVC, animated: true, completion: nil)
        }
//        else if action?.presentationType == .subView {
//          if let tabBar = (UIApplication.shared.delegate as? AppDelegate)?.tabBarController {
//            controller?.view.frame = tabBar.view.bounds
//            if let controller = controller {
//              tabBar.view.addSubview(controller.view)
//            }}}
          
      }
      else if action?.presentationType == .present {
        DispatchQueue.main.async {
          if let controller = controller {
            let presentableNavVC = KVSNavigationController(rootViewController: controller)
            presentableNavVC.modalPresentationStyle = .fullScreen
            source?.present(presentableNavVC, animated: true, completion: nil)
          }
        }
      }
//      else if let nav = (UIApplication.shared.delegate as? AppDelegate)?.tabBarController?.selectedViewController as? UINavigationController {
//        if action == nil || action?.presentationType == .push {
//          nav.pushViewController(controller!, animated:true)
//        }}
        
    }}}


extension Array {
  mutating func removeObject<U: Equatable>(_ object: U) -> Bool {
    for (idx, objectToCompare) in self.enumerated() {  //in old swift use enumerate(self)
      if let to = objectToCompare as? U {
        if object == to {
          self.remove(at: idx)
          return true
        }}}
    return false
  }}
