//
//  WishListController.swift
//  HomeEassy
//
//  Created by Macbook on 06/09/23.
//

import Foundation
class WishListController {
static let shared = WishListController()

private(set) var userId: String?
private let defaults = UserDefaults.standard

// ----------------------------------
//  MARK: - Init -
//
private init() {
    self.loadToken()
}


func saveUser(userId: String) {
    self.userId = userId
    self.defaults.set(userId, forKey: AppUserDefault.USER_ID)
    self.defaults.synchronize()
}



func deleteUserId() {
    self.userId = nil
    self.defaults.removeObject(forKey: AppUserDefault.USER_ID)
    self.defaults.synchronize()
}

@discardableResult
func loadToken() -> String? {
    self.userId = self.defaults.string(forKey: AppUserDefault.USER_ID)
    return self.userId
}
}
