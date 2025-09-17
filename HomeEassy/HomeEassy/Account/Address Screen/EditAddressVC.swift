//
//  EditAddressVC.swift
//  Storefront
//
//  Created by Macbook on 09/08/23.
//  Copyright © 2023 Shopify Inc. All rights reserved.
//

import UIKit
import MaterialComponents

class EditAddressVC: BaseVC {
    @IBOutlet weak var txtFldState: MDCFilledTextField!
    @IBOutlet weak var txtFldCIty: MDCFilledTextField!
    @IBOutlet weak var txtFldAddress: MDCFilledTextField!
    @IBOutlet weak var txtFldPincode: MDCFilledTextField!
    @IBOutlet weak var txtFldPhone: MDCFilledTextField!
    @IBOutlet weak var txtFldAddress2: MDCFilledTextField!
    @IBOutlet weak var btnEdit:UIButton!
    @IBOutlet weak var viewAddress:UIView!
    var param=[String:String]()
    var address : AddressViewModel?
    var addressBaseVM:AddressBaseDelegate = AddressBaseVM()
    var id:String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        txtFldAddress.text = address?.address1
        txtFldPincode.text  = address?.zip
        txtFldCIty.text = address?.city
        txtFldState.text = address?.province
        txtFldPhone.text = address?.phone
        id = address?.model.id.rawValue
       
        if  isValidateData() {
            btnEdit.isEnabled = true
            btnEdit.alpha = 1.0
        }
        else{
            btnEdit.isEnabled = false
            btnEdit.alpha = 0.5
        }
        
        btnEdit.layer.cornerRadius = 23
        txtFldState.label.text = "State"
       txtFldAddress.label.text = "Address"
        txtFldPincode.label.text = "Pincode"
        txtFldAddress2.label.text = "Apartment,suite,etc.(optional)"
        txtFldCIty.label.text = "City"
        txtFldPhone.label.text = "Phone"
        setUpMatterialDesig(txtFldState)
        setUpMatterialDesig(txtFldAddress)
        setUpMatterialDesig(txtFldPincode)
        setUpMatterialDesig(txtFldCIty)
        setUpMatterialDesig(txtFldPhone)
        setUpMatterialDesig(txtFldAddress2)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setNavigationBarTitle("Edit Address",inMiddle: true)
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
    
    @IBAction func actionAddAddress(_ sender: Any) {
        if isValidateData(){
            showLoader()
            addressBaseVM.processEditAddress(accesstoken: AccountController.shared.accessToken!, address: txtFldAddress.text!, address2: txtFldAddress2.text!, city: txtFldCIty.text!, zip: txtFldPincode.text!, province: txtFldState.text!, id: id, phone: txtFldPhone.text!){ response in
                self.dismissLoader()
                if response == nil{
                    self.navigationController?.popViewController(animated: true)
                }
                else{
                    self.view.makeToast(response)
                }
                
            }
        }}
    
    func isValidateData() -> Bool {
        let isAddressValid = ValidationHandler.isValidAddress(txtFldAddress).0
        let isCityValid = ValidationHandler.isValidCity(txtFldAddress).0
        let isZipValid = ValidationHandler.isValidZip(txtFldPincode!).0
        let isStateValid = ValidationHandler.isValidState(txtFldState!).0
        let isPhoneValid = ValidationHandler.isValidMobile(txtFldPhone!).0
        return (isAddressValid && isCityValid && isZipValid && isStateValid && isPhoneValid)
    }
    
    func addheight(msz:String!){
        if msz != "" && msz != nil{
            self.viewAddress.frame = CGRect(x: 0, y: 0, width: self.viewAddress.frame.width, height: self.viewAddress.frame.height + 60.0)
        }
    }

}

extension EditAddressVC: UITextFieldDelegate{
        func textFieldShouldReturn(_ textField: UITextField) -> Bool {
            textField.resignFirstResponder()
            if txtFldAddress == textField {
                txtFldAddress2?.becomeFirstResponder()
            }else if txtFldAddress2 == textField {
                txtFldPhone?.becomeFirstResponder()
            }else if txtFldPhone == textField {
                txtFldCIty?.becomeFirstResponder()
            }
            else if txtFldCIty == textField {
                txtFldState?.becomeFirstResponder()
            }
            else if txtFldState == textField {
                txtFldPincode?.becomeFirstResponder()
            }
            else if txtFldPincode == textField {
                txtFldPincode?.resignFirstResponder()
            }
            return true
        }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if txtFldAddress == textField {
            let msz = ValidationHandler.isValidAddress(txtFldAddress).1
            txtFldAddress.leadingAssistiveLabel.text = msz
            addheight(msz: msz)
        
        }else if txtFldAddress2 == textField {
//            let msz = ValidationHandler.isValidAddress(txtFldAddress2).1
//            txtFldAddress2.leadingAssistiveLabel.text = "please Provide"
            //addheight(msz: msz)
        }else if txtFldPincode == textField {
            let msz = ValidationHandler.isValidZip(txtFldPincode).1
            txtFldPincode.leadingAssistiveLabel.text = msz
            addheight(msz: msz)
        }
        else if txtFldCIty == textField {
            let msz = ValidationHandler.isValidCity(txtFldCIty).1
            txtFldCIty.leadingAssistiveLabel.text = msz
            addheight(msz: msz)
        }
        else if txtFldState == textField {
            let msz = ValidationHandler.isValidState(txtFldState).1
            txtFldState.leadingAssistiveLabel.text = msz
            addheight(msz: msz)
        }
        else if txtFldPhone == textField {
            let msz = ValidationHandler.isValidMobile(txtFldPhone).1
            txtFldPhone.leadingAssistiveLabel.text = msz
            addheight(msz: msz)
        }
        if isValidateData() {
            btnEdit.isEnabled = true
            btnEdit.alpha = 1.0
        } else {
            btnEdit.isEnabled = false
            btnEdit.alpha = 0.5
        }
    }
    
    func textField(_ textField: UITextField,
                   shouldChangeCharactersIn range: NSRange,
                   replacementString string: String) -> Bool {
        if txtFldPhone == textField {
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
