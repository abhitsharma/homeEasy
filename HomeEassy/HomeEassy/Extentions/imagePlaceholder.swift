//
//  imagePlaceholder.swift
//  HomeEassy
//
//  Created by Macbook on 11/08/23.
//

import Foundation

import Foundation
import UIKit

let imageCache = NSCache<NSString, UIImage>()

extension UIImageView {

    func loadImageUsingCacheWithURLString(_ URLString: String, placeHolder: UIImage?) {
        self.image = nil
        if let cachedImage = imageCache.object(forKey: NSString(string: URLString)) {
            self.image = cachedImage
            return
        }
        
        if let url = URL(string: URLString) {
            URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) in
                
                //print("RESPONSE FROM API: \(response)")
                if error != nil {
                    print("ERROR LOADING IMAGES FROM URL: \(error)")
                    DispatchQueue.main.async {
                        self.image = placeHolder
                    }
                    return
                }
                DispatchQueue.main.async {
                    if let data = data {
                        if let downloadedImage = UIImage(data: data) {
                            imageCache.setObject(downloadedImage, forKey: NSString(string: URLString))
                            self.image = downloadedImage
                        }
                    }
                }
            }).resume()
        }
    }
    func placeholderImage(_ name: String, size: CGSize) {
            self.image = nil
            if let cachedImage = imageCache.object(forKey: NSString(string: name)) {
                self.image=cachedImage
                return
            }
            let img=getPlaceHolderImage(size:size,text1:getInitials(teamName: name))
            imageCache.setObject(img, forKey: NSString(string: name))
            
            self.image=img
        }
    
    func getInitials(teamName:String)-> String {
        if (teamName.isEmpty) {
            return ""
        }
        if (!teamName.contains(" ")) {
            
            let startIndex = teamName.index(teamName.startIndex, offsetBy: 0)
            do {
                if(teamName.count > 3){
                    let endIndex = teamName.index(startIndex, offsetBy: 3)
                    return teamName[startIndex..<endIndex].uppercased()
                }else{
                    return teamName.uppercased()
                }
            }
            catch {
                return teamName.uppercased()
            }
            
        }
        
        let split = teamName.trimmingCharacters(in: .whitespacesAndNewlines).split(separator: " ")
        let firstName = split[0].trimmingCharacters(in: .whitespacesAndNewlines)
        if (split.count > 1) {
            let lastName = split[1].trimmingCharacters(in: .whitespacesAndNewlines)
            if (!lastName.isEmpty) {
                let startIndex = firstName.index(teamName.startIndex, offsetBy: 0)
                let endIndex = firstName.index(startIndex, offsetBy: 1)
                
                let lstartIndex = lastName.index(teamName.startIndex, offsetBy: 0)
                let lendIndex = lastName.index(startIndex, offsetBy: 1)
                return "\(firstName[startIndex..<endIndex].uppercased()) \(lastName[lstartIndex..<lendIndex].uppercased())"
            }
        }
        
        let startIndex = firstName.index(teamName.startIndex, offsetBy: 0)
        let endIndex = firstName.index(startIndex, offsetBy: 1)
        return "\(firstName[startIndex..<endIndex].uppercased())"
    }
        func getPlaceHolderImage(size:CGSize,text1:String)->UIImage  {
            
//            var colorName = "brown_3e2723"
//            let text = text1.lowercased()
//            if (text.starts(with: "a") || text.starts(with:"b") || text.starts(with:"c") || text.starts(with:"d") || text.starts(with:"e")) {
//                colorName = "blue_3498db"
//
//            } else if (text.starts(with:"f") || text.starts(with:"g") || text.starts(with:"h") || text.starts(with:"i") || text.starts(with:"j")) {
//                colorName =  "green_3A932F"
//            } else if (text.starts(with:"k") || text.starts(with:"l") || text.starts(with:"m") || text.starts(with:"n") || text.starts(with:"o")) {
//                colorName = "red_D75857"
//            } else if (text.starts(with:"p") || text.starts(with:"q") || text.starts(with:"r") || text.starts(with:"s") || text.starts(with:"t")) {
//                colorName = "orange_f57f17"
//            }
          
            
            return imageWithText(drawText: text1, UIColor(named: "CustomBlack")!, size: size)
            
        }
        func imageWithText(drawText text: String,_ color: UIColor, size: CGSize) -> UIImage {
            
            let frame = CGRect(x: 0, y: 0, width: size.width, height: size.height)
            let nameLabel = UILabel(frame: frame)
            nameLabel.textAlignment = .center
            nameLabel.backgroundColor = color
            nameLabel.textColor = .white
            nameLabel.font = UIFont.boldSystemFont(ofSize: 28)
            nameLabel.text = text
            UIGraphicsBeginImageContext(frame.size)
            if let currentContext = UIGraphicsGetCurrentContext() {
                nameLabel.layer.render(in: currentContext)
                let nameImage = UIGraphicsGetImageFromCurrentImageContext()
                return nameImage!
            }
            return UIImage()
        }
}


    

//protocol Font {
//    func of(size: CGFloat) -> UIFont
//}

//extension Font where Self: RawRepresentable, Self.RawValue == String {
//    func of(size: CGFloat) -> UIFont {
//       if let f = UIFont(name: rawValue, size: size){
//            return f
//        }
//        else{
//            return UIFont.systemFont(ofSize: size)
//        }
//    }
//}



//enum NiveauGrotesk: String, Font {
//    case regular = "NiveauGroteskRegular"
//    case Bold = "NiveauGroteskBold"
//    case Medium = "NiveauGroteskMedium"
//    case Light = "NiveauGroteskLight"
//}

//extension UILabel {
//    func updateTextToAtribute()  {
//        if let text = self.text {
//            let arr = text.components(separatedBy: ":")
//            let firstString=arr.first ?? "" + ":"
//            let sectondStr = arr.last ?? ""
//            let mutStr=NSMutableAttributedString.init(string: text)
//            mutStr.addAttributes([NSAttributedString.Key.font :Roboto.Regular.of(size: 14)], range: (text as NSString).range(of: firstString))
//            mutStr.addAttributes([NSAttributedString.Key.font :Roboto.Medium.of(size: 14)], range: (text as NSString).range(of: sectondStr))
//            mutStr.addAttributes([NSAttributedString.Key.foregroundColor :UIColor(named: "blue_3D4375")!], range:NSRange(location: 0, length: text.count) )
//            mutStr.addAttributes([NSAttributedString.Key.foregroundColor :UIColor(named: "33333&F0F0F0")!], range:(text as NSString).range(of: sectondStr))
//            self.text = nil
//            self.attributedText=mutStr
//        }
//    }
//}
