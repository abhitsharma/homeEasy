//
//  PRecommendCollectionCell.swift
//  Storefront
//
//  Created by Macbook on 14/08/23.
//  Copyright © 2023 Shopify Inc. All rights reserved.
//

import UIKit
import Kingfisher
class PRecommendCollectionCell: UICollectionViewCell {

    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblPrice: UILabel!
    @IBOutlet weak var imgProduct: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configureFrom(_ obj: ProductObj) {
        self.imgProduct.kf.setImage(with: obj.images.items.first?.url)
        self.lblTitle.text = obj.title
        self.lblPrice.attributedText = obj.variant?.priceStringProductSmall()
    }
}
