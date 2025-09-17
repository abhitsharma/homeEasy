//
//  HomeDataModel.swift
//  HomeEassy
//
//  Created by Swatantra singh on 10/10/23.
//

import Foundation
import UIKit
import MobileBuySDK

let kpaddingForPLPImage:CGFloat = 8
enum WidgetType : String, Codable {
        case banner = "BANNER",
             banner2 = "BANNER2",
         category_1 = "CATEGORY_1",
         category_2 =  "CATEGORY_2",
         category_3 =  "CATEGORY_3",
         spaceStrip = "spaceStrip",
        flashSale = "FLASHSALE",
         flexTile = "flexTile"
    var getCellIdentifier: String? {
        switch self {            
        case .spaceStrip:
            return nil
        case .flashSale:
            return kFlashSellTableCell
            
        default:
            return kBaseWidgetTableCell
        }
    }
}
/*
 // MARK: - Welcome
 struct HomeDataModel: Codable {
 let response: Response?
 }
 
 // MARK: - Response
 struct Response: Codable {
 let status: Int?
 let entity: Entity?
 }
 
 // MARK: - Entity
 struct Entity: Codable {
 let config: Config?
 }
 
 // MARK: - Config
 struct Config: Codable {
 let widgets: [Widget]?
 }
 
 // MARK: - Widget
 struct Widget: Codable {
 let id: String?
 let collectionIds: [String]?
 let label: String?
 let startDatetime, endDatetime: Int?
 let appearance: Appearance?
 let subType: String?
 let divider: Bool?
 let subtitle: String?
 let type: WidgetType?
 var widgetData : [Any]?
 
 func itemWidth() -> CGFloat {
 let screenWidth = UIScreen.width
 let margin = CGFloat((floor(appearance?.itemScreenCount ?? -1) + 1)*kpaddingForPLPImage)
 var width = (screenWidth - margin)/(CGFloat(appearance?.itemScreenCount ?? 1))
 switch self.type {
 case .banner, .spaceStrip:
 width = screenWidth
 default:
 break
 }
 return width
 }
 
 func itemHeight() -> CGFloat {
 var height : CGFloat = 0
 let width = self.itemWidth()
 let screenWidth = UIScreen.width
 switch self.type {
 case .spaceStrip:
 height = 8.0
 default:
 height = width/CGFloat(appearance?.itemScreenCount ?? 1)
 break
 }
 return ceil(height)
 }
 
 func itemSize() -> CGSize {
 return (itemWidth()>0 &&  itemHeight()>0) ?
 CGSize(width: itemWidth(), height: itemHeight()) :
 CGSize.zero
 }
 }
 
 // MARK: - Appearance
 struct Appearance: Codable {
 let width, height: Int?
 let itemScreenCount: Double?
 }
 
 */

import ObjectMapper

class HomeWidgetData : ResponseHelpeer, Mappable{
    var widgets : [Widget]?
    required init?(map: Map){}
    
    func mapping(map: Map) {
        widgets <- map["response.entity.config.widgets"]
    }
}

class Widget: ResponseHelpeer, Mappable {
    var widgetId: String?
    var collectionIds: [String]?
    var label: String?
    var startDatetime, endDatetime: String?
    var widgetSubType: WidgetType?
    var divider: Bool?
    var subtitle: String?
    var widgetType: WidgetType?
    var widgetData : [any ViewModel]?
    var width, height: CGFloat?
    var itemScreenCount: Double?
    var itemAspectRatio : CGFloat? = 1
    
    required init?(map: Map){}
    open func mapping(map: Map) {
        collectionIds <- map["collectionIds"]
        widgetId = stringValue(map: map,key: "id")
        label = stringValue(map: map,key: "label")
        startDatetime = stringValue(map: map,key: "startDatetime")
        endDatetime = stringValue(map: map,key: "endDatetime")
        widgetType  <- map["type"]
        if let date = map.currentValue as? String {
            widgetType=WidgetType(rawValue : date)
        }
        widgetSubType  <- map["subType"]
        if let date = map.currentValue as? String {
            widgetSubType=WidgetType(rawValue : date)
        }
        width <- map["appearance.width"]
        height <- map["appearance.height"]
        itemScreenCount <- map["appearance.itemScreenCount"]
        if let widhtD = width, let heightD = height,widhtD>0.0,heightD>0.0{
            itemAspectRatio = widhtD/heightD
        }
    }
    func itemWidth(_ type: WidgetType? = nil) -> CGFloat {
        let screenWidth = UIScreen.width
        let margin = CGFloat((floor(itemScreenCount ?? -1) + 1)*kpaddingForPLPImage)
        var width = (screenWidth - margin)/(CGFloat(itemScreenCount ?? 1))
        let localType = type ?? widgetType
        switch localType {
        case .banner, .spaceStrip:
            width = screenWidth
        default:
            break
        }
        return width
    }
    
    func itemHeight(_ type: WidgetType? = nil) -> CGFloat {
        let localType = type ?? widgetType
        let screenWidth = UIScreen.width
        var height : CGFloat = 0
        let width = self.itemWidth(widgetSubType)
        switch localType {
        case .flashSale:
          height = width/CGFloat(self.itemAspectRatio ?? 1) + 160
        case .spaceStrip:
            height = 8.0
        default:
            height = width/CGFloat(itemAspectRatio ?? 1)
            break
        }
        return ceil(height)
    }
    
    func itemSize(_ type: WidgetType? = nil) -> CGSize {
        return (itemWidth(type)>0 &&  itemHeight(type)>0) ?
        CGSize(width: itemWidth(type), height: itemHeight(type)) :
        CGSize.zero
    }
    func hasData() -> Bool {
        var returnValue = false
        switch self.widgetType {
        case .spaceStrip:
            returnValue = true
        default:
            returnValue = (widgetData?.count ?? 0) > 0
        }
        return  returnValue
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

