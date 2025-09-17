//
//  OrderDetailHeader.swift
//  HomeEassy
//
//  Created by Macbook on 12/09/23.
//

import UIKit
protocol trackOrderDelegate{
    func trackOrder(urlTrack:String,title:String)
}

class OrderDetailHeader: UITableViewHeaderFooterView {
    @IBOutlet weak var lblName:UILabel!
    @IBOutlet weak var lblAdrress:UILabel!
    @IBOutlet weak var lblPrice:UILabel!
    @IBOutlet weak var lblShipping:UILabel!
    @IBOutlet weak var lblTax:UILabel!
    @IBOutlet weak var lblTotalPrice:UILabel!
    @IBOutlet weak var btnTrack:UIButton!
    var delegate:trackOrderDelegate!
    var urlTrack:String? = nil
    override func awakeFromNib() {
        super.awakeFromNib()
    }
   
 func setObj(obj:OrderViewModel!)
    {
        lblName.text = "\(obj.shippingAddress?.firstName ?? "") \(obj.shippingAddress?.lastName ?? "")"
        lblAdrress.text = "Delevired At : \(obj.shippingAddress?.address1 ?? ""),\(obj.shippingAddress?.city ?? ""),\(obj.shippingAddress?.province ?? ""),\(obj.shippingAddress?.zip ?? "")"
        lblPrice.text = Currency.stringFrom(obj.subTotalPrice!)
        let shipping = Currency.stringFrom(obj.shippingTotalPrice)
        if  shipping != ""{
            lblShipping.text = shipping
        }
        else {
            lblShipping.text = "FREE"
        }
        lblTax.text = Currency.stringFrom(obj.taxTotalPrice!)
        lblTotalPrice.text = Currency.stringFrom(obj.totalPrice)
        
        if obj.trackingInfoUrl != nil || obj.trackingInfoUrl != URL(string: "") {
            btnTrack.isHidden = false
            urlTrack = obj.trackingInfoUrl?.absoluteString
        }
        else{
            btnTrack.isHidden = true
        }
    }
    
    @IBAction func actionTrackOrder(_ sender: Any) {
        delegate.trackOrder(urlTrack: urlTrack!, title: "Track Order")
    }
    
}
