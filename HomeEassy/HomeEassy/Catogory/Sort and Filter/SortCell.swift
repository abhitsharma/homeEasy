//
//  SortCell.swift
//  HomeEassy
//
//  Created by Macbook on 21/08/23.
//

import UIKit

class SortCell: UITableViewCell {
    @IBOutlet weak var lblSortTitle:UILabel!
    @IBOutlet weak var btnSelSort:UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
