//
//  ProductCollectionViewCell.swift
//  Storefront
//
//  Created by Macbook on 28/07/23.
//  Copyright © 2023 Shopify Inc. All rights reserved.
//

import UIKit
import Kingfisher
import Lottie

protocol CollectionsCellDelegate: AnyObject {
    func cells(_ collectionCell: CatogoryCollectionViewCell, didRequestProductsIn collection: CollectionViewModel, after product: ProductViewModel)
    func cells(_ collectionCell: CatogoryCollectionViewCell, didSelectProduct product: ProductViewModel)
}

protocol wishlistUpdateDelegate{
    func updateWishlist(flag:Bool,reFlag:Bool)
}

class ProductCollectionViewCell: UICollectionViewCell {
    typealias ViewModelType = ProductViewModel
    @IBOutlet weak var productImage:UIImageView!
    @IBOutlet weak var lblPrice:UILabel!
    @IBOutlet weak var lblTitle:UILabel!
   // @IBOutlet weak var lblinfo:UILabel!
    @IBOutlet weak var btnAddWIshList: UIButton!
    var delegate:wishlistUpdateDelegate!
    var product: ProductViewModel?
    @IBOutlet weak var animationView:UIView?
    var waveView: LottieAnimationView?
    func configureFrom(_ viewModel: ProductViewModel,flagWishlist:Bool) {
        self.product = viewModel
       // self.lblinfo.attributedText = viewModel.productDtl?.summary.convertToAttributedFromHTML()
        self.lblTitle.text = viewModel.productDtl?.title
        self.lblPrice.attributedText = viewModel.productDtl?.variant?.priceStringProductSmall()
        self.productImage.kf.setImage(with: viewModel.productDtl?.images.items.first?.url)
        if flagWishlist{
            btnAddWIshList.isSelected = true
        }
        else {
            btnAddWIshList.isSelected = false
        }
        
        if product?.productDtl?.variant?.priceSale() == true{
           setupAnimation()
           waveView?.play()
        }
      
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    @IBAction func actionAddWishList(_ sender: UIButton) {
        if AccountController.shared.accessToken != nil && WishListController.shared.userId != nil {
            sender.isSelected = !sender.isSelected
            if sender.isSelected
            {
                delegate.updateWishlist(flag: true, reFlag: false)
                createWishList()
            }
            else{
                persistentStorage.Shared.deleteProduct(withProductId: product!.id, forUserId: WishListController.shared.userId!)
                delegate.updateWishlist(flag: true,reFlag: true)
                
            }
        }
        else {
            delegate.updateWishlist(flag: false, reFlag: false)
        }
    }
    
    func createWishList(){
        persistentStorage.Shared.insertProduct(productID:  product!.id, userID: WishListController.shared.userId!)
        FirebaseAnalytics.shared.sendLogEventWishlist( item: product!.id)
    }

    func setupAnimation(){
        let waveViewWidth: CGFloat = 85
           let waveViewHeight: CGFloat = 85
           waveView = LottieAnimationView(name: "sale")
           waveView?.frame = CGRect(x: 0, y: 0, width: waveViewWidth, height: waveViewHeight)
           waveView?.center = CGPoint(x: animationView?.bounds.midX ?? 0, y: animationView?.bounds.midY ?? 0)
        waveView?.contentMode = .scaleAspectFill
        waveView?.loopMode = .loop
        waveView?.animationSpeed = 2.0
        animationView?.addSubview(waveView!)
    }

}

