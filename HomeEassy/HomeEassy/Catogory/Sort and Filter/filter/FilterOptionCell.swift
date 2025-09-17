//
//  FilterTableCell.swift
//  HomeEassy
//
//  Created by Macbook on 23/11/23.
//

import UIKit

class FilterOptionCell: UITableViewCell {
    @IBOutlet weak var lblfilter:UILabel?
    @IBOutlet weak var btnSel:UIButton?
    var flag:Bool?
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
