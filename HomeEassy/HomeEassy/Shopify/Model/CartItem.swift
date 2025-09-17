//
//  CartItem.swift
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

class CartItem: Equatable, Hashable, Serializable {
    
    private struct Key {
        static let product  = "product"
        static let quantity = "quantity"
        static let variant  = "variant"
    }
    
    let product: ProductObj
    let variantId: String
    
    var quantity: Int
    
    // ----------------------------------
    //  MARK: - Init -
    //
    required init(product: ProductObj, variantId: String, quantity: Int = 1) {
        self.product  = product
        self.variantId  = variantId
        self.quantity = quantity
    }
    
    // ----------------------------------
    //  MARK: - Serializable -
    //
    static func deserialize(from representation: SerializedRepresentation) -> Self? {
        guard let product = ProductObj.deserialize(from: representation[Key.product] as! SerializedRepresentation) else {
            return nil
        }
        
        guard let variant = representation[Key.variant] as? String else {
            return nil
          }
        
        guard let quantity = representation[Key.quantity] as? Int else {
            return nil
        }
        
        return self.init(
            product:  product,
            variantId:  variant,
            quantity: quantity
        )
    }
    
    func serialize() -> SerializedRepresentation {
        return [
            Key.quantity : self.quantity,
            Key.product  : self.product.serialize(),
            Key.variant  : self.variantId,
        ]
    }
}

// ----------------------------------
//  MARK: - Hashable -
//
extension CartItem {

    func hash(into hasher: inout Hasher) {
        hasher.combine(self.variantId)
    }
}

// ----------------------------------
//  MARK: - Equatable -
//
extension CartItem {
    
    static func ==(lhs: CartItem, rhs: CartItem) -> Bool {
        return lhs.variantId == rhs.variantId && lhs.product.id == rhs.product.id
    }
}
