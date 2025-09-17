//
//  Client.swift
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

let pageItemCount:Int = 25
final class Client {
    
    static let shopDomain = "c63730-2.myshopify.com"
    static let apiKey     = "8320afa5b7998c963ff80d60d9f76221"
    static let merchantID = "merchant.com.your.id"
    static let locale   = Locale(identifier: "en-US")
    
    static let shared = Client()
    
    private let client: Graph.Client = Graph.Client(shopDomain: Client.shopDomain, apiKey: Client.apiKey)
    
    // ----------------------------------
    //  MARK: - Init -
    //
    private init() {
        self.client.cachePolicy = .cacheFirst(expireIn: 3600)
    }
    
    // ----------------------------------
    //  MARK: - Customers -
    //
    @discardableResult
    func login(email: String, password: String, completion: @escaping (Storefront.Mutation?) -> Void) -> Task {
        
        let mutation = ClientQuery.mutationForLogin(email: email, password: password)
        let task     = self.client.mutateGraphWith(mutation) { (mutation, error) in
            error.debugPrint()
            
            if let mutation = mutation{
                completion(mutation)
            } else {
                print("Failed to update Customer: \(String(describing: error))")
                completion(nil)
                
            }
        }
        task.resume()
        return task
    }
    
    @discardableResult
    func logout(accessToken: String, completion: @escaping (Bool) -> Void) -> Task {
        
        let mutation = ClientQuery.mutationForLogout(accessToken: accessToken)
        let task     = self.client.mutateGraphWith(mutation) { (mutation, error) in
            error.debugPrint()
            
            if let deletedToken = mutation?.customerAccessTokenDelete?.deletedAccessToken {
                AccountController.shared.deleteAccessToken()
                WishListController.shared.deleteUserId()
                CartController.shared.removeAllItem()
                completion(deletedToken == accessToken)
            } else {
                let errors = mutation?.customerAccessTokenDelete?.userErrors ?? []
                print("Failed to logout customer: \(errors)")
                completion(false)
            }
        }
        
        task.resume()
        return task
    }
    
    func resetPassword(email:String , completion: @escaping (String?) -> Void) -> Task{
        let mutation = ClientQuery.mutationResetPassword(email: email)
        let task = self.client.mutateGraphWith(mutation){  response, error in
            if let customer = response?.customerRecover{
                completion(customer.customerUserErrors.first?.message)
            }
            else {
                print("Customer recover has fail\(String(describing: error))")
                completion(nil)
            }
            
        }
        task.resume()
        return task
    }
    
    func updateCustomer(customerAccessToken: String,firstName:String,lastName:String,phone:String, completion: @escaping (String?) -> Void) -> Task {
            let mutation = ClientQuery.mutationEditUser(customerAccessToken: customerAccessToken, firstName: firstName, lastName: lastName, phone: phone)
            let task = self.client.mutateGraphWith(mutation) { response, error in
                if let customer = response?.customerUpdate?.customer {
                    completion(nil)
                }
                else if let fail = response?.customerUpdate?.customerUserErrors{
                    completion(fail.first?.message)
                }
                    else {
                    print("Customer update failed: \(String(describing: error))")
                        completion(error?.localizedDescription)
                }
            }

            task.resume()
            return task
        }
    
