//
//  CartItemViewModel.swift
//  Storefront
//
//  Created by Shopify.
//  Copyright (c) 2017 Shopify Inc. All rights reserved.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
//

import Foundation
import MobileBuySDK

final class CartItemViewModel: ViewModel {
    static func == (lhs: CartItemViewModel, rhs: CartItemViewModel) -> Bool {
      return lhs.id==rhs.id
    }
    
    typealias ModelType = Storefront.ProductVariant
    let model:  ModelType
    let id:     String
    let title:  String
    let price:  Decimal
    let comparePrice:  Decimal?
    let currencyCode:  String
    let currentlyNotInStock:  Bool
    var sizeName:String
    var sizeValue:String
    let availableForSale:  Bool
      let productID:           String?
      let imgUrl:URL?
      let vendor:               String?
    var qtyAvailable:Int32?

      
      required init(from model: ModelType) {
        self.model  = model
        self.id     = model.id.rawValue
        self.title  = model.product.title
        self.price  = model.price.amount
        self.vendor           = model.product.vendor
        self.comparePrice  = model.compareAtPrice?.amount
        self.currencyCode  = model.price.currencyCode.rawValue
        Currency.currencyCode=self.currencyCode
        self.currentlyNotInStock=model.currentlyNotInStock
        self.availableForSale=model.availableForSale
          let opt = model.selectedOptions
        self.sizeName = opt.first?.name ?? ""
        self.sizeValue = opt.first?.value ?? ""
          self.qtyAvailable = model.quantityAvailable
        
        self.productID           = model.product.id.rawValue
          self.imgUrl           = model.image?.url

      }
    
      func isProductAvailbe()->Bool{
         return self.availableForSale//(!self.currentlyNotInStock ) && (self.availableForSale )
       }
    
       func priceStringProduct() -> NSAttributedString? {
         var mrp = self.comparePrice==nil ? "" : Currency.stringFrom(self.comparePrice ?? 0.0)
         let sellingPrice = Currency.stringFrom(price)
         var priceText = ""
         var offText = ""
         if let mrp1=self.comparePrice{
           let off = (((mrp1 - self.price)/mrp1)*100)
           if  let ss=Currency.percentageStringFrom(off){
             offText = " \(ss) OFF "
           }
          else{
            mrp=""
          }
         }
         let separator =  "  "
         if sellingPrice.count > 0 &&  mrp.count > 0 , sellingPrice != mrp {
           priceText = [sellingPrice,mrp,offText].joined(separator: separator)
         }
         else if sellingPrice.count > 0 {
           priceText = sellingPrice
           mrp=""

         }
         else if mrp.count > 0 {
           priceText = mrp
         }
         

         let attributedString = NSMutableAttributedString(string: priceText)
         let strikeoutRange = (priceText as NSString).range(of: mrp)
         let strikeCutRange = strikeoutRange

         let normalRange = (priceText as NSString).range(of: sellingPrice)
         let offRange = (priceText as NSString).range(of: offText)
        
           attributedString.addAttribute(.foregroundColor, value: UIColor(named: "lightGray")!, range: strikeoutRange)
           attributedString.addAttribute(.foregroundColor, value: UIColor(named: "CustomRed")!, range: normalRange)
           attributedString.addAttribute(.foregroundColor, value: UIColor(named: "CustomGreen")!, range: offRange)
           attributedString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 1, range: strikeCutRange)
           attributedString.addAttribute(NSAttributedString.Key.baselineOffset, value: 0, range: strikeCutRange)
         return attributedString
       }
    
    func savingPrice(){
       
    }
    
      func getTile(_ brandFontSize : CGFloat = 13, titleFontSize : CGFloat = 11) -> (NSAttributedString, String?) {
       let brandName = (self.vendor ?? "").uppercased()
          let productName = (self.title ).uppercased()
        let productDescription = ""//Blue slim fit denim jacket
        var completeTitle=""
        if brandFontSize==14{
          completeTitle = brandName + "\n" + productName + " " + productDescription
        }
        else{
          completeTitle = brandName + " " + productName + " " + productDescription
        }
        
        let attributedString = NSMutableAttributedString(string: completeTitle)
        let boldRange = (completeTitle as NSString).range(of: brandName)
        let normalRange = (completeTitle as NSString).range(of: productName)
        let descriptionRange = (completeTitle as NSString).range(of: productDescription)
        return (attributedString, completeTitle)
      }
    }

    extension Storefront.ProductVariant: ViewModeling {
      typealias ViewModelType = CartItemViewModel
    }
