//
//  QtyTableViewCell.swift
//  HomeEassy
//
//  Created by Macbook on 21/11/23.
//

import UIKit

protocol EditQtyCartProtocol{
    func updateQTY(qty:Int)
}

class QtyTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    @IBOutlet var increaseQty : UIButton?
    @IBOutlet var decreaseQty : UIButton?
    @IBOutlet var lblQty : UILabel?
    var index:Int!
    var qty:Int!
    var maxQty:Int32!
    var delegate:EditQtyCartProtocol!

    @IBAction func decreaseQuantity() {
        if qty > 1{
            qty = qty - 1
            lblQty?.text = "\(qty!)"
            delegate.updateQTY(qty: qty)
        }
        else{
            self.makeToast("Reach min quantity")
        }
    }
    
    @IBAction func increaseQuantity() {
        if qty < maxQty{
            qty = qty + 1
            lblQty?.text = "\(qty!)"
            delegate.updateQTY(qty: qty)
        }
        else{
            self.makeToast("Reach max available quantity")
        }
      
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