    @discardableResult
    func createUser( firstName:String,lastName:String, email:String,mobile:String,password:String,acceptMarketEmail:Bool,completion: @escaping (String?) -> Void) -> Task {
        let mutation = ClientQuery.mutationForCreateUser(firstName: firstName, lastName: lastName, email: email, mobile: mobile, password: password, acceptMarketEmail: acceptMarketEmail)
        let task     = self.client.mutateGraphWith(mutation) { response, error in
            error.debugPrint()
            var errorMessage = ""
            if let customer = response?.customerCreate?.customer {
                completion(nil)
            }
            else if let errors = response?.customerCreate?.customerUserErrors {
                        for error in errors {
                            errorMessage += error.message + "\n" // Append each error message
                        }
                        completion(errorMessage)
                    }
            else {
                completion("Creating Customer Limit exceeded. Please try again later.")
                
            }
        }

            task.resume()
            return task
        
    }
    @discardableResult
    func fetchUserProfile(accessToken:String,completion: @escaping (_ customer: CustomerViewModel?) -> Void) -> Task {
      let query = ClientQuery.queryForUserProfile(accessToken:accessToken)
        let task = client.queryGraphWith(query, cachePolicy: .networkFirst(expireIn: 20)) { query, error in
            error.debugPrint()
            if let customer = query?.customer {
                let viewModel   = customer.viewModel
                completion(viewModel)
            }
            else {
                completion(nil)
            }
        }
      task.resume()
      return task
    }
    
    func fetchMenu(completion: @escaping (MenuViewModel) -> Void) -> Task {
      let query = ClientQuery.queryForMenuId()
        let task = client.queryGraphWith(query) { query, error in
            if let query = query?.menu?.viewModel{
                print(query)
                completion(query)
            }
            else{
                error.debugPrint()
                print(error)
            }
        }
        task.resume()
        return task
    }
    
    @discardableResult
    func fetchCustomerAndOrders(limit: Int = 25, after cursor: String? = nil, accessToken: String, completion: @escaping ((customer: CustomerViewModel, orders: PageableArray<OrderViewModel>)?) -> Void) -> Task {
        
        let query = ClientQuery.queryForCustomer(limit: limit, after: cursor, accessToken: accessToken)
        let task  = self.client.queryGraphWith(query) { (query, error) in
            error.debugPrint()
            
            if let customer = query?.customer {
                let viewModel   = customer.viewModel
                let collections = PageableArray(
                    with:     customer.orders.edges,
                    pageInfo: customer.orders.pageInfo
                )
                completion((viewModel, collections))
            } else {
                print("Failed to load customer and orders: \(String(describing: error))")
                completion(nil)
            }
        }
        
        task.resume()
        return task
    }
    
    @discardableResult
    func fetchCustomerAndOrders(limit:Int=pageItemCount, after cursor: String? = nil, accessToken: String, completion: @escaping (PageableArray<OrderViewModel>?) -> Void) -> Task {
      
      let query = ClientQuery.queryForCustomer(limit: limit, after: cursor, accessToken: accessToken)
      let task  = self.client.queryGraphWith(query,cachePolicy: .networkFirst(expireIn: 20)) { (query, error) in
        error.debugPrint()
        
        if let customer = query?.customer {
          //let viewModel   = customer.viewModel
          let collections = PageableArray(
            with:     customer.orders.edges,
            pageInfo: customer.orders.pageInfo
          )
          completion(collections)
        } else {
          print("Failed to load customer and orders: \(String(describing: error))")
          completion(nil)
        }}
      task.resume()
      return task
    }
    // ----------------------------------
    //  MARK: - Shop -
    //
    @discardableResult
    func fetchShopName(completion: @escaping (String?) -> Void) -> Task {
        
        let query = ClientQuery.queryForShopName()
        let task  = self.client.queryGraphWith(query) { (query, error) in
            error.debugPrint()
            
            if let query = query {
                completion(query.shop.name)
            } else {
                print("Failed to fetch shop name: \(String(describing: error))")
                completion(nil)
            }
        }
        task.resume()
        return task
    }
    
    @discardableResult
    func fetchShopURL(completion: @escaping (URL?) -> Void) -> Task {
        
        let query = ClientQuery.queryForShopURL()
        let task  = self.client.queryGraphWith(query) { (query, error) in
            error.debugPrint()
            
            if let query = query {
                completion(query.shop.primaryDomain.url)
            } else {
                print("Failed to fetch shop url: \(String(describing: error))")
                completion(nil)
            }
        }
        
        task.resume()
        return task
    }
    
