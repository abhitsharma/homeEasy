//
//  LoginBaseViewModel.swift
//  HomeEassy
//
//  Created by Macbook on 23/08/23.
//

import Foundation
protocol LoginBaseDelgate {
    func processLogin(email:String,password:String, completion: @escaping (String?) -> Void)
    func ProcessEdit(customerAccessToken: String, firstName: String, lastName: String, phone: String, completion: @escaping (String?) -> Void)
    func UserDetails(completion: @escaping (CustomerViewModel?) -> Void)
    var customerDetail:CustomerViewModel!{get set}
}

class LoginBaseViewModel:LoginBaseDelgate{
    func UserDetails(completion: @escaping (CustomerViewModel?) -> Void) {
        Client.shared.fetchUserProfile(accessToken: AccountController.shared.accessToken ?? ""){ [self]  container in
            if container != nil{
                customerDetail = container
                if  container?.displayName != nil || container?.displayName != ""{
                    WishListController.shared.saveUser(userId: customerDetail!.id)
                    persistentStorage.Shared.addUserIfNotExists(userID: customerDetail.id)
                    persistentStorage.Shared.saveContext()
                    completion(customerDetail)
                }
            }
            else {
                completion(nil)
            }
        }
    }
    
    var customerDetail: CustomerViewModel!
    
    func ProcessEdit(customerAccessToken: String, firstName: String, lastName: String, phone: String, completion: @escaping (String?) -> Void) {
        Client.shared.updateCustomer(customerAccessToken: customerAccessToken, firstName: firstName, lastName: lastName, phone: phone){ customer in
            if customer == nil{
                completion(nil)
            }
            else{
                completion(customer!)
            }
        }
    }
    

    
    func processLogin(email:String,password:String, completion: @escaping (String?) -> Void){
        Client.shared.login(email: email, password: password) { customer in
            if let accessToken = customer?.customerAccessTokenCreate?.customerAccessToken {
                AccountController.shared.save(accessToken: (accessToken.accessToken))
                    Client.shared.fetchUserProfile(accessToken: AccountController.shared.accessToken ?? ""){ [self]  container in
                        if container != nil{
                            customerDetail = container
                            if  container?.displayName != nil || container?.displayName != ""{
                                WishListController.shared.saveUser(userId: customerDetail!.id)
                                persistentStorage.Shared.addUserIfNotExists(userID: customerDetail.id)
                                persistentStorage.Shared.saveContext()
                                
                                completion("Sucess")
                            }
                        }
                    }
            }
            else if let  error = customer?.customerAccessTokenCreate?.customerUserErrors{
                completion(error.first!.message)
            }
        }
    }
   
}
