//
//  TotalFooterView.swift
//  HomeEassy
//
//  Created by Macbook on 08/09/23.
//

import UIKit

protocol proceedCartDelegate{
    func createCart()
}

class TotalFooterView: UITableViewHeaderFooterView {
    @IBOutlet weak var btnProceed:UIButton!
    @IBOutlet weak var lblBagTotal:UILabel!
    @IBOutlet weak var lblTotalAmount:UILabel!
    @IBOutlet weak var convenienceFees:UILabel!
    var proccedCartFlag:Bool!
    var delegate:proceedCartDelegate!
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func setData(cartSubTotal:[[String:String]],proccedCartFlag:Bool){
        for dict in cartSubTotal {
                if let lbl = dict["lbl"], let amount = dict["amount"] {
                    switch lbl {
                    case kBagtotal:
                        lblBagTotal.text = amount
                    case kTotalPay:
                        lblTotalAmount.text = amount
                    case kShipingCharg:
                        convenienceFees.text = amount
                    default:
                        break
                    }
                }
            }
        self.proccedCartFlag = proccedCartFlag
        if proccedCartFlag{
            btnProceed.alpha = 1.0
        }
        else{
            btnProceed.alpha = 0.8
        }
        
    }
    
    @IBAction func actionCreateCheckout(_ sender: Any) {
        if proccedCartFlag{
            delegate.createCart()
        }
        else{
            self.makeToast("Please remove or edit the product that is unavailable")
        }
    }
    
}