    // ----------------------------------
    //  MARK: - Collections -
    //
    @discardableResult
    func fetchCollections(limit: Int = 50, after cursor: String? = nil, productLimit: Int = 25, productCursor: String? = nil, completion: @escaping (PageableArray<CollectionViewModel>?) -> Void) -> Task {
        
        let query = ClientQuery.queryForCollections(limit: limit, after: cursor, productLimit: productLimit, productCursor: productCursor)
        let task  = self.client.queryGraphWith(query) { (query, error) in
            error.debugPrint()
            
            if let query = query {
                let collections = PageableArray(
                    with:     query.collections.edges,
                    pageInfo: query.collections.pageInfo
                )
                completion(collections)
            } else {
                print("Failed to load collections: \(String(describing: error))")
                completion(nil)
            }
        }
        
        task.resume()
        return task
    }
    @discardableResult
    func fethCollectionWithId(_ arr:[GraphQL.ID],size:CGSize, completion: @escaping ([CollectionModel]) -> Void) -> Task {
        let query = ClientQuery.queryForCollectionWithIdt(arr,size:size)
        let task = self.client.queryGraphWith(query) { response, error in
          var products=[CollectionModel]()
          if let product  = response?.nodes {
            for nodes in product{
              if let product1  = nodes as? Storefront.Collection{
                products.append(product1.viewModel)
              }
            }
          }
          completion(products)
        }
        task.resume()
         return task
      }
    
    @discardableResult
    func fethMenuCollectionId(_ arr:[GraphQL.ID], completion: @escaping ([CollectionModel]) -> Void) -> Task {
        let query = ClientQuery.queryForMenuCollectionId(arr)
        let task = self.client.queryGraphWith(query) { response, error in
          var products=[CollectionModel]()
          if let product  = response?.nodes {
            for nodes in product{
              if let product1  = nodes as? Storefront.Collection{
                products.append(product1.viewModel)
              }
            }
          }
          completion(products)
        }
        task.resume()
         return task
      }
    
    @discardableResult
    func fetchAllProductType(_ completion: @escaping ([String]?) -> Void) -> Task {
      let query = ClientQuery.queryForProductsType()
      let task = self.client.queryGraphWith(query) { response, error in
        if  let product  = response {
          let products = product.productTypes.edges.map { $0.node }
          completion(products)
        }
      }
      task.resume()
      return task
    }
    
    func searchAllProduct(_ limit: Int=pageItemCount, after cursor: String? = nil,sortOption: SortOption? = nil,query:String?=nil, completion:  @escaping (PageableArray<ProductViewModel>?) -> Void) -> Task {
      var  soringKey:Storefront.ProductSortKeys?
      if let sortOption=sortOption{
        soringKey = Storefront.ProductSortKeys.init(rawValue: sortOption.sortingKey)
      }
      let query = ClientQuery.queryForProductsSearch(limit: limit, after: cursor,sortKey:soringKey,reverse:sortOption?.reverse ?? false,querySearch:query)
      let task = self.client.queryGraphWith(query) { response, error in
        if let product  = response?.products {
          let products = PageableArray(
            with:     product.edges,
            pageInfo: product.pageInfo
          )
          completion(products)
        }
        else{
          completion(nil)
        }
      }
      task.resume()
      return task
      
    }
    // ----------------------------------
    //  MARK: - Products -
    //
    
    
    @discardableResult
    func fetchProducts(in collectionId: String, limit: Int = 25,selectedFilters:[String:[String]],sortOption: SortOption? = nil, after cursor: String? = nil, completion: @escaping (PageableArray<ProductViewModel>?,ProductFil?) -> Void) -> Task {
        struct ProductFil {
            var vendor: String?
            var productType: String?
            // Add more filter properties as needed
        }
        
        var  soringKey:Storefront.ProductCollectionSortKeys?
        if let sortOption=sortOption{
            soringKey = Storefront.ProductCollectionSortKeys.init(rawValue: sortOption.sortingKey)
        }
        var filters:[Storefront.ProductFilter] = []
        for sel in selectedFilters{
            if sel.key == "Availability"{
                for value in sel.value{
                    if value == "In stock"{
                        let inputFilter = Storefront.ProductFilter.create(available: Input.value(true))
                        filters.append(inputFilter)
                    }
                    else{
                        let inputFilter = Storefront.ProductFilter.create(available:  Input.value(false))
                        filters.append(inputFilter)
                    }
                }
            }
           else if sel.key == "price"{
                for value in sel.value{
//                    let inputFilter = Storefront.ProductFilter.create(price:)
//                        filters.append(inputFilter)
                }
            }
            else{ //let input = Storefront.VariantOptionFilter(name: sel.key, value: sel.value)
                for value in sel.value{
                    let input = Storefront.VariantOptionFilter(name: sel.key, value: value)
                    let inputFilter = Storefront.ProductFilter.create(variantOption:Input.value(input))
                    filters.append(inputFilter)
                }
            }
            }
        
        let id = GraphQL.ID.init(rawValue: collectionId)
        let query = ClientQuery.queryForProducts(in: id, limit: limit, after: cursor,sortKey:soringKey, filters: filters,reverse:sortOption?.reverse ?? false)
        let task  = self.client.queryGraphWith(query) { (query, error) in
            error.debugPrint()
            if let query = query,
                let collection = query.node as? Storefront.Collection {
                let filterCollection = collection.products
                let products = PageableArray(
                    with:     collection.products.edges,
                    pageInfo: collection.products.pageInfo
                )
                completion(products,filterCollection.viewModel)
                
            } else {
                print("Failed to load products in collection (\(collectionId)): \(String(describing: error))")
                completion(nil, nil)
            }
        }
        
        task.resume()
        return task
    }
    
    
    
