//
//  OrdersViewCell.swift
//  HomeEassy
//
//  Created by Macbook on 12/09/23.
//

import UIKit
import Kingfisher

class OrdersViewCell: UITableViewCell {
    @IBOutlet weak var imgProduct:UIImageView!
    @IBOutlet weak var lblId:UILabel!
    @IBOutlet weak var lblStatus:UILabel!
    @IBOutlet weak var lblPaid:UILabel!
    @IBOutlet weak var lblPrice:UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setObj(obj:OrderViewModel){
        let dateFormatter = DateFormatters.sharedManager.formatterForStrings(dateFormat: "MMMM dd,yyyy")
        lblId.text = "Order ID : \(obj.number)  (\(dateFormatter.string(from: obj.processedAt)))"
        imgProduct.kf.setImage(with: obj.lineItems[0].imgUrl ?? obj.lineItems[1].imgUrl )
        lblStatus.text = obj.fulfillmentStatus
        lblPaid.text = "Payment Status : \(obj.financialStatus ?? "")"
        lblPrice.text = "Total Amount : \(Currency.stringFrom(obj.totalPrice))"
    }
}
