//
//  EditProfileViewController.swift
//  Storefront
//
//  Created by Macbook on 31/07/23.
//  Copyright © 2023 Shopify Inc. All rights reserved.
//

import UIKit
import MaterialComponents

class EditProfileViewController: BaseVC {
    @IBOutlet weak var txtfirstName:MDCFilledTextField!
    @IBOutlet weak var txtLastName: MDCFilledTextField!
    @IBOutlet weak var txtMobile: MDCFilledTextField!
    @IBOutlet weak var btnSave:UIButton!
    @IBOutlet weak var editView:UIView!
    //var customer : CustomerViewModel?
    let editBaseViewModel:LoginBaseDelgate = LoginBaseViewModel()
    override func viewDidLoad() {
        super.viewDidLoad()
        shadow()
        txtfirstName.label.text = "First name"
        txtLastName.label.text = "Last Name"
        txtMobile.label.text = "Mobile"
        setUpMatterialDesig(txtfirstName)
        setUpMatterialDesig(txtMobile)
        setUpMatterialDesig(txtLastName)
        setData()
        setPlaceholder()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setNavigationBarTitle("Edit Profile",inMiddle: true)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    func setData(){
        txtfirstName.text = UserManger.shared.firstname
        txtLastName.text = UserManger.shared.lastname
        var originalString:String = (UserManger.shared.phone)!
        let prefixToRemove = "+91"

        if originalString.hasPrefix(prefixToRemove) {
            originalString.removeSubrange(originalString.startIndex..<originalString.index(originalString.startIndex, offsetBy: prefixToRemove.count))
        }
        txtMobile.text = originalString
     
    }
    
    func setPlaceholder(){
        txtfirstName.label.text = "First name"
        txtLastName.label.text = "Last Name"
        txtMobile.label.text = "Mobile"
        let  imageView = UIImageView(image: UIImage(named: "Flag_of_India"))
        txtMobile.contentMode = .scaleAspectFit
        txtMobile.leftView = imageView
        txtMobile.leftViewMode = .always
    }
    
    func setUpMatterialDesig(_ txtFild: MDCFilledTextField?) {
        txtFild?.setLeadingAssistiveLabelColor(.red, for: .normal)
        txtFild?.setUnderlineColor(.black, for: .normal)
        txtFild?.setUnderlineColor(.clear, for: .normal)
        txtFild?.setUnderlineColor(.clear, for: .editing)
        txtFild?.setFilledBackgroundColor(UIColor(named: "CustomGrey")!, for: .normal)
        txtFild?.setFilledBackgroundColor(UIColor(named: "CustomGrey")!, for: .editing)
        txtFild?.cornerRadius = 25
    }
    
    @IBAction func actionSaveUser(_ sender: Any) {
     if isValidateData(){
         showLoader()
         let mobile = "+91\(txtMobile.text ?? "")"
         editBaseViewModel.ProcessEdit(customerAccessToken: AccountController.shared.accessToken!, firstName: txtfirstName.text!, lastName: txtLastName.text!, phone: mobile){ response in
             self.dismissLoader()
            if  response == nil{
                UserManger.shared.removeAllUserSetting()
                 self.navigationController?.popViewController(animated: true)
             }
             else{
                 self.view.makeToast(response)
             }
         }
        }
    }
    
    func shadow(){
        editView.layer.masksToBounds = false
        editView.layer.shadowColor =  UIColor.gray.cgColor
        editView.layer.shadowOffset = CGSize(width: 0, height: 1)
        editView.layer.shadowRadius = 2.0
        editView.layer.shadowOpacity = 5.0
        editView.layer.cornerRadius = 8.0
    }
    
    func isValidateData() -> Bool {
        let isFirstNameValid = ValidationHandler.isValidName(txtfirstName).0
        let isLastNameValid = ValidationHandler.isValidName(txtLastName).0
        let isMobileValid = ValidationHandler.isValidMobile(txtMobile!).0
        return (isFirstNameValid && isLastNameValid && isMobileValid )
    }
    
    func addheight(msz:String!){
        if msz != "" && msz != nil{
            self.editView.frame = CGRect(x: 0, y: 0, width: self.editView.frame.width, height: self.editView.frame.height + 20.0)
        }
    }
}

extension EditProfileViewController: UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        if txtfirstName == textField {
            txtLastName?.becomeFirstResponder()
        } else if txtLastName == textField {
            txtMobile?.becomeFirstResponder()
        }
        else if txtMobile == textField {
            txtMobile?.resignFirstResponder()
        }
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if txtfirstName == textField {
            let msz = ValidationHandler.isValidName(txtfirstName).1
            txtfirstName.leadingAssistiveLabel.text = msz
            addheight(msz: msz)
            
        } else if txtLastName == textField {
            let msz = ValidationHandler.isValidName(txtLastName).1
            txtLastName.leadingAssistiveLabel.text = msz
            addheight(msz: msz)
        }
      
        else if txtMobile == textField {
            let msz = ValidationHandler.isValidMobile(txtMobile).1
            txtMobile.leadingAssistiveLabel.text = msz
            addheight(msz: msz)
        }
        if isValidateData() {
            btnSave.isEnabled = true
            btnSave.alpha = 1.0
        } else {
            btnSave.isEnabled = false
            btnSave.alpha = 0.5
        }
    }
    
    func textField(_ textField: UITextField,
                   shouldChangeCharactersIn range: NSRange,
                   replacementString string: String) -> Bool {
        if txtMobile == textField {
            let currentString: NSString = textField.text! as NSString
            let newString: NSString =
            currentString.replacingCharacters(in: range, with: string) as NSString
            if newString.length == 1 && newString == " " {
                return false
            }
            if newString.length >= 11 {
                return false
            }
            return true
        } else {
            return true
        }
    }
}

