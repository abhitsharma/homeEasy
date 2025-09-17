//
//  SignUpViewController.swift
//  ecomm
//
//  Created by Macbook on 26/07/23.
//

import UIKit
import MaterialComponents

class SignUpViewController: BaseVC {
    
    @IBOutlet weak var txtfirstName: MDCFilledTextField!
    @IBOutlet weak var txtLastName: MDCFilledTextField!
    @IBOutlet weak var txtEmail: MDCFilledTextField!
    @IBOutlet weak var txtMobile: MDCFilledTextField!
    @IBOutlet weak var txtPassword: MDCFilledTextField!
    @IBOutlet weak var checkBoxBtn: UIButton!
    @IBOutlet weak var btnSignup:UIButton!
    @IBOutlet weak var viewBack:UIView!
    @IBOutlet weak var btnHide:UIButton!
    @IBOutlet weak var lblInfo:UILabel!
    @IBOutlet weak var Btndismiss:UIButton!
    let signUpBaseVM:SignUpBaseDelgate = SignUpBaseVM()
    
    var acceptMarketing:Bool = false
    override func viewDidLoad() {
        super.viewDidLoad()
        //self.title = "Sign Up"
        btnSignup.isEnabled = false
        btnSignup.alpha = 0.5
        btnSignup.layer.cornerRadius = 23
        setPlaceholder()
        setUpMatterialDesig(txtfirstName)
        setUpMatterialDesig(txtEmail)
        setUpMatterialDesig(txtPassword)
        setUpMatterialDesig(txtLastName)
        setUpMatterialDesig(txtMobile)
        lblInfo?.gettingTapLable(owner: self)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setNavigationBarTitle("Sign Up",inMiddle: true)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    @IBAction func checkBox(_ sender: UIButton) {
        //self.view.endEditing(true)
        sender.isSelected = !sender.isSelected
        if sender.isSelected{
            acceptMarketing = true
        }
        else {
            acceptMarketing = false
        }
       isValidateData()
        
    }
    
    @IBAction func hideUnHide(_ sender: UIButton) {
        //self.view.endEditing(true)
        sender.isSelected = !sender.isSelected
        if sender.isSelected{
            txtPassword.isSecureTextEntry = true
        }
        else {
            txtPassword.isSecureTextEntry = false
        }
        
    }
    
    func setPlaceholder(){
        txtfirstName.label.text = "First name"
        txtEmail.label.text = "Email"
        txtLastName.label.text = "Last Name"
        txtMobile.label.text = "Mobile"
        txtPassword.label.text = "Password"
        let  imageView = UIImageView(image: UIImage(named: "Flag_of_India"))
        txtMobile.contentMode = .scaleAspectFit
        txtMobile.leftView = imageView
        txtMobile.leftViewMode = .always
        
        let infoString = "Already have an account? Sign In"
        let temString = "Sign In"
        let attributedMsg = NSMutableAttributedString(string: infoString)
        attributedMsg.addAttribute(.foregroundColor,
                                   value:UIColor(named: "black"),
                                   range: NSRange(location: 0, length: infoString.count))
        attributedMsg.addAttribute(.foregroundColor,
                                   value:UIColor.red,
                                   range: (infoString as NSString).range(of: temString))
        
        self.lblInfo?.attributedText = attributedMsg
    }
    
    @objc func singleTap(gesture: UITapGestureRecognizer) {
        let myLabel=gesture.view as? UILabel
        let text = myLabel?.text
        let termsRange = (text! as NSString).range(of: "Sign In")
        
        if gesture.didTapAttributedTextInLabel(label: myLabel!, inRange: termsRange) {
            let vc = StoryBoardHelper.controller(.live, type: LoginVC.self)
            vc!.modalPresentationStyle = .fullScreen
            self.present(vc!, animated: true)
        } else {
          print("Tapped none")
        }
      }
    
    
    func setUpMatterialDesig(_ txtFild: MDCFilledTextField?) {
            txtFild?.setLeadingAssistiveLabelColor(.red, for: .normal)
            txtFild?.setUnderlineColor(.clear, for: .normal)
            txtFild?.setUnderlineColor(.clear, for: .editing)
            txtFild?.setFilledBackgroundColor(UIColor(named: "CustomGrey")!, for: .normal)
            txtFild?.setFilledBackgroundColor(UIColor(named: "CustomGrey")!, for: .editing)
            txtFild?.cornerRadius = 25
    }
    
    @IBAction func actionCreateUser(_ sender: Any) {
        self.view.endEditing(true)
        if  isValidateData(){
            showLoader()
            let mobile = "+91\(txtMobile.text ?? "")"
            signUpBaseVM.processSignUP(firstName: txtfirstName.text!, lastName: txtLastName.text!, email: txtEmail.text!, mobile: mobile, password: txtPassword.text!, acceptMarketEmail:acceptMarketing){ respone in
                self.dismissLoader()
                if respone == "Success"{
                    self.view.makeToast("Your Account has been created successfully",duration: 1) { didTap in
                        self.dismiss(animated: true)
                    }
                }
                else{
                    self.view.makeToast(respone)
                }
                
            }
            
        }
    }
    
    @IBAction func actionDismiss(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
    
    func isValidateData() -> Bool {
        let isFirstNameValid = ValidationHandler.isValidName(txtfirstName).0
        let isLastNameValid = ValidationHandler.isValidName(txtLastName).0
        let isEmailValid = ValidationHandler.isValidEmail(txtEmail!).0
        let isMobileValid = ValidationHandler.isValidMobile(txtMobile!).0
        let isPassValid = ValidationHandler.isValidPassword(txtPassword!).0
        if (isFirstNameValid && isMobileValid && isEmailValid && isLastNameValid && isPassValid){
            btnSignup.isEnabled = true
            btnSignup.alpha = 1.0
            return true
        }
        else{
            btnSignup.isEnabled = false
            btnSignup.alpha = 0.5
            return false
        }
    }
    
    func addheight(msz:String!){

        if msz != "" && msz != nil{
            self.viewBack.frame = CGRect(x: 0, y: 0, width: self.viewBack.frame.width, height: self.viewBack.frame.height + 50.0)
        }
    }
}


    extension SignUpViewController: UITextFieldDelegate{
        func textFieldShouldReturn(_ textField: UITextField) -> Bool {
            textField.resignFirstResponder()
            if txtfirstName == textField {
                txtLastName?.becomeFirstResponder()
            } else if txtLastName == textField {
                txtEmail?.becomeFirstResponder()
            }
            else if txtEmail == textField {
                txtMobile?.becomeFirstResponder()
            }
            else if txtMobile == textField {
                txtPassword?.becomeFirstResponder()
            }else if txtPassword == textField {
                txtPassword?.resignFirstResponder()
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
            else if txtEmail == textField {
                let msz = ValidationHandler.isValidEmail(txtEmail).1
                txtEmail.leadingAssistiveLabel.text = msz
                addheight(msz: msz)
            }
            else if txtMobile == textField {
                let msz = ValidationHandler.isValidMobile(txtMobile).1
                txtMobile.leadingAssistiveLabel.text = msz
                addheight(msz: msz)
            } else if txtPassword == textField {
                let msz = ValidationHandler.isValidPassword(txtPassword!).1
                txtPassword.leadingAssistiveLabel.text = msz
                addheight(msz: msz)
            }
             isValidateData()
        
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

