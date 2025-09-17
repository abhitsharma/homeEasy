//
//  Extensions.swift
//  CoreDataTutorial
//
//  Created by James Rochabrun on 3/4/17.
//  Copyright © 2017 James Rochabrun. All rights reserved.
//

import Foundation
import UIKit

extension UIStoryboard {
    class func controller<T>(_ storyBoardType : StoryBoardType, type : T.Type ) -> T? {
      let storyboard = UIStoryboard(name: storyBoardType.rawValue , bundle: nil)
      return storyboard.instantiateViewController(withIdentifier: String(describing: type)) as? T
    }
}

extension UIImage {
    func createSelectionIndicator(color: UIColor, size: CGSize, lineHeight: CGFloat) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        color.setFill()
        
        if #available(iOS 13.0, *) {
            if (AppHelper.sceneDelegate.window?.safeAreaInsets.bottom ?? 0) > 0{
                UIRectFill(CGRect(origin: CGPoint(x: 0,y :size.height - lineHeight-12), size: CGSize(width: size.width, height: lineHeight)))
            }
            else{
                UIRectFill(CGRect(origin: CGPoint(x: 0,y :size.height - lineHeight), size: CGSize(width: size.width, height: lineHeight)))
            }
        } else {
            // Fallback on earlier versions
        }
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }
}

protocol Font {
    func of(size: CGFloat) -> UIFont
}

extension Font where Self: RawRepresentable, Self.RawValue == String {
    func of(size: CGFloat) -> UIFont {
            return UIFont.systemFont(ofSize: size)
    }
}

enum NiveauGrotesk: String, Font {
    case regular = "NiveauGroteskRegular"
    case Bold = "NiveauGroteskBold"
    case Medium = "NiveauGroteskMedium"
    case Light = "NiveauGroteskLight"
}


