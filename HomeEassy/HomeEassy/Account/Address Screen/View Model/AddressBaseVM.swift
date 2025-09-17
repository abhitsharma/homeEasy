//
//  AddressBaseVM.swift
//  HomeEassy
//
//  Created by Macbook on 23/08/23.
//

import Foundation
protocol AddressBaseDelegate{
    func processAllAdress(accesstoken: String,completion: @escaping (_ customer: AddressViewModel?,[AddressViewModel]?) -> Void)
    func  processAddAddress(accesstoken: String, address: String, address2: String, city: String, zip: String, province: String,phone:String,completion: @escaping (String?) -> Void)
    func processEditAddress(accesstoken: String, address: String,address2: String, city: String, zip: String, province: String, id: String,phone:String,completion: @escaping (String?) -> Void)
    var addressList:[AddressViewModel]{get set}
    var defaultAddress : AddressViewModel?{get set}
}
class AddressBaseVM:AddressBaseDelegate{
    var defaultAddress: AddressViewModel?
    var addressList: [AddressViewModel] = []
    
    func processAllAdress(accesstoken: String,completion: @escaping (_ customer: AddressViewModel?,[AddressViewModel]?) -> Void) {
        defaultAddress = nil
        addressList = []
        Client.shared.fetchUserAddresses(accesstoken: AccountController.shared.accessToken) { [self]defaultAddress,AllAddress   in
          if let address = AllAddress{
            self.addressList = address
            
          }
          if let defaultAddress = defaultAddress{
            self.defaultAddress = defaultAddress
          }
            
            if let index = addressList.firstIndex(where: { $0.id == defaultAddress!.id }) {
                addressList.remove(at: index)
            }
            completion( self.defaultAddress,addressList)
        }
    }
    
    func processAddAddress(accesstoken: String, address: String, address2: String, city: String, zip: String, province: String,phone:String,completion: @escaping (String?) -> Void){
        Client.shared.addUserAddress(accesstoken: accesstoken, address: address, address2: address2, city: city, zip: zip, province: province,phone:phone ){ address in
            if let address = address?.customerAddressCreate?.customerAddress{
                completion(nil)
            }
            
            if let error = address?.customerAddressCreate?.customerUserErrors{
                if error.first?.message != nil{
                    completion(error.first?.message)
                }
            }
        }
    }
    
    func processEditAddress(accesstoken: String, address: String,address2: String, city: String, zip: String, province: String, id: String,phone:String,completion: @escaping (String?) -> Void){
        Client.shared.updateUserAddress(accesstoken: accesstoken, address: address, address2: address2, city: city, zip: zip, province: province, id: id, phone: phone){ address in
            if let address = address?.customerAddressUpdate?.customerAddress{
                completion(nil)
            }
            if let error = address?.customerAddressUpdate?.customerUserErrors{
                if error.first?.message != nil{
                    completion(error.first?.message)
                }
            }
        }
    }
}

