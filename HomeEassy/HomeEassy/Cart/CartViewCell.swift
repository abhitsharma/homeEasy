//
//  CartViewCell.swift
//  HomeEassy
//
//  Created by Macbook on 05/09/23.
//

import UIKit
import Kingfisher
protocol UpdateCartDelegate{
    func UpdateCart(flag:Bool,favFlag:Bool,index:Int?)
    func EditCartItem(cartItem:CartItemViewModel!,indexCart:Int!,qty:Int!,maxQty:Int32)
    func EditProduct(productId:String,index:Int)
}


class CartViewCell: UITableViewCell {
    @IBOutlet weak var lblPrice:UILabel!
    @IBOutlet weak var btnWishlist: UIButton!
    @IBOutlet weak var lblTitle:UILabel!
    @IBOutlet weak var lblVarintTitle:UILabel!
    @IBOutlet weak var imageProduct:UIImageView!
    @IBOutlet weak var BtnQty:UIButton!
    @IBOutlet weak var viewProduct:UIView!
    @IBOutlet weak var viewProductEmpty:UIView!
    @IBOutlet weak var btnRemove:UIButton!
    var indexCart:Int!
    var delegate:UpdateCartDelegate!
    var cartItem:CartItemViewModel!
    var qty:Int!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setData(obj:CartItemViewModel,index:Int,flagWishlist:Bool){
        self.cartItem = obj
        lblTitle.text = obj.title
        lblPrice.attributedText = obj.priceStringProduct()
        lblVarintTitle.text = obj.model.title
        imageProduct.kf.setImage(with: obj.imgUrl)
        let qty = CartController.shared.items.filter{$0.variantId==self.cartItem.id}.first?.quantity ?? 1
        self.qty = qty
        BtnQty.setTitle("Qty: \(qty)", for: .normal)
        BtnQty.setTitle("Qty: \(qty)", for: .selected)
        print(cartItem.qtyAvailable!)
        self.indexCart = index
        if flagWishlist{
            btnWishlist.isSelected = true
        }
        else {
            btnWishlist.isSelected = false
        }
        if cartItem.currentlyNotInStock || cartItem.qtyAvailable! < 1{
            viewProductEmpty.isHidden = false
            viewProduct.isHidden = true
        }
        else{
            viewProductEmpty.isHidden = true
            viewProduct.isHidden = false
        }
        
    }
    
    @IBAction func actionRemove(_ sender: Any) {
    
        self.delegate.UpdateCart(flag: true,favFlag:false, index:self.indexCart)
    }
    
    @IBAction func actionEdit(_ sender: Any) {
        delegate.EditProduct(productId: cartItem.productID!, index: indexCart)
    }
    
    @IBAction func actionRemoveQtyEmty(_ sender: Any) {
        self.delegate.UpdateCart(flag: true,favFlag:false, index: self.indexCart)
    }
    
    @IBAction func actionWishlist(_ sender: UIButton) {
        if AccountController.shared.accessToken != nil && WishListController.shared.userId != nil {
            sender.isSelected = !sender.isSelected
            if sender.isSelected
            {
                //makeToast("Added To Wishlist")
                createWishList()
                self.delegate.UpdateCart(flag: false,favFlag:true, index: self.indexCart)
            }
            else{
                persistentStorage.Shared.deleteProduct(withProductId: cartItem.productID!, forUserId: WishListController.shared.userId!)
                //makeToast("Removed from Wishlist")
                self.delegate.UpdateCart(flag: false,favFlag:true, index: self.indexCart)
            }
        }
        else {
            makeToast("Please login first")
        }
        
    }
    
    func createWishList(){
        persistentStorage.Shared.insertProduct(productID:  self.cartItem.productID!, userID: WishListController.shared.userId!)
    
    }
    
    @IBAction func actionEditCart(_ sender: Any) {
        delegate.EditCartItem(cartItem: self.cartItem, indexCart: indexCart, qty: qty, maxQty: cartItem.qtyAvailable!)
    }
    
}
