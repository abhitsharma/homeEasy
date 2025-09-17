//
//  ProductDescriptionCell.swift
//  HomeEassy
//
//  Created by Macbook on 22/08/23.
//

import UIKit

class ProductDescriptionCell: UITableViewCell {
    @IBOutlet weak var txt:UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    func setObj(obj:NSAttributedString){
        txt.attributedText = obj
    }
}
