//
//  productHighlightCell.swift
//  Storefront
//
//  Created by Macbook on 14/08/23.
//  Copyright © 2023 Shopify Inc. All rights reserved.
//

import UIKit
import MobileBuySDK
protocol selCollection{
    func selProduct(id:String)
    func selHighLight(id:String)
}

let KPRecommendCollectionCell = "PRecommendCollectionCell"

class ProductHighlightCell: UITableViewCell {
    @IBOutlet weak var recommendCollection:UICollectionView!
    var recommendedProduct:[ProductObj]!
    var productId : ProductObj?
    var delegate:selCollection?
    let productDetailVM:ProductDetailVMDelegate = ProductDetailVM()
    override func awakeFromNib() {
        super.awakeFromNib()
       
        self.recommendCollection.register(UINib.init(nibName: KPRecommendCollectionCell, bundle: nil), forCellWithReuseIdentifier: KPRecommendCollectionCell)
        recommendCollection.reloadData()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        

    }
    
    func fetchRecommendations(obj:ProductObj) {
        productDetailVM.fetchRecommendations(id: obj.id){ products in
            if products != nil {
                self.recommendedProduct = products
                self.recommendCollection.reloadData()
            }
        }
    }
    
}

extension ProductHighlightCell:UICollectionViewDelegate,UICollectionViewDataSource{
    func numberOfSections(in collectionView: UICollectionView) -> Int {
      return 1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return recommendedProduct?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = recommendCollection.dequeueReusableCell(withReuseIdentifier: KPRecommendCollectionCell, for: indexPath) as! PRecommendCollectionCell
        let obj = recommendedProduct[indexPath.row]
        cell.configureFrom(obj)
        cell.layer.transform = CATransform3DMakeScale(0.5,0.5,1)
                        UIView.animate(withDuration: 0.3, animations: {
                               cell.layer.transform = CATransform3DMakeScale(1.05,1.05,1)
                               },completion: { finished in
                                   UIView.animate(withDuration: 0.3, animations: {
                                       cell.layer.transform = CATransform3DMakeScale(1,1,1)
                                   })
                           })
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let obj = recommendedProduct[indexPath.row]
        delegate?.selProduct(id: obj.id)
    }
    
}


extension ProductHighlightCell: UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 168, height: 262)
    }
}
