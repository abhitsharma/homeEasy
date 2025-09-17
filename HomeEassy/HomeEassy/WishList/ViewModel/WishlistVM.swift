//
//  WishlistVM.swift
//  HomeEassy
//
//  Created by Macbook on 04/09/23.
//

import Foundation
import MobileBuySDK

protocol WishlistVMDelegate{
    func fetchWishList(completion: @escaping ([ProductObj]?) -> Void)
    var arrProductId:[String] { get set }
    var products: [ProductObj]! { get set }
}

class WishlistVM:WishlistVMDelegate{
    var arrProductId:[String] = []
    var products: [ProductObj]!
    
    func fetchWishList( completion: @escaping ([ProductObj]?) -> Void){
            let userID = WishListController.shared.userId!
            let arrProductIDs = persistentStorage.Shared.fetchProducts(forUserID: userID)
            let arrProductGraphQLIds = arrProductIDs.map { GraphQL.ID(rawValue: $0) }
            Client.shared.fethProductsWithId(arrProductGraphQLIds) { products in
                completion(products)
            }
        }

}
