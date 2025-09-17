//
//  LineItemViewModel.swift
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

final class LineItemViewModel: ViewModel {
    
    typealias ModelType = Storefront.CheckoutLineItemEdge
    
    let model:    ModelType
    let cursor:   String
    
    let variantID:           String?
    let quantity:            Int
    let individualPrice:     Decimal
    let totalPrice:          Decimal
    let discountAllocations: [DiscountAllocationViewModel]
    let imgUrl:URL?
  let title:               String?
  let vendor:               String?
 var sizeName:String=""
  var sizeValue:String=""

    // ----------------------------------
    //  MARK: - Init -
    //
    required init(from model: ModelType) {
        self.model               = model
        self.cursor              = model.cursor
        
        self.variantID           = model.node.variant!.id.rawValue
       // self.title               = model.node.title
        self.quantity            = Int(model.node.quantity)
        self.individualPrice     = model.node.variant!.price.amount
        self.totalPrice          = self.individualPrice * Decimal(self.quantity)
        self.discountAllocations = model.node.discountAllocations.viewModels
        self.imgUrl           = model.node.variant?.image?.url
        self.title               = model.node.variant?.product.title
        self.vendor               = model.node.variant?.product.vendor
    

//        if  let opt=model.node.variant?.selectedOptions.viewModels{
//              self.sizeName=opt.first?.name ?? ""
//                     self.sizeValue=opt.first?.value ?? ""
//      }
    }
  func getTile(_ brandFontSize : CGFloat = 13, titleFontSize : CGFloat = 11) -> (NSAttributedString, String?) {
     let brandName = (self.vendor ?? "").uppercased()
     let productName = (self.title ?? "").uppercased()
      let productDescription = ""//Blue slim fit denim jacket
      var completeTitle=""
      if brandFontSize==14{
        completeTitle = brandName + "\n" + productName + " " + productDescription
      }
      else{
        completeTitle = brandName + " " + productName + " " + productDescription
      }
      
//      let brandFont = UIFont.setAppFont(appFont: .Bold(fontSize: brandFontSize))
//      let productTitleFont = UIFont.setAppFont(appFont: .SemiBold(fontSize: titleFontSize))
//      let productDescriptionFont = UIFont.setAppFont(appFont: .Regular(fontSize: titleFontSize))
      
      let attributedString = NSMutableAttributedString(string: completeTitle)
      let boldRange = (completeTitle as NSString).range(of: brandName)
      let normalRange = (completeTitle as NSString).range(of: productName)
      let descriptionRange = (completeTitle as NSString).range(of: productDescription)
      
//      attributedString.setAttributes([NSAttributedStringKey.font : brandFont, NSAttributedStringKey.foregroundColor : UIColor.kTitleColor], range: boldRange)
//      attributedString.setAttributes([NSAttributedStringKey.font : productTitleFont, NSAttributedStringKey.foregroundColor : UIColor.kSubTitleColor], range: normalRange)
//      attributedString.setAttributes([NSAttributedStringKey.font : productDescriptionFont, NSAttributedStringKey.foregroundColor : UIColor.kSubTitleColor], range: descriptionRange)
      
          return (attributedString, completeTitle)
    }
}

extension Storefront.CheckoutLineItemEdge: ViewModeling {
    typealias ViewModelType = LineItemViewModel
}
final class OrderLineItemViewModel: ViewModel {
    
    typealias ModelType = Storefront.OrderLineItemEdge
    
    let model:    ModelType
    let cursor:   String
    
    let variantID:           String?
    let title:               String?
    let vendor:               String?
    let quantity:            Int
    let individualPrice:     Decimal?
    let totalPrice:          Decimal?
    var sizeName:String=""
    var sizeValue:String=""
    let imgUrl:URL?
    let productID:           String?
    // ----------------------------------
    //  MARK: - Init -
    //
    required init(from model: ModelType) {
      self.model               = model
      self.cursor              = model.cursor
      self.variantID           = model.node.variant?.id.rawValue
      self.title               = model.node.variant?.product.title
      self.vendor               = model.node.variant?.product.vendor
        self.productID           = model.node.variant?.product.id.rawValue ?? model.node.variant?.id.rawValue
        self.quantity            = Int(model.node.quantity)
        self.individualPrice     = model.node.variant?.price.amount
        self.totalPrice          = (self.individualPrice ?? 0) * Decimal(self.quantity)
        self.imgUrl           = model.node.variant?.image?.url

//      if  let opt=model.node.variant?.selectedOptions.viewModels{
//              self.sizeName=opt.first?.name ?? ""
//                     self.sizeValue=opt.first?.value ?? ""
//      }
      
      
  }
  func getTile(_ brandFontSize : CGFloat = 13, titleFontSize : CGFloat = 11) -> (NSAttributedString, String?) {
    let brandName = (self.vendor ?? "").uppercased()
    let productName = (self.title ?? "").uppercased()
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

extension Storefront.OrderLineItemEdge: ViewModeling {
    typealias ViewModelType = OrderLineItemViewModel
}