    @discardableResult
    func fethProductsWithId(_ arr:[GraphQL.ID] , completion: @escaping ([ProductObj]) -> Void) -> Task {
      let query = ClientQuery.queryForProductsWishlist(arr)
      let task = self.client.queryGraphWith(query) { response, error in
        var products=[ProductObj]()
        if let product  = response?.nodes {
          for nodes in product{
            if let product1  = nodes as? Storefront.Product{
              products.append(product1.viewModel)
            }
          }
        }
        completion(products)

      }
      task.resume()
       return task
    }
    
    
    @discardableResult
    func fethProductVarintData(_ arr:[GraphQL.ID] , completion: @escaping ([CartItemViewModel]) -> Void) -> Task {
      let query = ClientQuery.productVariantListIdsQuery(arr)
      let task = self.client.queryGraphWith(query) { response, error in
        var products=[CartItemViewModel]()
        if let product  = response?.nodes {
          for nodes in product{
            if let product1  = nodes as? Storefront.ProductVariant{
              products.append(product1.viewModel)
            }
          }
        }
        completion(products)

      }
      task.resume()
       return task
    }
    
    //product Details
    func fetchProductDetails(_ productId:GraphQL.ID , completion: @escaping (ProductObj?) -> Void) -> Task {
        
        let query = ClientQuery.queryForProductsDetails(productId)
        let task = self.client.queryGraphWith(query) { response, error in
            if let product  = response?.product{
                completion(product.viewModel)
          }
            if let error = error?.localizedDescription{
                completion(nil)
            }
        }
        
        task.resume()
        return task
      }
    
    // product recomendation
    @discardableResult
    func fetchProductRecommendations(_ productId:GraphQL.ID , completion: @escaping ([ProductObj]?) -> Void) -> Task {
      let query = ClientQuery.queryForProductsRecomandation(in: productId, limit: pageItemCount)
          let task = self.client.queryGraphWith(query) { response, error in
        
        if  let product  = response?.productRecommendations{
          print(product.viewModels)
          completion(product.viewModels)
        }
      }
      task.resume()
      return task
    }
    
