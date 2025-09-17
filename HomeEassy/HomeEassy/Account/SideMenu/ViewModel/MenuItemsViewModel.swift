//
//  MenuViewModel.swift
//  HomeEassy
//
//  Created by Macbook on 02/11/23.
//

import Foundation
import Foundation
protocol MenuViewModelProtocol {
    func fetchCollections()
    var widgets: [MenuItems]? {get set}
    var apiCallBack: (()-> Void)? {get set}
}

class MenuItemsViewModel: MenuViewModelProtocol {
    var widgets: [MenuItems]?
    var apiCallBack: (() -> Void)?
    
    func fetchCollections() {
        if let path = Bundle.main.path(forResource: "MenuCollection", ofType: "json") {
            do {
                let jsonData = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                let decoder = JSONDecoder()
                let jsonResult = try JSONSerialization.jsonObject(with: jsonData, options: .mutableLeaves)
                if let jsonResult=jsonResult as? [String:AnyObject] , let homeData = MenuData(JSON: jsonResult) {
                    widgets = homeData.menuItems
                    fetWidgetDataFixedTemplate()
                }
            } catch {
                
            }
        }
    }
    
    func fetWidgetDataFixedTemplate() {
        for wid in (widgets ?? []) {
            let gId = wid.getGraphIds()
            if gId.isEmpty == false {
                Client.shared.fethMenuCollectionId(gId) { [weak self] colle in
                    guard let self = self else {return}
                    wid.widgetData=colle
                    self.apiCallBack?()
                }
            }
        }
    }
}
