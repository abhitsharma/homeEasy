//
//  String+Extention.swift
//  CLG
//
//  Created by Aravind Kumar on 01/09/21.
//

import Foundation
import CommonCrypto
import UIKit
import MobileBuySDK
extension String {
    func capitalizingFirstLetter() -> String {
      return prefix(1).uppercased() + self.lowercased().dropFirst()
    }

    mutating func capitalizeFirstLetter() {
      self = self.capitalizingFirstLetter()
    }
    
    func getGraphId() -> GraphQL.ID {
      return GraphQL.ID.init(rawValue: self)
    }
//    func convertToAttributedFromHTML1(_ font:UIFont=NiveauGrotesk.regular.of(size: 15),modeDark:Bool) -> NSAttributedString? {
//        var attributedText: NSMutableAttributedString?
//        let options: [NSAttributedString.DocumentReadingOptionKey: Any] = [.documentType: NSAttributedString.DocumentType.html, .characterEncoding: String.Encoding.utf8.rawValue]
//
//         var modifiedString = "<style>body{font-family: '\(font.fontName)'; font-size:\(font.pointSize)px; color:black; line-height:17pt; text-align:left; }</style>\(self)";
//        if modeDark{
//                   // User Interface is Dark
//            modifiedString = "<style>body{font-family: '\(font.fontName)'; font-size:\(font.pointSize)px; color:white; line-height:17pt; text-align:left; }</style>\(self)";
//               }
//        if let data = modifiedString.data(using: .unicode, allowLossyConversion: true), let attrStr = try? NSMutableAttributedString(data: data, options: options, documentAttributes: nil) {
//            attributedText = attrStr
//        }
//
//        return attributedText
//    }
    func convertToAttributedFromHTML() -> NSMutableAttributedString? {
      var attributedText: NSMutableAttributedString?
      let options: [NSMutableAttributedString.DocumentReadingOptionKey: Any] = [.documentType: NSMutableAttributedString.DocumentType.html, .characterEncoding: String.Encoding.utf8.rawValue,]
      if let data = data(using: .unicode, allowLossyConversion: true), let attrStr = try? NSMutableAttributedString(data: data, options: options, documentAttributes: nil) {
        attributedText = attrStr
      }
      if let attributedText=attributedText{
          let range = NSMakeRange(0, attributedText.length)
          attributedText.addAttribute(.font,
                                     value:UIFont(name: NiveauGrotesk.regular.rawValue, size: 14),
                                     range: range)
        
//          var  stringAttributes = [NSAttributedStringKey(rawValue: NSAttributedStringKey.font.rawValue):UIFont
//        stringAttributes[NSAttributedStringKey.backgroundColor] = UIColor.clear
//
//        attributedText.addAttributes(stringAttributes, range: range)
        
      }
      
      return attributedText
    }
}

extension String {
    var suffix:String{
        let dayOfMonth = Int(self) ?? 0
        switch dayOfMonth {
        case 1, 21, 31:
            return self+"st"
        case 2, 22:
            return self+"nd"
        case 3, 23:
            return self+"rd"
        default:
            return self+"th"
        }
    }
    var md5: String? {
        guard let data = self.data(using: .utf8) else { return nil }
        let hash = data.withUnsafeBytes { (bytes: UnsafePointer<Data>) -> [UInt8] in
            var hash: [UInt8] = [UInt8](repeating: 0, count: Int(CC_MD5_DIGEST_LENGTH))
            CC_MD5(bytes, CC_LONG(data.count), &hash)
            return hash
        }
        return hash.map { String(format: "%02x", $0) }.joined()
    }

    func heightWithConstrainedWidth(width: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(with: constraintRect, options: [.usesLineFragmentOrigin, .usesFontLeading], attributes: [NSAttributedString.Key.font: font], context: nil)
        return boundingBox.height
    }
}
extension String {
    func height(withConstrainedWidth width: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)
    