    //address
    @discardableResult
    func fetchUserAddresses(accesstoken:String?,completion: @escaping (_ customer: AddressViewModel?,[AddressViewModel]?) -> Void) -> Task {
      let query = ClientQuery.queryForUserAddress(accessToken:accesstoken ?? "")
     let task = client.queryGraphWith(query, cachePolicy: .networkFirst(expireIn: 20)) { query, error in
        error.debugPrint()
        var addressModel = [AddressViewModel]()
        if let query = query?.customer{
          for (_,address) in  (query.addresses.edges.enumerated())
          {
            addressModel.append(address.node.viewModel)
          }
          completion( query.defaultAddress?.viewModel ,addressModel)
        }}
      task.resume()
      return task
    }
    
    // add address
    @discardableResult
    func  addUserAddress(accesstoken:String?,address:String,address2:String,city:String,zip:String,province:String,phone: String,completion: @escaping (Storefront.Mutation?) -> Void)  -> Task {
        let mutation = ClientQuery.mutationAddUserAddress(accessToken: accesstoken!, address: address, address2: address2, city: city, zip: zip, province: province, phone: phone)
      let task  = self.client.mutateGraphWith(mutation) { (mutation, error) in
        error.debugPrint()
        if let mutation = mutation{
          completion(mutation)
        }else{
          print("Failed to Add update Address: \(String(describing: error))")
          completion(nil)
        }}
      task.resume()
      return task
    }
    
    // set Default address
    @discardableResult
    func  setDefaultUserAddress(accesstoken:String?,Id:String?,completion: @escaping (Storefront.Mutation?) -> Void)  -> Task {
      let mutation = ClientQuery.mutationSetUserDefaultAddress(accessToken:accesstoken ?? "",Id:Id ?? "")
      let task  = self.client.mutateGraphWith(mutation) { (mutation, error) in
        error.debugPrint()
        if let mutation = mutation{
          completion(mutation)
        }else{
          print("Failed to Add update Address: \(String(describing: error))")
          completion(nil)
        }}
      task.resume()
      return task
    }
    
    @discardableResult
    func  updateUserAddress(accesstoken:String?,address:String,address2:String,city:String,zip:String,province:String,id:String,phone: String,completion:@escaping (Storefront.Mutation?) -> Void) -> Task {
        let mutation = ClientQuery.mutationUpdateUserAddress(accessToken: accesstoken ?? "", id: id, address: address, address2: address2, city: city, zip: zip, province: province, phone: phone)
      let task  = self.client.mutateGraphWith(mutation) { (mutation, error) in
        error.debugPrint()
        if let mutation = mutation{
          completion(mutation)
        }else{
          print("Failed to Add update Address: \(String(describing: error))")
          completion(nil)
        }}
      task.resume()
      return task
    }
    
    @discardableResult
    func  deleteUserAddress(accesstoken:String?,id:String,completion: @escaping (Storefront.Mutation?) -> Void)  -> Task {
      let mutation = ClientQuery.mutationDeleteUserAddress(accessToken: accesstoken ?? "",id: id)
      let task  = self.client.mutateGraphWith(mutation) { (mutation, error) in
        error.debugPrint()
        if let mutation = mutation{
          completion(mutation)
        }else{
         
          print("Failed to delete Address: \(String(describing: error))")
          completion(nil)
        }}
      task.resume()
      return task
    }
    // ----------------------------------
    //  MARK: - Discounts -
    //
    @discardableResult
    func applyDiscount(_ discountCode: String, to checkoutID: String, completion: @escaping (CheckoutViewModel?) -> Void) -> Task {
        let mutation = ClientQuery.mutationForApplyingDiscount(discountCode, to: checkoutID)
        let task     = self.client.mutateGraphWith(mutation) { response, error in
            error.debugPrint()
            
            completion(response?.checkoutDiscountCodeApplyV2?.checkout?.viewModel)
        }
        
        task.resume()
        return task
    }
    
