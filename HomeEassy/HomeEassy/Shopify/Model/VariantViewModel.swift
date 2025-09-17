//
//  VariantViewModel.swift
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

final class VariantViewModel: ViewModel {
    
    typealias ModelType = Storefront.ProductVariantEdge
    
    let model:  ModelType
    let cursor: String
    let comparePrice:  Decimal?
    let id:     String
    let title:  String
    let price:  Decimal
    let image:   URL?
    let currencyCode:  String
    let quantityAvailable:Int32
    let availableForSale:Bool
    let selectedOption:[SelectedOptionViewModel]
    // ----------------------------------
    //  MARK: - Init -
    //
    required init(from model: ModelType) {
        self.model  = model
        self.cursor = model.cursor
        self.image  = model.node.image!.url
        self.id     = model.node.id.rawValue
        self.title  = model.node.title
        self.price  = model.node.price.amount
        self.comparePrice  = model.node.compareAtPrice?.amount
        self.currencyCode  = model.node.price.currencyCode.rawValue
        self.quantityAvailable = model.node.quantityAvailable!
        self.availableForSale = model.node.availableForSale
        self.selectedOption = model.node.selectedOptions.viewModels
    }
    
    func priceStringProduct(_ isShowLeftItem:Bool=false) -> NSAttributedString? {
      Currency.currencyCode=self.currencyCode
      var mrp = self.comparePrice==nil ? "" : Currency.stringFrom(self.comparePrice ?? 0.0)
      let sellingPrice = Currency.stringFrom(price)
      var priceText = ""
      var offText = ""
      if let chkPrice=self.comparePrice{
        let off = (((chkPrice - self.price)/chkPrice)*100)
        if  let ss=Currency.percentageStringFrom(off){
          offText = " \(ss) OFF "
        }
        else{
          mrp=""
        }
      }
      let separator =  " "
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
         attributedString.addAttribute(.font, value: UIFont.systemFont(ofSize: 15), range: strikeoutRange)
          attributedString.addAttribute(.foregroundColor, value: UIColor(named: "CustomRed")!, range: normalRange)
        
          attributedString.addAttribute(.foregroundColor, value: UIColor(named: "CustomGreen")!, range: offRange)
          attributedString.addAttribute(.font, value: UIFont.systemFont(ofSize: 15), range: offRange)
          attributedString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 1, range: strikeCutRange)
          attributedString.addAttribute(NSAttributedString.Key.baselineOffset, value: 0, range: strikeCutRange)
      
      return attributedString
      
    }
    
    func priceSale() -> Bool {
      Currency.currencyCode=self.currencyCode
      var mrp = self.comparePrice==nil ? "" : Currency.stringFrom(self.comparePrice ?? 0.0)
      let sellingPrice = Currency.stringFrom(price)
      var priceText = ""
        //let salePrice  = (Int(Currency.stringFrom(self.comparePrice ?? 0.0)) ?? 0) - (Int(Currency.stringFrom(price)) ?? 0)
       
        if let chkPrice=self.comparePrice{
          let off = ((chkPrice - self.price)/chkPrice)
            if off == 0{
                return false
            }
            else {
                return true
            }
        }
        return false
    }
    
    func priceStringProductSmall(_ isShowLeftItem:Bool=false) -> NSAttributedString? {
      Currency.currencyCode=self.currencyCode
      var mrp = self.comparePrice==nil ? "" : Currency.stringFrom(self.comparePrice ?? 0.0)
      let sellingPrice = Currency.stringFrom(price)
      var priceText = ""
      var offText = ""
      if let chkPrice=self.comparePrice{
        let off = (((chkPrice - self.price)/chkPrice)*100)
        if  let ss=Currency.percentageStringFrom(off){
          offText = "\n\(ss) OFF "
        }
        else{
          mrp=""
        }
      }
      let separator =  " "
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
         attributedString.addAttribute(.font, value: UIFont.systemFont(ofSize: 12), range: strikeoutRange)
          attributedString.addAttribute(.foregroundColor, value: UIColor(named: "CustomRed")!, range: normalRange)
          attributedString.addAttribute(.foregroundColor, value: UIColor(named: "CustomGreen")!, range: offRange)
          attributedString.addAttribute(.font, value: UIFont.systemFont(ofSize: 12), range: offRange)
          attributedString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 1, range: strikeCutRange)
          attributedString.addAttribute(NSAttributedString.Key.baselineOffset, value: 0, range: strikeCutRange)
      return attributedString
      
    }
    
    func priceStringProductBig(_ isShowLeftItem:Bool=false) -> NSAttributedString? {
      Currency.currencyCode=self.currencyCode
      var mrp = self.comparePrice==nil ? "" : Currency.stringFrom(self.comparePrice ?? 0.0)
      let sellingPrice = Currency.stringFrom(price)
      var priceText = ""
      var offText = ""
      if let chkPrice=self.comparePrice{
        let off = (((chkPrice - self.price)/chkPrice)*100)
        if  let ss=Currency.percentageStringFrom(off){
          offText = " \(ss) OFF "
        }
        else{
          mrp=""
        }
      }
      let separator =  " "
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
        attributedString.addAttribute(.font, value: UIFont(name: NiveauGrotesk.regular.rawValue, size: 18)!, range: strikeoutRange)
          attributedString.addAttribute(.foregroundColor, value: UIColor(named: "CustomRed")!, range: normalRange)
        //UIFont.systemFont(ofSize: 28)
          attributedString.addAttribute(.foregroundColor, value: UIColor(named: "CustomGreen")!, range: offRange)
          attributedString.addAttribute(.font, value: UIFont(name: NiveauGrotesk.regular.rawValue, size: 18)!, range: offRange)
          attributedString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 1, range: strikeCutRange)
          attributedString.addAttribute(NSAttributedString.Key.baselineOffset, value: 0, range: strikeCutRange)
      
      return attributedString
      
    }
}

extension Storefront.ProductVariantEdge: ViewModeling {
    typealias ViewModelType = VariantViewModel
}

final class SelectedOptionViewModel: ViewModel {
  
  typealias ModelType = Storefront.SelectedOption
  
  
  let model:  ModelType
  let value:     String
  let name:  String
  
  
  // ----------------------------------
  //  MARK: - Init -
  //
  required init(from model: ModelType) {
    self.model  = model
    self.value = model.value
    self.name=model.name
  }
}

extension Storefront.SelectedOption: ViewModeling {
  typealias ViewModelType = SelectedOptionViewModel
}

