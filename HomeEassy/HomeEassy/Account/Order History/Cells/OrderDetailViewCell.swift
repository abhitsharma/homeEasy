//
//  OrderDetailViewCell.swift
//  HomeEassy
//
//  Created by Macbook on 12/09/23.
//

import UIKit

class OrderDetailViewCell: UITableViewCell {
    @IBOutlet weak var lblPrice:UILabel!
    @IBOutlet weak var lblTitle:UILabel!
    @IBOutlet weak var imageProduct:UIImageView!
    @IBOutlet weak var lblQty:UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func setData(obj:OrderLineItemViewModel){
        //self.cartItem = obj
        lblTitle.text = obj.title
        lblQty.text = "QTY : \(obj.quantity)"
        lblPrice.text = "Total Amount : \(Currency.stringFrom(obj.totalPrice!))"
        imageProduct.kf.setImage(with: obj.imgUrl)
     
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
