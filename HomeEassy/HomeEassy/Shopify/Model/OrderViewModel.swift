//
//  OrderViewModel.swift
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

final class OrderViewModel: ViewModel {
    
    typealias ModelType = Storefront.OrderEdge
    
    let model:       ModelType
    let cursor:      String
    
    let id:          String
    let number:      Int
    let email:       String?
    let totalPrice:  Decimal
   var subTotalPrice:  Decimal?
   let shippingTotalPrice:  Decimal
   var taxTotalPrice:  Decimal?
    let financialStatus:          String?
    let fulfillmentStatus:          String?
    let processedAt:          Date
    let lineItems:        [OrderLineItemViewModel]
    let shippingAddress:  AddressViewModel?
   var trackingCompany:  String?
   var trackingInfoNumber:  String?
   var trackingInfoUrl:  URL?
  let currencyCode:  String
    let statusUrl:URL?

    // ----------------------------------
    //  MARK: - Init -
    //
    required init(from model: ModelType) {
        self.model       = model
        self.cursor      = model.cursor
      self.currencyCode  = model.node.currencyCode.rawValue
      Currency.currencyCode=self.currencyCode

        self.id          = model.node.id.rawValue
      self.financialStatus          = model.node.financialStatus?.rawValue
      self.fulfillmentStatus          = model.node.fulfillmentStatus.rawValue
      self.processedAt          = model.node.processedAt
        self.number      = Int(model.node.orderNumber)
        self.email       = model.node.email
        self.totalPrice  = model.node.totalPrice.amount
      self.lineItems        = model.node.lineItems.edges.viewModels
      
      self.subTotalPrice  = model.node.subtotalPrice?.amount
      self.shippingTotalPrice  = model.node.totalShippingPrice.amount
      self.taxTotalPrice  = model.node.totalTax?.amount
      self.shippingAddress  = model.node.shippingAddress?.viewModel
      self.trackingCompany  = model.node.successfulFulfillments?.first?.trackingCompany
      self.trackingInfoNumber  = model.node.successfulFulfillments?.first?.trackingInfo.first?.number
      self.trackingInfoUrl  = model.node.successfulFulfillments?.first?.trackingInfo.first?.url
        self.statusUrl = model.node.statusUrl
    }
}

extension Storefront.OrderEdge: ViewModeling {
    typealias ViewModelType = OrderViewModel
}
