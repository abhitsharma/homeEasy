//
//  EditCartFooter.swift
//  HomeEassy
//
//  Created by Macbook on 22/11/23.
//

import UIKit
protocol UpdateCartBtnFooter{
    func updateBtn(flag:Bool)
}


class EditCartFooter: UITableViewHeaderFooterView {
    @IBOutlet var btnUpdate : UIButton?
    var delegate:UpdateCartBtnFooter!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    @IBAction func actionUpdateBag(){
        delegate.updateBtn(flag:true)
    }
    
}