        return ceil(boundingBox.height)
    }

    func width(withConstrainedHeight height: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: .greatestFiniteMagnitude, height: height)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)

        return ceil(boundingBox.width)
    }
    
}
extension String {
//    func convertToAttributedFromHTML(_ font:UIFont=Roboto.Regular.of(size: 13)) -> NSMutableAttributedString? {
//        var attributedText: NSMutableAttributedString?
//      let options: [NSMutableAttributedString.DocumentReadingOptionKey: Any] = [.documentType: NSMutableAttributedString.DocumentType.html, .characterEncoding: String.Encoding.utf8.rawValue,]
//        if let data = data(using: .unicode, allowLossyConversion: true), let attrStr = try? NSMutableAttributedString(data: data, options: options, documentAttributes: nil) {
//            attributedText = attrStr
//        }
//      if let attributedText=attributedText{
//        var  stringAttributes = [NSAttributedString.Key(rawValue: NSAttributedString.Key.font.rawValue):font,NSAttributedString.Key(rawValue: NSAttributedString.Key.foregroundColor.rawValue):UIColor(named: "33333&F0F0F0")!]
//        stringAttributes[NSAttributedString.Key.backgroundColor] = UIColor.clear
//        let range = NSMakeRange(0, attributedText.length)
//                 attributedText.addAttributes(stringAttributes, range: range)
//          
//      }
//        return attributedText
//    }
}
extension String {

    func fromBase64() -> String? {
        guard let data = Data(base64Encoded: self) else {
            return nil
        }

        return String(data: data, encoding: .utf8)
    }

    func toBase64() -> String {
        return Data(self.utf8).base64EncodedString()
    }
}
extension String {
    func addLineOnText() -> NSMutableAttributedString {
        let attributeString: NSMutableAttributedString = NSMutableAttributedString(string: self)
            attributeString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 2, range: NSRange(location: 0, length: attributeString.length))
        return attributeString
    }
    func isValidEmail() -> Bool {
        let regex = try? NSRegularExpression(pattern: "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}", options: .caseInsensitive)
        return regex?.firstMatch(in: self, options: [], range: NSMakeRange(0, self.count)) != nil
    }
    func isValidPassword()-> Bool
    {
        let regexPassword = try? NSRegularExpression(pattern: "(?=^.{6,20}$)", options: [])
        return regexPassword?.firstMatch(in: self, options: [], range: NSMakeRange(0, self.count)) != nil
    }
    
    var containsWhitespace : Bool {
      return(self.rangeOfCharacter(from: .whitespacesAndNewlines) != nil)
    }
    
    var containsSpecialCharacter: Bool {
      let regex = ".*[^A-Za-z ].*"
      let testString = NSPredicate(format:"SELF MATCHES %@", regex)
      return testString.evaluate(with: self)
    }
    func actualString() -> String {
        return self.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
    }
    func trunc(length: Int, trailing: String = "…") -> String {
        return (self.count > length) ? self.prefix(length) + trailing : self
    }
    func isValidMobile() -> (Bool,String?) {
        var isValid = true
        var message : String?
            let trimmedText = self.actualString()
            if (trimmedText.count != mobilelength) {
                isValid = false
                message = invalidMobile
            }
            if isValid && trimmedText.first == "0" {
                isValid = false
                message = invalidMobile
            }
            if isValid && trimmedText.first == "1" {
                isValid = false
                message = invalidMobile
            }
        return (isValid,message)
    }
    func isValidateAddress()-> Bool
    {
      let regex = ".*[^A-Z0-9a-z- ,._#/].*"
      let testString = NSPredicate(format:"SELF MATCHES %@", regex)
      return testString.evaluate(with: self)
    }
}
extension String {

    func widthOfString(usingFont font: UIFont) -> CGFloat {
        let fontAttributes = [NSAttributedString.Key.font: font]
        let size = self.size(withAttributes: fontAttributes)
        return size.width
    }

    func heightOfString(usingFont font: UIFont) -> CGFloat {
        let fontAttributes = [NSAttributedString.Key.font: font]
        let size = self.size(withAttributes: fontAttributes)
        return size.height
    }

    func sizeOfString(usingFont font: UIFont) -> CGSize {
        let fontAttributes = [NSAttributedString.Key.font: font]
        return self.size(withAttributes: fontAttributes)
    }
}


extension UIImage {
    func imageToBase64() -> String? {
        return self.jpegData(compressionQuality: 1)?.base64EncodedString()
    }

}
