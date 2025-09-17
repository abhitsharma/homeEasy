//
//  MenuItemModel.swift
//  HomeEassy
//
//  Created by Macbook on 02/11/23.
//

import Foundation
import ObjectMapper
import MobileBuySDK

class MenuData : ResponseHelpeer, Mappable{
    var menuItems : [MenuItems]?
    required init?(map: Map){}
    
    func mapping(map: Map) {
        menuItems <- map["response.entity.config.menus"]
    }
}

class MenuItems: ResponseHelpeer, Mappable {
    var widgetId: String?
    var collectionIds: [String]?
    var widgetData : [CollectionModel]?
    required init?(map: Map){}
    open func mapping(map: Map) {
        collectionIds <- map["collectionIds"]
        widgetId = stringValue(map: map,key: "id")
    }
   
    
    func getGraphIds() -> [GraphQL.ID] {
        if let col=collectionIds{
            return col.compactMap{$0.getGraphId()}
        }
        else{
            return [GraphQL.ID]()
        }
    }
}

