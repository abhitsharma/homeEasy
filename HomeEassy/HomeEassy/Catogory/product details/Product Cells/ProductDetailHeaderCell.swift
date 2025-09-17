//
//  ProductDetailHeaderCell.swift
//  Storefront
//
//  Created by Macbook on 14/08/23.
//  Copyright © 2023 Shopify Inc. All rights reserved.
//

import UIKit

protocol ProductCheckoutDelegate: AnyObject {
    func productAddCart(varintId:String)
}

protocol ProductEditQtyDelegate: AnyObject {
    func editProduct(qty:Int,max:Int)
}


class ProductDetailHeaderCell: UITableViewHeaderFooterView {
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblPrice: UILabel!
    @IBOutlet weak var collectionView:UICollectionView!
    @IBOutlet weak var lblStock:UILabel!
    var delegate:selCollection!
    weak var delegateCheckout: ProductCheckoutDelegate?
    weak var delegateQty:ProductEditQtyDelegate?
    var variaints:PageableArray<VariantViewModel>!
    var selectedVarint:VariantViewModel!
    var product:ProductObj!
    var varintId:String?
    @IBOutlet weak var lblAvailable:UILabel!
    var selectedIndex:Int = 0
    @IBOutlet weak var btnQty:UILabel!
    var qty:Int = 1
    var maxQty:Int!
    override func awakeFromNib() {
        super.awakeFromNib()
        let vc = StoryBoardHelper.controller(.category, type: EditQtyVC.self)
        vc?.delegateQty = self
        
    }
    
    func setData(obj:VariantViewModel,qty:Int,product:ProductObj!){
        self.selectedVarint = obj
        lblPrice.attributedText = obj.priceStringProductBig()
        lblTitle.text = product.title
        self.qty = qty
        self.maxQty = Int(obj.quantityAvailable)
        btnQty.text = " Qty: \(qty)"
        if obj.quantityAvailable < 1{
            let avialbleString = "Out of Stock"
            let attributedMsg = NSMutableAttributedString(string: avialbleString)
            attributedMsg.addAttribute(.foregroundColor,
                                       value:UIColor(named: "CustomRed")!,
                                       range: NSRange(location: 0, length: avialbleString.count))
            lblAvailable.attributedText = attributedMsg
        }
        else if obj.quantityAvailable < 5 {
            let avialbleString = "Hurry Up...only \(obj.quantityAvailable) left"
            let attributedMsg = NSMutableAttributedString(string: avialbleString)
            attributedMsg.addAttribute(.foregroundColor,
                                       value:UIColor(named: "CustomRed")!,
                                       range: NSRange(location: 0, length: avialbleString.count))
            lblAvailable.attributedText = attributedMsg
        }
        else {
            let avialbleString = "In Stock"
            let attributedMsg = NSMutableAttributedString(string: avialbleString)
            attributedMsg.addAttribute(.foregroundColor,
                                       value:UIColor(named: "black")!,
                                       range: NSRange(location: 0, length: avialbleString.count))
            lblAvailable.attributedText = attributedMsg
          
        }
        self.product = product
        let vc = StoryBoardHelper.controller(.category, type: EditQtyVC.self)
        vc?.delegateQty = self
    }
    
    @IBAction func actionAddQty(_ sender: Any) {
        self.delegateQty?.editProduct(qty: qty, max: maxQty)
    }
    
    @IBAction func actionAddToCart(_ sender: Any) {
        if varintId != nil && varintId != ""{
            let item = CartItem(product: self.product, variantId: varintId!,quantity: qty)
            CartController.shared.add(item)
        }
        else {
            self.makeToast("Please Select Varient")
        }
    }
}


extension ProductDetailHeaderCell:productEditDelegate{
    func edit(qty: Int) {
        btnQty.text = "Qty: \(qty)"
        self.qty = qty
        
    }
    
}
