//
//  HomeViewModel.swift
//  HomeEassy
//
//  Created by Swatantra singh on 10/10/23.
//

import Foundation

protocol HomeViewModelProtocole {
    func fetchCollections()
    var widgets: [Widget]? {get set}
    var apiCallBack: (()-> Void)? {get set}
}

class HomeViewModel: HomeViewModelProtocole {
    var apiCallBack: (() -> Void)?
    var widgets: [Widget]?
    
    
    func fetchCollections() {
        if let path = Bundle.main.path(forResource: "Home", ofType: "json") {
            do {
                let jsonData = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                let decoder = JSONDecoder()
                let jsonResult = try JSONSerialization.jsonObject(with: jsonData, options: .mutableLeaves)
                if let jsonResult=jsonResult as? [String:AnyObject] , let homeData = HomeWidgetData(JSON: jsonResult) {
                    widgets = homeData.widgets
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
                Client.shared.fethCollectionWithId(gId,size:wid.itemSize()) { [weak self] (colle) in
                    guard let self = self else {return}
                    wid.widgetData=colle
                    self.apiCallBack?()
                }
            }
        }
    }
}
