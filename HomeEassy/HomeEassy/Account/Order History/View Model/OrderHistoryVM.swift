//
//  OrderHistoryVM.swift
//  HomeEassy
//
//  Created by Macbook on 13/10/23.
//

import Foundation
protocol OrderHistoryVMDelgate {
    var orders : PageableArray<OrderViewModel>? { get set }
    func fetchOrderHistory(completion: @escaping (PageableArray<OrderViewModel>?) -> Void)
}
class OrderHistoryVM:OrderHistoryVMDelgate{
    var orders: PageableArray<OrderViewModel>?
    func fetchOrderHistory(completion: @escaping (PageableArray<OrderViewModel>?) -> Void) {
        Client.shared.fetchCustomerAndOrders(accessToken: AccountController.shared.accessToken!){ [self]container in
            if let container = container {
                orders = container
                completion(orders)
            }
            else{
                completion(nil)
            }
        }
        
    }
}
