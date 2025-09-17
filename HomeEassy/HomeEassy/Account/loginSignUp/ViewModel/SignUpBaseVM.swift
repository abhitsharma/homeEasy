//
//  SignUpBaseVM.swift
//  HomeEassy
//
//  Created by Macbook on 23/08/23.
//

import Foundation
protocol SignUpBaseDelgate {
    func processSignUP(firstName: String, lastName: String, email:String, mobile: String, password: String, acceptMarketEmail:Bool,completion: @escaping (String) -> Void)
}
class SignUpBaseVM:SignUpBaseDelgate{
    
    func processSignUP(firstName: String, lastName: String, email:String, mobile: String, password: String, acceptMarketEmail:Bool,completion: @escaping (String) -> Void){
        Client.shared.createUser(firstName: firstName, lastName: lastName, email: email, mobile: mobile, password: password, acceptMarketEmail:acceptMarketEmail){  value in
            if value == nil{
                completion("Success")
            }
            else{
                completion(value!)
            }
            
        }
    }
}
