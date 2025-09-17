//
//  FilterHeaderView.swift
//  HomeEassy
//
//  Created by Macbook on 25/08/23.
//

import UIKit
protocol btnSelected{
    func Selected(bool:Bool)
}
class FilterHeaderView: UITableViewHeaderFooterView {
    var delegate:btnSelected!
    @IBOutlet weak var btnExpand: UIButton!
    @IBOutlet weak var lblTitle: UILabel!
    var flag:Bool!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
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