    // ----------------------------------
    //  MARK: - Gift Cards -
    //
    @discardableResult
    func applyGiftCard(_ giftCardCode: String, to checkoutID: String, completion: @escaping (CheckoutViewModel?) -> Void) -> Task {
        let mutation = ClientQuery.mutationForApplyingGiftCard(giftCardCode, to: checkoutID)
        let task     = self.client.mutateGraphWith(mutation) { response, error in
            error.debugPrint()
            
            completion(response?.checkoutGiftCardsAppend?.checkout?.viewModel)
        }
        
        task.resume()
        return task
    }
    
    // ----------------------------------
    //  MARK: - Checkout -
    //
    @discardableResult
    func createCheckout(with cartItems: [CartItem], completion: @escaping (CheckoutViewModel?) -> Void) -> Task {
        let mutation = ClientQuery.mutationForCreateCheckout(with: cartItems)
        let task     = self.client.mutateGraphWith(mutation) { response, error in
            error.debugPrint()
          
            if let success = response?.checkoutCreate?.checkout{
                completion(success.viewModel)
            }
            else if let errors = response?.checkoutCreate?.checkoutUserErrors{
                completion(nil)
            }
           
        }
        
        task.resume()
        return task
    }
    
    @discardableResult
    func updateCheckout(_ id: String, updatingPartialShippingAddress address: PayPostalAddress, completion: @escaping (CheckoutViewModel?) -> Void) -> Task {
        let mutation = ClientQuery.mutationForUpdateCheckout(id, updatingPartialShippingAddress: address)
        let task     = self.client.mutateGraphWith(mutation) { response, error in
            error.debugPrint()
            
            if let checkout = response?.checkoutShippingAddressUpdateV2?.checkout,
                let _ = checkout.shippingAddress {
                completion(checkout.viewModel)
            } else {
                completion(nil)
            }
        }
        
        task.resume()
        return task
    }
    
    @discardableResult
    func updateCheckout(_ id: String, updatingCompleteShippingAddress address: PayAddress, completion: @escaping (CheckoutViewModel?) -> Void) -> Task {
        let mutation = ClientQuery.mutationForUpdateCheckout(id, updatingCompleteShippingAddress: address)
        let task     = self.client.mutateGraphWith(mutation) { response, error in
            error.debugPrint()
            
            if let checkout = response?.checkoutShippingAddressUpdateV2?.checkout,
                let _ = checkout.shippingAddress {
                completion(checkout.viewModel)
            } else {
                completion(nil)
            }
        }
        
        task.resume()
        return task
    }
    
    @discardableResult
    func updateCheckout(_ id: String, updatingShippingRate shippingRate: PayShippingRate, completion: @escaping (CheckoutViewModel?) -> Void) -> Task {
        let mutation = ClientQuery.mutationForUpdateCheckout(id, updatingShippingRate: shippingRate)
        let task     = self.client.mutateGraphWith(mutation) { response, error in
            error.debugPrint()
            
            if let checkout = response?.checkoutShippingLineUpdate?.checkout,
                let _ = checkout.shippingLine {
                completion(checkout.viewModel)
            } else {
                completion(nil)
            }
        }
        
        task.resume()
        return task
    }
    
    @discardableResult
    func pollForReadyCheckout(_ id: String, completion: @escaping (CheckoutViewModel?) -> Void) -> Task {

        let retry = Graph.RetryHandler<Storefront.QueryRoot>(endurance: .finite(30)) { response, error -> Bool in
            error.debugPrint()
            return (response?.node as? Storefront.Checkout)?.ready ?? false == false
        }
        
        let query = ClientQuery.queryForCheckout(id)
        let task  = client.queryGraphWith(query, cachePolicy: .networkOnly, retryHandler: retry) { response, error in
            error.debugPrint()
            
            if let checkout = response?.node as? Storefront.Checkout {
                completion(checkout.viewModel)
            } else {
                completion(nil)
            }
        }
        
        task.resume()
        return task
    }
    
