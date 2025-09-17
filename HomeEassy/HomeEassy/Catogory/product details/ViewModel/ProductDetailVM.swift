//
//  ProductDetailVM.swift
//  HomeEassy
//
//  Created by Macbook on 31/08/23.
//

import Foundation
import MobileBuySDK
protocol ProductDetailVMDelegate{
    var products: ProductObj! { get set }
    var recommendedProduct:[ProductObj]!{ get set }
    func fetchProducts(id:String,completion: @escaping (ProductObj?) -> Void)
    func fetchRecommendations(id:String,completion: @escaping ([ProductObj]?) -> Void)
}

class ProductDetailVM:ProductDetailVMDelegate{
    var products: ProductObj!
    var recommendedProduct: [ProductObj]!
    
    func fetchProducts(id: String, completion: @escaping (ProductObj?) -> Void) {
        Client.shared.fetchProductDetails(GraphQL.ID.init(rawValue:id)){ [self]  details in
            if details != nil{
                products = details!
                completion(products)
            }
            else{
                completion(nil)
            }
        }
    }
    
    func fetchRecommendations(id: String, completion: @escaping ([ProductObj]?) -> Void) {
        Client.shared.fetchProductRecommendations(GraphQL.ID.init(rawValue:id)){ [self] productsd in
            if let products = productsd {
                recommendedProduct = products
                completion(recommendedProduct)
            }
            else{
                completion(nil)
            }
        }
        
    }
 
}
