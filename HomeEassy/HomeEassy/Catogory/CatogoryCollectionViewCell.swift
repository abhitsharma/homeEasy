//
//  CatogoryCollectionViewCell.swift
//  Storefront
//
//  Created by Macbook on 27/07/23.
//  Copyright © 2023 Shopify Inc. All rights reserved.
//

import UIKit
import Kingfisher
protocol CatogoryCellDelegate: AnyObject {
    func cells(_ collectionCell: CatogoryCollectionViewCell, didRequestProductsIn collection: CollectionViewModel, after product: ProductViewModel)
    func cells(_ collectionCell: CatogoryCollectionViewCell, didSelectProduct product: ProductViewModel)
}

class CatogoryCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var catagoryImg:UIImageView!
    @IBOutlet weak var lbltitle:UILabel!
    @IBOutlet weak var cellView:UIView!
    var viewModel: CollectionViewModel?
    weak var delegate: CatogoryCellDelegate?
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Initialization code
    }
    
    func shadow(){
        self.layer.masksToBounds = false
                self.layer.shadowColor =  UIColor.gray.cgColor
                self.layer.shadowOffset = CGSize(width: 0, height: 1)
        self.layer.shadowRadius = 1.0
        self.layer.shadowOpacity = 2.0
      //  cellView.layer.cornerRadius = 19.0
    }
    
    func setData(title:String,imageUrl:URL){
       
    }
    
    func configureFrom(_ viewModel: CollectionViewModel) {
        self.catagoryImg.kf.setImage(with: viewModel.imageURL)
        self.lbltitle.text = viewModel.title
    }
    
}
