//
//  ProfileTableViewCell.swift
//  Storefront
//
//  Created by Macbook on 08/08/23.
//  Copyright © 2023 Shopify Inc. All rights reserved.
//

import UIKit

class ProfileTableViewCell: UITableViewCell {
    @IBOutlet weak var title:UILabel!
    @IBOutlet weak var img:UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
}
