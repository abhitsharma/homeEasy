
//
//  Constants.swift
//  KoovsOnlineFashion
//
//  Created by Koovs on 16/08/16.
//  Copyright © 2016 Koovs. All rights reserved.
//

import Foundation
import UIKit

let kRS = "₹ "
let SCREEN_WIDTH = (UIScreen.main.bounds.size.width)
let SCREEN_HEIGHT = (UIScreen.main.bounds.size.height)
let kBagtotal = "BAG TOTAL"
let kTotalPay = "TOTAL PAYABLE"
let kShipingCharg = "SHIPPING CHARGES"
struct CacheKey {
    static let KEY_SUBMITEDPOLL = "mySubmitPoll"
}

enum StoryBoardType : String {
    case home = "Home" , main = "Main",live = "Account" , cart = "Cart" ,wishList = "WishList", category = "Category"
}

struct AppUserDefault {
    static let USER_ID = "user_id"
    static let USER_NAME = "user_name"
    static let USER_FIRSTNAME = "user_firstname"
    static let USER_LASTNAME = "user_lastname"
    static let USER_EMAIL = "user_email"
    static let USER_PHONE = "user_phone"
}

struct AppImage {
    static let BackButtonImage = "backIcon"
}
struct AppColor {
    static let screenBackGroundColor = UIColor(named: "BG")!
    static let appDarkColor = UIColor(named: "black")!
    static let appLightColor = UIColor(named: "lightGray")!
    static let appNormalColor = UIColor(named: "darkGray")!
    static let appUniqueColor = UIColor(named: "red")!
    static let appHeaderTextColor = UIColor(named: "black")!
    static let appHeaderBgColor = UIColor(named: "CustomGrey")!
    static let appButtonBgColor = UIColor(named: "black")!
    static let appButtonTitleColor = UIColor(named: "white")!
    static let appButtonSelctedColor = UIColor(named: "lightGray")!
    static let appCellColor = UIColor(named: "white")!
}

extension UIColor {
    public class var blackApp: UIColor { .blue }
}
