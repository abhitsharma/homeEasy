//
//  WishListViewCell.swift
//  HomeEassy
//
//  Created by Macbook on 01/09/23.
//

import UIKit
import Kingfisher
protocol WishListDelegate{
    func removeProduct(productId:String)
    func addedCart(product:ProductObj)
}

class WishListViewCell: UITableViewCell {
    var delegate:WishListDelegate!
    @IBOutlet weak var btnClose: UIButton!
    @IBOutlet weak var btnAddCart: UIButton!
    @IBOutlet weak var lblPrice: UILabel!
    @IBOutlet weak var imageProduct: UIImageView!
    @IBOutlet weak var lblAvailability:UILabel!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var view:UIView!
    var product: ProductObj!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setData(obj:ProductObj,addedCartFlag:Bool){
        self.view.backgroundColor = UIColor(named: "white")
        self.view.cornerRadius = 5.0
        self.imageProduct.cornerRadius = 5.0
        self.lblTitle.text = obj.title
        self.lblPrice.text = obj.price
        self.product = obj
        if obj.availableForSale{
            self.lblAvailability.text = "In Stock"
            self.lblAvailability.textColor = UIColor(named: "CustomBlack")
            btnAddCart.alpha = 1.0
        }
        else{
            self.lblAvailability.text = "Not In Stock"
            self.lblAvailability.textColor = UIColor(named: "CustomRed")
            btnAddCart.alpha = 0.8
        }
        self.imageProduct.kf.setImage(with: obj.images.items.first?.url)
    }
    
    @IBAction func actionDelete(_ sender: Any) {
        delegate.removeProduct(productId: self.product.id)
    }
    
    @IBAction func actionAddCart(_ sender: Any) {
        delegate.addedCart(product: product)
    }
    
}
