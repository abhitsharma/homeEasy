//
//  MenuItemViewModel.swift
//  HomeEassy
//
//  Created by Macbook on 30/10/23.
//

import Foundation
import MobileBuySDK

final class MenuItemViewModel: ViewModel {
    typealias ModelType = Storefront.MenuItem
    
    let model:  ModelType
    
    let title:   String?
    let id:    GraphQL.ID?
    //let items:  [MenuItemViewModel]?
    // ----------------------------------
    //  MARK: - Init -
    //
    required init(from model: ModelType) {
        self.model       = model
        self.title      = model.title
        self.id = model.id
        //self.items = model.viewModel.items
    }
}

extension Storefront.MenuItem: ViewModeling {
    typealias ViewModelType = MenuItemViewModel
}
