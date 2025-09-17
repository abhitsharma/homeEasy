//
//  ForgetPasswordVC.swift
//  Storefront
//
//  Created by Macbook on 27/07/23.
//  Copyright © 2023 Shopify Inc. All rights reserved.
//

import UIKit
import MaterialComponents

class ForgetPasswordVC: BaseVC {
    @IBOutlet weak var txtEmail:MDCFilledTextField!
    @IBOutlet weak var btnSend:UIButton!
    @IBOutlet weak var viewAddress:UIView!
    @IBOutlet weak var Btndismiss:UIButton!
    //@IBOutlet var countDownLabel: UILabel!
    var secondsRemaining = 120
    override func viewDidLoad() {
        super.viewDidLoad()
        //self.title = "Forgot Password"
        // Do any additional setup after loading the view.
        txtEmail.label.text = "Email"
        txtEmail?.setLeadingAssistiveLabelColor(.red, for: .normal)
        txtEmail?.setUnderlineColor(.black, for: .normal)
        txtEmail?.setUnderlineColor(.clear, for: .normal)
        txtEmail?.setUnderlineColor(.clear, for: .editing)
        txtEmail?.setFilledBackgroundColor(UIColor(named: "CustomGrey")!, for: .normal)
        txtEmail?.setFilledBackgroundColor(UIColor(named: "CustomGrey")!, for: .editing)
        txtEmail?.cornerRadius = 25
        btnSend.isEnabled = false
        btnSend.alpha = 0.5
        btnSend.layer.cornerRadius = 23
        //countDownLabel.isHidden = true
        //self.countDownLabel.text = "\(self.secondsRemaining) seconds left"
    }
    override func viewWillAppear(_ animated: Bool) {
        setNavigationBarTitle("Forgot Password",inMiddle: true)
    }
    
    @IBAction func actionDismiss(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
    
    @IBAction func actionSend(_ sender: Any) {
        if isValidateData(){
            showLoader()
            Client.shared.resetPassword(email: txtEmail.text! ){ customer in
                self.dismissLoader()
                if let customer = customer{
                    print(customer.self)
                }
                //self.countDownLabel.isHidden = false
//                Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { (Timer) in
//                    if self.secondsRemaining > 0 {
//                        self.countDownLabel.text = "\(self.secondsRemaining) seconds left"
//                        self.secondsRemaining -= 1
//                    } else {
//                        Timer.invalidate()
//                        self.countDownLabel.isHidden = true
//                    }
//                }
                self.view.makeToast("We Have sent you mail to reset password",duration: 1){didTap in
                    self.dismiss(animated: true)
                }
            }
        }
    }
    
    func isValidateData() -> Bool {
        let isEmailValid = ValidationHandler.isValidEmail(txtEmail!).0
        return (isEmailValid)
    }

    func addheight(msz:String!){
        if msz != "" && msz != nil{
            self.viewAddress.frame = CGRect(x: 0, y: 0, width: self.viewAddress.frame.width, height: self.viewAddress.frame.height + 20.0)
        }
    }
    

    
}

extension ForgetPasswordVC:UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        if txtEmail == textField {
            txtEmail?.resignFirstResponder()
        }
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if txtEmail == textField {
            let msz = ValidationHandler.isValidEmail(txtEmail).1
            txtEmail.leadingAssistiveLabel.text = msz
           // addheight(msz: msz)
        }
        if isValidateData() {
            btnSend.isEnabled = true
            btnSend.alpha = 1.0
        } else {
            btnSend.isEnabled = false
            btnSend.alpha = 0.5
        }
    }
    
    func textField(_ textField: UITextField,
                   shouldChangeCharactersIn range: NSRange,
                   replacementString string: String) -> Bool {
        if txtEmail == textField {
            let currentString: NSString = textField.text! as NSString
            let newString: NSString =
            currentString.replacingCharacters(in: range, with: string) as NSString
            if newString.length == 1 && newString == " " {
                return false
            }
            if ValidationHandler.isValidEmail(text: newString as String).0{
                btnSend.isEnabled = true
                btnSend.alpha = 1.0
            } else {
                btnSend.isEnabled = false
                btnSend.alpha = 0.5
            }
            return true
        } else {
            return true
        }
    }
}
