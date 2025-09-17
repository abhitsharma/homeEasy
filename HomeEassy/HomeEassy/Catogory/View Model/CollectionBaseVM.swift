//
//  CollectionBaseVM.swift
//  HomeEassy
//
//  Created by Macbook on 23/08/23.
//

import Foundation
protocol CollectionBaseDelegate{
    var collections: PageableArray<CollectionViewModel>! { get set }
    var products: PageableArray<ProductViewModel>! { get set }
    var arrFavProductId:[String]{ get set}
    var filters: [ProductFilter]{get set}
    func fetchCollections(after cursor: String?, completion: @escaping(PageableArray<CollectionViewModel>?)-> Void)
    var collection: CollectionViewModel! { get set }
    func fetchProducts(collection: String, after cursor: String?,selectedFilters: [String:[String]],sortOption:SortOption,completion: @escaping (PageableArray<ProductViewModel>?) -> Void)
    func fetchFavProduct( completion: @escaping ([String]) -> Void)
    var selectSortOption:SortOption! { get set }
    var productTypes:[String]!{get set}
    var selectedFilters:[String:[String]] { get set }
    var filteredCollections:PageableArray<CollectionViewModel>! {get set}
}

class CollectionBaseVM:CollectionBaseDelegate{
    var filters: [ProductFilter] = []
    var selectSortOption: SortOption!
    var selectedFilters = [String:[String]]()
    var collections: PageableArray<CollectionViewModel>!
    var products: PageableArray<ProductViewModel>!
    var collection: CollectionViewModel!
    var filteredCollections:PageableArray<CollectionViewModel>!
    var arrFavProductId:[String] = []
    var productTypes:[String]!
    func fetchCollections(after cursor: String? = nil, completion: @escaping (PageableArray<CollectionViewModel>?) -> Void) {
        Client.shared.fetchCollections(after: cursor) { collections in
            if let collections = collections,collections.items.isEmpty == false{
                self.collections = collections
                completion(collections)
            } else {
                completion(nil)
            }
        }
    }

    
    func fetchProducts(collection: String, after cursor: String? = nil,selectedFilters: [String:[String]],sortOption:SortOption,completion: @escaping (PageableArray<ProductViewModel>?) -> Void){
        if cursor == nil{
            Client.shared.fetchProducts(in: collection,selectedFilters: selectedFilters, sortOption:sortOption) { products,fil  in
                
                if let fil = fil?.filters {
                    self.filters = fil
                }
                if let products = products {
                    self.products = products
                    completion(products)
                }
                else {
                    completion(nil)
                }
            }
            
        }
        else {
            Client.shared.fetchProducts(in: collection, selectedFilters: selectedFilters, sortOption:sortOption, after: cursor) { products,fil  in
                if let fil = fil?.filters {
                    self.filters = fil
                }
                if let products = products {
                    self.products.appendPage(from: products)
                    completion(self.products)
                }
            }
        }
        
        
    }
    
    
    func fetchFavProduct( completion: @escaping ([String]) -> Void){
        let userID = WishListController.shared.userId!
        let arrFavProductIDs = persistentStorage.Shared.fetchProducts(forUserID: userID)
        completion(arrFavProductIDs)
        
        
    }
}
