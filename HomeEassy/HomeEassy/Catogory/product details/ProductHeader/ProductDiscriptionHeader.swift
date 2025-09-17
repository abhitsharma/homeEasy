//
//  productDiscriptionHeader.swift
//  HomeEassy
//
//  Created by Macbook on 22/08/23.
//

import UIKit

class ProductDiscriptionHeader: UITableViewHeaderFooterView {
    @IBOutlet weak var lblTitle:UILabel!
    @IBOutlet weak var btnOpen:UIButton!
    var flag :Bool!
    var delegate:btnSelected!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    @IBAction func actionExpendCell(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        if sender.isSelected{
            flag = true
        }
        else {
            flag = false
        }
        delegate.Selected(bool: flag)
    }
    
}
