//
//  LogoutFooterView.swift
//  HomeEassy
//
//  Created by Macbook on 17/08/23.
//

import UIKit
protocol selectLogout{
    func logout(flag:Bool)
}
class LogoutFooterView: UITableViewHeaderFooterView {
    var Delegate:selectLogout?
    @IBOutlet weak var BtnLogout:UIButton!
    @IBOutlet weak var lblVersion:UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
    
    }

    @IBAction func actionLogout(_ sender: Any){
        self.Delegate?.logout(flag: true)
        
    }
    
}
