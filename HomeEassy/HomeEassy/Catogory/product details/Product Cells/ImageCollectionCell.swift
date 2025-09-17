//
//  ImageCollectionCell.swift
//  HomeEassy
//
//  Created by Macbook on 05/09/23.
//

import UIKit
import Kingfisher
class ImageCollectionCell: UICollectionViewCell {
    @IBOutlet weak var imageProduct:UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func setData(url:String){
        let url = URL(string: url)
        imageProduct.kf.setImage(with: url)
        imageProduct.contentMode = .scaleToFill
    }
}
