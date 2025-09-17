//
//  SearchHistory+CoreDataProperties.swift
//  HomeEassy
//
//  Created by Macbook on 19/09/23.
//
//

import Foundation
import CoreData


extension SearchHistory {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<SearchHistory> {
        return NSFetchRequest<SearchHistory>(entityName: "SearchHistory")
    }

    @NSManaged public var istrnding: Bool
    @NSManaged public var lastupdateDate: Date?
    @NSManaged public var querySearch: String?

}

extension SearchHistory : Identifiable {

}
