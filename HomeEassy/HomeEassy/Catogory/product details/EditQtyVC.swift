//
//  EditQtyVC.swift
//  HomeEassy
//
//  Created by Macbook on 21/09/23.
//

import UIKit
protocol productEditDelegate{
    func edit(qty:Int)
}

class EditQtyVC: UIViewController {

    @IBOutlet var increaseQty : UIButton?
    @IBOutlet var decreaseQty : UIButton?
    @IBOutlet var movetoCartButton : UIButton?
    @IBOutlet var lblQty : UILabel?
    @IBOutlet weak var button_Dismiss: UIButton?
    var index:Int!
    var qty:Int!
    var maxQty:Int32!
    var delegateQty:productEditDelegate!
    override func viewDidLoad() {
        super.viewDidLoad()
        lblQty?.text = "\(qty!)"
       
    }
    
    @IBAction func decreaseQuantity() {
        qty = qty - 1
        if qty > 0{
            lblQty?.text = "\(qty!)"
        }
        else{
            qty = qty + 1
            self.view.makeToast("Reach min quantity")
        }
    }
    
    @IBAction func increaseQuantity() {
        qty = qty + 1
        if qty <= maxQty{
            lblQty?.text = "\(qty!)"
        }
        else{
            qty = qty - 1
            self.view.makeToast("Reach max available quantity")
        }
      
    }
    
    @IBAction func addToCart() {
        delegateQty.edit(qty: self.qty)
        dismiss(animated: true)
    }

}

