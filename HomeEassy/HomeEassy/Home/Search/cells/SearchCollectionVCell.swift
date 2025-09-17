//
//  SearchCollectionVCell.swift
//  HomeEassy
//
//  Created by Macbook on 15/09/23.
//

import UIKit


class SearchCollectionVCell: UICollectionViewCell {

    @IBOutlet weak var lblSearch:UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func setData(obj:String){
        lblSearch.text = obj
    }
}
