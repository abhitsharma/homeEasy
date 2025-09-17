//
//  CartViewModel.swift
//  HomeEassy
//
//  Created by Macbook on 14/09/23.
//

import Foundation
import WebKit
typealias  BagCompiltation = (_ type:String)->()
protocol CartViewModelDelegate{
    var selectItems : BagCompiltation!{get set}
    var isBagDetailSelected:Bool{get set}
    var isAddSelected:Bool{get set}
    var myCart:[CartItemViewModel]{get set}
    var checkOut:CheckoutViewModel?{get set}
    var subtotal: Decimal{get}
    func fetchCartItems(_with compilation:@escaping (_ type:String)->())
    static func gettingAllCartSubTotalCel(myCartData:Decimal) -> [[String:String]]
    func proceedToCheckOutAction(completion: @escaping (URL?) -> Void)
}
extension WKWebView {
    class func clean() {
        guard #available(iOS 9.0, *) else {return}

        HTTPCookieStorage.shared.removeCookies(since: Date.distantPast)

        WKWebsiteDataStore.default().fetchDataRecords(ofTypes: WKWebsiteDataStore.allWebsiteDataTypes()) { records in
            records.forEach { record in
                WKWebsiteDataStore.default().removeData(ofTypes: record.dataTypes, for: [record], completionHandler: {})
                #if DEBUG
                    print("WKWebsiteDataStore record deleted:", record)
                #endif
            }
        }
    }
}

class CartViewModel: CartViewModelDelegate {
    var selectItems : BagCompiltation!
    var isBagDetailSelected=false
    var isAddSelected=true
    var myCart = [CartItemViewModel]()
    var checkOut:CheckoutViewModel?
    var subtotal: Decimal {
        let collection=CartController.shared.items
        return self.myCart.reduce(0.0){
            let idD=$1.id
            let item=collection.filter{$0.variantId==idD}.first
            let value=$1.price * Decimal(item?.quantity ?? 1)
            return  $0 + value
        }}
    
    func fetchCartItems(_with compilation:@escaping (_ type:String)->()) {
        selectItems=compilation
        let collection=CartController.shared.items
        if collection.count>0{
            let arr=collection.compactMap{$0.variantId.getGraphId()}
            Client.shared.fethProductVarintData(arr) { productsd in
                self.myCart=productsd
                self.myCart.filter{$0.qtyAvailable!>0}
                self.selectItems("0")
            }
        }
        else{
            myCart.removeAll()
            self.selectItems("0")
        }
        
    }
    
    
    static func gettingAllCartSubTotalCel(myCartData:Decimal) -> [[String:String]] {
        var arrCarSubTotal=[[String:String]]()
        let myCartData =  Currency.stringFrom(myCartData)
        var BagTotal,TotalPayment,ShippinCharge: [String:String]?
        BagTotal=["lbl":kBagtotal,"amount":( myCartData)]
        TotalPayment=["lbl":kTotalPay,"amount":( myCartData)]
        ShippinCharge=["lbl":kShipingCharg,"amount":"Calculated at checkout"]
        if let dict=BagTotal{
            arrCarSubTotal.append(dict)
        }
        if let dict=ShippinCharge{
            arrCarSubTotal.append(dict)
        }
        if let dict=TotalPayment{
            arrCarSubTotal.append(dict)
        }
        return arrCarSubTotal
    }
    
    func proceedToCheckOutAction(completion: @escaping (URL?) -> Void){
        let cartItems = CartController.shared.items
        WKWebView.clean()
        Client.shared.createCheckout(with: cartItems){ checkout in
            guard let checkout = checkout else {
                print("Failed to create checkout.")
                completion(nil)
                return
            }
            self.checkOut = checkout
            completion(checkout.webURL)
        }
        
    }
}
