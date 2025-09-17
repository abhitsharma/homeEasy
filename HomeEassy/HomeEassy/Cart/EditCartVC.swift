//
//  EditCartVC.swift
//  HomeEassy
//
//  Created by Macbook on 08/09/23.
//

import UIKit


class EditCartVC: UIViewController {
    @IBOutlet var increaseQty : UIButton?
    @IBOutlet var decreaseQty : UIButton?
    @IBOutlet var movetoCartButton : UIButton?
    @IBOutlet var lblQty : UILabel?
    @IBOutlet weak var button_Dismiss: UIButton?
    var index:Int!
    var qty:Int!
    var maxQty:Int32!
    var delegate:UpdateCartDelegate!
    var delegateQty:productEditDelegate!
    override func viewDidLoad() {
        super.viewDidLoad()
        lblQty?.text = "\(qty!)"
       
    }
    
    @IBAction func decreaseQuantity() {
        qty = qty - 1
        if qty > 0{
            CartController.shared.decrementAt(index)
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
            CartController.shared.incrementAt(index)
            lblQty?.text = "\(qty!)"
        }
        else{
            qty = qty - 1
            self.view.makeToast("Reach max available quantity")
        }
      
    }
    
    @IBAction func addToCart() {
        delegate.UpdateCart(flag: true, favFlag: false, index: index)
        //delegateQty.edit(qty: self.qty)
        dismiss(animated: true)
        
    }
}

//extension EditCartVC:UITableViewDelegate,UITableViewDataSource{
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return 1
//    }
//    
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        return  UITableViewCell()
//    }
//    
//    
//}
