//
//  ProductDetailCekk.swift
//  HomeEassy
//
//  Created by Macbook on 21/11/23.
//

import UIKit

class ProductDetailCell: UITableViewHeaderFooterView {
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblPrice: UILabel!
    @IBOutlet weak var lblStock:UILabel!
    var variaints:PageableArray<VariantViewModel>!
    var selectedVarint:VariantViewModel!
    var product:ProductObj!
    var varintId:String?
    var delegate:UpdateCartBtnFooter!
    @IBOutlet weak var lblAvailable:UILabel!
    var selectedIndex:Int = 0
   // @IBOutlet weak var btnQty:UILabel!
    var qty:Int = 1
    var maxQty:Int!
    
    
    func setData(obj:VariantViewModel,qty:Int,product:ProductObj!){
        self.selectedVarint = obj
        lblPrice.attributedText = obj.priceStringProductBig()
        lblTitle.text = product.title
        //self.qty = qty
        //self.maxQty = Int(obj.quantityAvailable)
        //btnQty.text = " Qty: \(qty)"
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
        //let vc = StoryBoardHelper.controller(.category, type: EditQtyVC.self)
    }
    
    @IBAction func btnClose() {
        delegate.updateBtn(flag:false)
    }
}

