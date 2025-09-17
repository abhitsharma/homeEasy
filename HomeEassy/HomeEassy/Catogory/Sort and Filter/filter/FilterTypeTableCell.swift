//
//  FilterTypeTableCell.swift
//  HomeEassy
//
//  Created by Macbook on 23/11/23.
//

import UIKit

class FilterTypeTableCell: UITableViewCell {
    @IBOutlet weak var lblFilter:UILabel!
    @IBOutlet weak var lblCount:UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