    @discardableResult
    func updateCheckout(_ id: String, updatingEmail email: String, completion: @escaping (CheckoutViewModel?) -> Void) -> Task {
        let mutation = ClientQuery.mutationForUpdateCheckout(id, updatingEmail: email)
        let task     = self.client.mutateGraphWith(mutation) { response, error in
            error.debugPrint()
            
            if let checkout = response?.checkoutEmailUpdateV2?.checkout,
                let _ = checkout.email {
                completion(checkout.viewModel)
            } else {
                completion(nil)
            }
        }
        
        task.resume()
        return task
    }
    
    @discardableResult
    func updateCheckout(_ id: String, associatingCustomer accessToken: String, completion: @escaping (CheckoutViewModel?) -> Void) -> Task {
        
        let mutation = ClientQuery.mutationForUpdateCheckout(id, associatingCustomer: accessToken)
        let task     = self.client.mutateGraphWith(mutation) { (mutation, error) in
            error.debugPrint()
            
            if let checkout = mutation?.checkoutCustomerAssociateV2?.checkout {
                completion(checkout.viewModel)
            } else {
                completion(nil)
            }
        }
        
        task.resume()
        return task
    }
    
    @discardableResult
    func fetchShippingRatesForCheckout(_ id: String, completion: @escaping ((checkout: CheckoutViewModel, rates: [ShippingRateViewModel])?) -> Void) -> Task {
        
        let retry = Graph.RetryHandler<Storefront.QueryRoot>(endurance: .finite(30)) { response, error -> Bool in
            error.debugPrint()
            
            if let checkout = response?.node as? Storefront.Checkout {
                return checkout.availableShippingRates?.ready ?? false == false || checkout.ready == false
            } else {
                return false
            }
        }
        
        let query = ClientQuery.queryShippingRatesForCheckout(id)
        let task  = self.client.queryGraphWith(query, cachePolicy: .networkOnly, retryHandler: retry) { response, error in
            error.debugPrint()
            
            if let response = response,
                let checkout = response.node as? Storefront.Checkout {
                completion((checkout.viewModel, checkout.availableShippingRates!.shippingRates!.viewModels))
            } else {
                completion(nil)
            }
        }
        
        task.resume()
        return task
    }
    
    func completeCheckout(_ checkout: PayCheckout, billingAddress: PayAddress, applePayToken token: String, idempotencyToken: String, completion: @escaping (PaymentViewModel?) -> Void) {
        
        let mutation = ClientQuery.mutationForCompleteCheckoutUsingApplePay(checkout, billingAddress: billingAddress, token: token, idempotencyToken: idempotencyToken)
        let task     = self.client.mutateGraphWith(mutation) { response, error in
            error.debugPrint()
            
            if let payment = response?.checkoutCompleteWithTokenizedPaymentV3?.payment {
                
                print("Payment created, fetching status...")
                self.fetchCompletedPayment(payment.id.rawValue) { paymentViewModel in
                    completion(paymentViewModel)
                }
                
            } else {
                completion(nil)
            }
        }
        
        task.resume()
    }
    
    func fetchCompletedPayment(_ id: String, completion: @escaping (PaymentViewModel?) -> Void) {
        
        let retry = Graph.RetryHandler<Storefront.QueryRoot>(endurance: .finite(30)) { response, error -> Bool in
            error.debugPrint()
            
            if let payment = response?.node as? Storefront.Payment {
                print("Payment not ready yet, retrying...")
                return !payment.ready
            } else {
                return false
            }
        }
        
        let query = ClientQuery.queryForPayment(id)
        let task  = self.client.queryGraphWith(query, retryHandler: retry) { query, error in
            
            if let payment = query?.node as? Storefront.Payment {
                print("Payment error: \(payment.errorMessage ?? "none")")
                completion(payment.viewModel)
            } else {
                completion(nil)
            }
        }
        
        task.resume()
    }
}

// ----------------------------------
//  MARK: - GraphError -
//
extension Optional where Wrapped == Graph.QueryError {
    
    func debugPrint() {
        switch self {
        case .some(let value):
            print("Graph.QueryError: \(value.localizedDescription)")
        case .none:
            break
        }
    }
}
