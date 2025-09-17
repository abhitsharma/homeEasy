//
//  MenuViewModel.swift
//  HomeEassy
//
//  Created by Macbook on 30/10/23.
//

import Foundation
import MobileBuySDK

final class MenuViewModel: ViewModel {
    typealias ModelType = Storefront.Menu
    
    let model:  ModelType
    
    let title:   String?
    let id:    GraphQL.ID?
    let items:  [MenuItemViewModel]?
    
    // ----------------------------------
    //  MARK: - Init -
    //
    required init(from model: ModelType) {
        self.model       = model
        self.title      = model.title
        self.id = model.id
        self.items = model.items.viewModels
    }
}

extension Storefront.Menu: ViewModeling {
    typealias ViewModelType = MenuViewModel
}
