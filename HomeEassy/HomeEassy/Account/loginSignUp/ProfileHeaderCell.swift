//
//  ProfileHeaderCell.swift
//  HomeEassy
//
//  Created by Macbook on 17/08/23.
//

import UIKit
protocol selectDelegate{
    func signUp(flag:Bool)
    func login(flag:Bool)
    func edit(flag:Bool)
}

class ProfileHeaderCell: UITableViewHeaderFooterView {
    var Delegate:selectDelegate?
    @IBOutlet weak var view:UIView?
    @IBOutlet weak var btnEdit: UIButton!
    @IBOutlet weak var btnSignup: UIButton!
    @IBOutlet weak var btnLogin: UIButton!
    @IBOutlet weak var lblMobile: UILabel!
    @IBOutlet weak var lblEmail: UILabel!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var imgUser: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func setupCell(){
        lblName.text = UserManger.shared.custname
        lblEmail.text = UserManger.shared.email
        lblMobile.text = UserManger.shared.phone
        imgUser.placeholderImage(UserManger.shared.custname!, size: CGSize(width: 64, height: 64))
        btnLogin.isHidden = true
        btnSignup.isHidden = true
        btnLogin.isEnabled = false
        btnLogin.isEnabled = false
        btnEdit.isHidden = false
        btnEdit.isEnabled = true
        view?.isHidden = true
        lblEmail.isHidden  = false
        lblMobile.isHidden = false
        
    }
    
    func setupNoLogin(){
        imgUser.image = UIImage(named: "defaultImage")
        imgUser.contentMode = .scaleAspectFit
        lblName.text = "Hi User"
        lblEmail.isHidden  = true
        lblMobile.isHidden = true
        btnEdit.isHidden = true
        btnEdit.isEnabled = false
        btnLogin.isHidden = false
        btnSignup.isHidden = false
        btnLogin.isEnabled = true
        btnLogin.isEnabled = true
        view?.isHidden = false
    }

    @IBAction func actionSignup(_ sender: Any) {
        self.Delegate?.signUp(flag: true)
    }
    
    @IBAction func actionEdit(_ sender: Any) {
        self.Delegate?.edit(flag: true)
    }
    
    @IBAction func actionLogin(_ sender: Any) {
        self.Delegate?.login(flag: true)
    }
}
