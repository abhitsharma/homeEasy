//
//  ProductViewModel.swift
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

final class ProductViewModel: ViewModel {
    typealias ModelType = Storefront.ProductEdge
    let model:    ModelType
    let cursor:   String
    
    let id:       String
    let productDtl:ProductObj?
    // ----------------------------------
    //  MARK: - Init -
    //
    required init(from model: ModelType) {
        self.model    = model
        self.cursor   = model.cursor
    
        let variants = model.node.variants.edges.viewModels.sorted {
            $0.price < $1.price
        }
        let lowestPrice = variants.first?.price
        
        self.id       = model.node.id.rawValue
        self.productDtl=model.node.viewModel
    }
}

extension Storefront.ProductEdge: ViewModeling {
    typealias ViewModelType = ProductViewModel
}

enum ECommerceProductLevel {
    case impression,  detail
}
//******

final class ProductObj: ViewModel,Equatable {
  static func == (lhs: ProductObj, rhs: ProductObj) -> Bool {
    return lhs.id==rhs.id
  }


  typealias ModelType = Storefront.Product

  let model:    ModelType

  let id:       String
  let title:    String
  let vendor:    String
  let summary:  String
  let handle:    String
  let productType:    String
  let availableForSale:Bool
  var isProductOOS:Bool=false
  var variant: VariantViewModel?
  let option:[OptionViewModel]
  let images:   PageableArray<ImageViewModel>
  let variants: PageableArray<VariantViewModel>
  let price:    String
  // ----------------------------------
  //  MARK: - Init -
  //
  required init(from model: ModelType) {
    self.model    = model
    self.id       = model.id.rawValue
    self.vendor       = model.vendor
    self.handle       = model.handle
    self.title    = model.title
    self.availableForSale = model.availableForSale
    self.summary  = model.descriptionHtml
    self.productType    = model.productType
    let variants = model.variants.edges.viewModels.sorted {
      $0.price < $1.price
    }
    self.variant = variants.first
    let lowestPrice = variants.first?.price
      self.price    = lowestPrice == nil ? "No price" : Currency.stringFrom(lowestPrice!)
    //self.option=model.options.viewModels
    self.isProductOOS = !self.availableForSale //!(variants.first?.isProductAvailbe() ?? false)

    self.images   = PageableArray(
      with:     model.images.edges,
      pageInfo: model.images.pageInfo
    )
    self.variants = PageableArray(
      with:     model.variants.edges,
      pageInfo: model.variants.pageInfo
    )
    self.option=model.options.viewModels
  }
    
  func customDimensions(_ isSoldOut : Bool = false,isFromScrollImage: Bool = false ,currentImageindex : Int =  0, percentageSizeAvail:Int = 0) -> [String: Any] {
      let dimensions = [String: Any]()
    var offText = ""
    if let mrp=self.variant?.comparePrice{
      let off = (((mrp - (self.variant?.price ?? 0.000))/mrp)*100)
      let ss=Currency.percentageStringFrom(off)
      offText = ss ?? ""
    }
    return  dimensions
  }
  
}

extension Storefront.Product: ViewModeling {
  typealias ViewModelType = ProductObj
}


final class ProductFil: ViewModel {
    typealias ModelType = Storefront.ProductConnection

    let model: ModelType
    let filters: [ProductFilter] // Assuming you have a model for ProductFilter

    // ----------------------------------
    //  MARK: - Init -
    //
    required init(from model: ModelType) {
        self.model = model
        self.filters = model.filters.map { filterModel in
            // Assuming you have a method to convert the JSON structure to your model
            return ProductFilter(from: filterModel)
        }
    }
}


class ProductFilter:ViewModel {
    typealias ModelType = Storefront.Filter
    var model: ModelType
    let label: String?
    //let type: String?
    let values: [ProductFilterValue]?
    
    required init(from model: ModelType) {
        self.model = model
        self.label = model.label
        //self.type = model.type as! String
        self.values = model.values.map { filterModel in
            // Assuming you have a method to convert the JSON structure to your model
            return ProductFilterValue(from: filterModel)
        }
    }
}

    class ProductFilterValue:ViewModel {
        typealias modelValue = Storefront.FilterValue
        var model: modelValue
        let id: String
        let label: String
        let input: String?
        let count: Int?
        required init(from model: ModelType) {
            self.model = model
            self.id = model.id
            self.label = model.label
            self.input = model.input
            self.count = Int(model.count)
        }
        
    }
    
extension Storefront.ProductConnection: ViewModeling {
  typealias ViewModelType = ProductFil
}
