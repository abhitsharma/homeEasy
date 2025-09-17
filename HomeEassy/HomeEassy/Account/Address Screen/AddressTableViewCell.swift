//
//  AddressTableViewCell.swift
//  Storefront
//
//  Created by Macbook on 08/08/23.
//  Copyright © 2023 Shopify Inc. All rights reserved.
//

import UIKit
protocol ReloadTable{
    func getData(flag:Bool,delete:Bool,id:String)
}

protocol selectAction {
    func NextController(flag:Bool,address:AddressViewModel)
}

class AddressTableViewCell: UITableViewCell {
    var Delegate:ReloadTable?
    var DelegateController:selectAction?
    @IBOutlet weak var view: UIView!
    @IBOutlet weak var lblPhone: UILabel!
    @IBOutlet weak var lblAddress: UILabel!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblDefault:UILabel!
    @IBOutlet weak var btnMarkAsDefault:UIButton!
      var address:AddressViewModel!
    var id:String!
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    func setupCell(obj:AddressViewModel){
        lblName.text = obj.firstName ?? "" + " " + obj.lastName!
        lblAddress.text = "\(obj.address1 ?? " ") \(obj.address2 ?? ""),\(obj.city ?? " "),\(obj.province ?? " ") , India - \(obj.zip ?? " ")"
        lblPhone.text = "Phone : \(obj.phone ?? "")"
        view.layer.cornerRadius = 10.0
        id = obj.model.id.rawValue
        address = obj
        let infoString = "Phone : \(obj.phone ?? "")"
        let temString = "\(obj.phone ?? "")"
        let attributedMsg = NSMutableAttributedString(string: infoString)
        attributedMsg.addAttribute(.font,
                                   value:UIFont(name: NiveauGrotesk.Medium.rawValue, size: 12)!,
                                   range: NSRange(location: 0, length: infoString.count))
        attributedMsg.addAttribute(.font,
                                   value:UIFont(name: NiveauGrotesk.regular.rawValue, size: 12)!,
                                   range: (infoString as NSString).range(of: temString))
        self.lblPhone?.attributedText = attributedMsg
    }
    
    @IBAction func actionDefault(_ sender: Any) {
        Client.shared.setDefaultUserAddress(accesstoken: AccountController.shared.accessToken,Id:id){  defaultAddress in
            self.Delegate?.getData(flag: true, delete: false, id: self.id)
        }
    }
    
    @IBAction func actionEdit(_ sender: Any) {
        self.DelegateController?.NextController(flag: true, address: address)
    }
    
    @IBAction func actionDelete(_ sender: Any) {
            self.Delegate?.getData(flag: true, delete: true, id: self.id)
    }
}
