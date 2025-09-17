//
//  PersistantStorage.swift
//  HomeEassy
//
//  Created by Macbook on 01/09/23.
//

import Foundation
import CoreData

final class persistentStorage{
    private init(){}
    static let Shared = persistentStorage()
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "HomeEassy")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
        
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support
    lazy var  context = persistentContainer.viewContext
    func saveContext () {
               if context.hasChanges {
            do {
                try context.save()
            } catch {
               
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    func addUserIfNotExists(userID: String) {
        let fetchRequest: NSFetchRequest<WishList> = WishList.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "userId == %@", userID)
        
        do {
            let users = try context.fetch(fetchRequest)
            if users.isEmpty {
                // User doesn't exist, create a new user
                let newUser = WishList(context: context)
                newUser.userId = userID
                
                // Save the changes to CoreData
                try context.save()
            }
        } catch {
            print("Error fetching user data: \(error)")
        }
    }
    
//    // Function to insert a productID associated with a user
//    func insertProduct(productID: String, userID: String) {
//        // Create a product and set its attributes
//        let product = WishList(context: context)
//        product.productId = productID
//        product.userId = userID
//
//        // Save the changes to CoreData
//        do {
//            try context.save()
//        } catch {
//            print("Error saving product data: \(error)")
//        }
//    }
    func insertProduct(productID: String, userID: String) {
        let fetchRequest: NSFetchRequest<WishList> = WishList.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "productId == %@ AND userId == %@", productID, userID)
        
        do {
            let matchingProducts = try context.fetch(fetchRequest)
            
            if matchingProducts.isEmpty {
                let newProduct = WishList(context: context)
                newProduct.productId = productID
                newProduct.userId = userID
                
                // Save the changes to CoreData
                try context.save()
            }
        } catch {
            print("Error checking if product exists: \(error)")
        }
    }

    func fetchProducts(forUserID userID: String) -> [String] {
        let fetchRequest: NSFetchRequest<WishList> = WishList.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "userId == %@", userID)
        
        do {
            let products = try context.fetch(fetchRequest)
            return products.compactMap { $0.productId }
        } catch {
            print("Error fetching products: \(error)")
            return []
        }
    }
    
    // Function to delete products for a specific user
    func deleteProducts(forUserID userID: String) {
        let fetchRequest: NSFetchRequest<WishList> = WishList.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "userId == %@", userID)
        
        do {
            let products = try context.fetch(fetchRequest)
            for product in products {
                context.delete(product)
            }
            
            // Save the changes to CoreData
            try context.save()
        } catch {
            print("Error deleting products: \(error)")
        }
    }
    
    func deleteProduct(withProductId productId: String, forUserId userId: String) {
        let fetchRequest: NSFetchRequest<WishList> = WishList.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "productId == %@ AND userId == %@", productId, userId)

        do {
            let context = persistentStorage.Shared.context
            let matchingProducts = try context.fetch(fetchRequest)

            if let productToDelete = matchingProducts.first {
                context.delete(productToDelete)
                saveContext()
                print("Product with ID \(productId) for User ID \(userId) deleted from Core Data.")
            } else {
                print("Product with ID \(productId) for User ID \(userId) not found in Core Data.")
            }
        } catch {
            print("Error deleting product with ID \(productId) for User ID \(userId): \(error.localizedDescription)")
        }
    }

    func deleteProduct(withProductId productId: String) {
           let fetchRequest: NSFetchRequest<WishList> = WishList.fetchRequest()
           fetchRequest.predicate = NSPredicate(format: "productId == %@", productId)

           do {
               let context = persistentContainer.viewContext
               let matchingProducts = try context.fetch(fetchRequest)

               if let productToDelete = matchingProducts.first {
                   context.delete(productToDelete)
                   saveContext()
                   print("Product with ID \(productId) deleted from Core Data.")
               } else {
                   print("Product with ID \(productId) not found in Core Data.")
               }
           } catch {
               print("Error deleting product with ID \(productId): \(error.localizedDescription)")
           }
       }
    
         
    func insertSearchQuery(searchQuery: String, isTrending: Bool=false) {
        guard !searchQuery.isEmpty else {
            // Don't insert empty strings
            return
        }

        let fetchRequest: NSFetchRequest<SearchHistory> = SearchHistory.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "querySearch == %@", searchQuery)

        do {
            let existingSearchEntities = try context.fetch(fetchRequest)
            if existingSearchEntities.isEmpty {
                // Create a new Search entity only if it doesn't already exist
                let searchEntity = SearchHistory(context: context)
                searchEntity.querySearch = searchQuery
                searchEntity.istrnding = isTrending
                searchEntity.lastupdateDate = Date()
                // Save the changes to CoreData
                try context.save()

                // Check if the total number of search queries exceeds 20

                if let searchQueries = fetchSearchQueries(), searchQueries.count > 20 {
                    // Remove the oldest search query
                    deleteSearchQuery(searchQueries[0])
                }
            }
        } catch {
            print("Error inserting search query: \(error)")
        }
    }

    func fetchSearchQueries() -> [String]? {
        let sortDescriptors = [NSSortDescriptor(key: "lastupdateDate", ascending: false)]
        let predicate=NSPredicate(format: "istrnding == %d", false)
        let fetchRequest: NSFetchRequest<SearchHistory> = SearchHistory.fetchRequest()
        fetchRequest.predicate = predicate
        fetchRequest.sortDescriptors = sortDescriptors
        do {
            let searchEntities = try context.fetch(fetchRequest)
            return searchEntities.compactMap { $0.querySearch }
        } catch {
            print("Error fetching search queries: \(error)")
            return nil // Return nil in case of an error
        }
    }

    func fetchTrendinfQueries(predicate:NSPredicate? = nil,sortWith:NSArray? = nil) -> [String]? {
        let fetchRequest: NSFetchRequest<SearchHistory> = SearchHistory.fetchRequest()
        fetchRequest.predicate = predicate
        if let sortDescriptors = sortWith as? [NSSortDescriptor] {
            fetchRequest.sortDescriptors = sortDescriptors
        }
        do {
            let searchEntities = try context.fetch(fetchRequest)
            return searchEntities.compactMap { $0.querySearch }
        } catch {
            print("Error fetching search queries: \(error)")
            return nil // Return nil in case of an error
        }
    }
    
    func deleteAllSearchQueries() {
        let fetchRequest: NSFetchRequest<SearchHistory> = SearchHistory.fetchRequest()
        
        do {
            let searchEntities = try context.fetch(fetchRequest)
            for searchEntity in searchEntities {
                context.delete(searchEntity)
            }
            
            // Save the changes to CoreData
            try context.save()
        } catch {
            print("Error deleting search queries: \(error)")
        }
    }
    
    func deleteSearchQuery(_ query: String) {
        
        let fetchRequest: NSFetchRequest<SearchHistory> = SearchHistory.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "querySearch == %@", query)

        do {
            if let searchEntities = try context.fetch(fetchRequest).first {
                context.delete(searchEntities)
                try context.save()
            }
        } catch {
            print("Error deleting search query: \(error)")
        }
    }
    
    func deleteAllData(predicate:NSPredicate? = nil)->Bool
    {
        let fetchRequest: NSFetchRequest<SearchHistory> = SearchHistory.fetchRequest()
        fetchRequest.predicate = predicate

        do {
            let searchEntities = try context.fetch(fetchRequest)
            for searchEntity in searchEntities {
                context.delete(searchEntity)
            }
        } catch {
            print("Error deleting search query: \(error)")
            return false
        }
        return true
    }

}

// func getTrendingSearchesServer ()  {
//    let sortDescriptors = [NSSortDescriptor(key: "lastupdateDate", ascending: false)]
//    let predicate=NSPredicate(format: "istrnding == %d", true)
//     if let items = persistentStorage.Shared.fetchTrendinfQueries(predicate: predicate, sortWith: sortDescriptors as NSArray?)  {
//          for object in items {
//              persistentStorage.Shared.deleteSearchQuery(object)
//          }
//  }
//
//  Client.shared.fetchAllProductType { (arrT) in
//    if let arrT=arrT{
//    for trnding in arrT{
//        persistentStorage.Shared.insertSearchQuery(searchQuery: trnding,isTrending: true)
//    }
//    }
//  }
//}
