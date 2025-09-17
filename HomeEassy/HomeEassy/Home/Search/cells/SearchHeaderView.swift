//
//  SearchHeaderView.swift
//  HomeEassy
//
//  Created by Macbook on 15/09/23.
//

import UIKit

protocol UpdateSearchHistory{
    func updateSearch()
}

class SearchHeaderView: UITableViewHeaderFooterView {
    @IBOutlet weak var lblHeader:UILabel!
    @IBOutlet weak var btnClaer:UIButton!
    var delegate:UpdateSearchHistory!
    override func awakeFromNib() {
        super.awakeFromNib()
       
    }
    
    @IBAction func actionClear(_ sender: Any){
        persistentStorage.Shared.deleteAllData(predicate:NSPredicate(format: "istrnding == %d", false))
        delegate.updateSearch()
    }
 
}
