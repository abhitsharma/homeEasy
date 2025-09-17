//
//  LoginViewController.swift
//  ecomm
//
//  Created by Macbook on 26/07/23.
//

import UIKit
import MaterialComponents
import FirebaseAnalytics
import MaterialComponents.MaterialTextControls_FilledTextFields
class LoginVC: BaseVC {
    @IBOutlet weak var forgetPass:UILabel!
    @IBOutlet weak var txtEmail:MDCFilledTextField!
    @IBOutlet weak var txtPassword:MDCFilledTextField!
    @IBOutlet weak var btnLogIN:UIButton!
    @IBOutlet weak var viewBack:UIView!
    @IBOutlet weak var lblRegister:UILabel!
    @IBOutlet weak var btnHide:UIButton!
    @IBOutlet weak var btnRememberMe:UIButton!
    @IBOutlet weak var Btndismiss:UIButton!
    var rememberFlag:Bool = false
    let loginBaseViewModel:LoginBaseDelgate = LoginBaseViewModel()
    override func viewDidLoad() {
        super.viewDidLoad()
        btnLogIN.isEnabled = false
        btnLogIN.alpha = 0.5
        btnLogIN.layer.cornerRadius = 23
        forgetPass.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(actionForgetPass))
        forgetPass.addGestureRecognizer(tapGesture)
        setDesign()
        lblRegister.isUserInteractionEnabled = true
        let tapGesture1 = UITapGestureRecognizer(target: self, action: #selector(actionRegisterScreen))
        lblRegister.addGestureRecognizer(tapGesture1)
        setData()
        btnHide.isSelected = true
        txtPassword.isSecureTextEntry = true
       setUpMatterialDesig(txtEmail)
       setUpMatterialDesig(txtPassword)
    }
   
    func setData(){
        if let userEmail = UserController.shared.userEmail,userEmail != ""{
            txtEmail.text = userEmail
        }
        else{
            txtEmail.text = ""
        }
        
    }
    
    func setDesign(){
        let infoString = "Don't have an account? Register"
        let temString = "Register"
        let attributedMsg = NSMutableAttributedString(string: infoString)
        attributedMsg.addAttribute(.foregroundColor,
                                   value:UIColor(named: "black")!,
                                   range: NSRange(location: 0, length: infoString.count))
        attributedMsg.addAttribute(.foregroundColor,
                                   value:UIColor(named: "CustomRed")!,
                                   range: (infoString as NSString).range(of: temString))
        
        self.lblRegister?.attributedText = attributedMsg
        txtEmail.label.text = "Email"
        txtPassword.label.text = "Password"
        let  imageEmail = UIImageView(image: UIImage(named: "mailImage"))
        txtEmail.contentMode = .scaleAspectFit
        txtEmail.leftView = imageEmail
        txtEmail.leftViewMode = .always
        let  imagePassword = UIImageView(image: UIImage(named: "passwordImage"))
        txtPassword.contentMode = .scaleAspectFit
        txtPassword.leftView = imagePassword
        txtPassword.leftViewMode = .always
    }
   
    override func viewWillAppear(_ animated: Bool) {
        setNavigationBarTitle("Login",inMiddle: true)
       self.navigationController?.setNavigationBarHidden(false, animated: true)
   }
    
    @IBAction func hideUnHide(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        if sender.isSelected{
            txtPassword.isSecureTextEntry = true
        }
        else {
            txtPassword.isSecureTextEntry = false
        }
        
    }
    
    @IBAction func actionRememberMe(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        if sender.isSelected{
       rememberFlag = true
        }
        else {
            rememberFlag = false
        }
    }
    
    @IBAction func actionDismiss(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
    
    func setUpMatterialDesig(_ txtFild: MDCFilledTextField?) {
        txtFild?.setLeadingAssistiveLabelColor(.red, for: .normal)
    txtFild?.setUnderlineColor(.clear, for: .normal)
        txtFild?.setUnderlineColor(.clear, for: .editing)
        txtFild?.setFilledBackgroundColor(UIColor(named: "CustomGrey")!, for: .normal)
        txtFild?.setFilledBackgroundColor(UIColor(named: "CustomGrey")!, for: .editing)
        txtFild?.cornerRadius = 25
    }
    
    @IBAction func actionLogin(_ sender: Any) {
        loginUser()
    }
    
    func loginUser(){
        if isValidateData(){
            showLoader()
            loginBaseViewModel.processLogin(email: txtEmail.text!, password: txtPassword.text!){ respone in
                self.dismissLoader()
                if respone == "Sucess"{
                    if self.rememberFlag{
                        UserController.shared.saveUser(userId: self.txtEmail.text!)
                        FirebaseAnalytics.shared.sendLogEventLogin(aacessToken: AccountController.shared.accessToken!)
                    }
                    self.dismiss(animated: true)
                }
                else{
                    let alert = UIAlertController(title: "Login Error", message: "\(respone ?? "Error")", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                 self.present(alert, animated: true, completion: nil)
                }
                
            }
        }
        else{
            self.view.makeToast("Please provide valid Email or Password")
        }
    }
    
    @objc func actionForgetPass(){
        let vc = StoryBoardHelper.controller(.live, type: ForgetPasswordVC.self)
        vc!.hidesBottomBarWhenPushed = true
        vc!.modalPresentationStyle = .fullScreen
        self.present(vc!, animated: true)

    }
    
    @objc func actionRegisterScreen(){
        let vc = StoryBoardHelper.controller(.live, type: SignUpViewController.self)
        vc!.hidesBottomBarWhenPushed = true
        vc!.modalPresentationStyle = .fullScreen
        self.present(vc!, animated: true)
    }
    
    func isValidateData() -> Bool {
        let isEmailValid = ValidationHandler.isValidEmail(txtEmail!).0
        let isPassValid = ValidationHandler.isValidPass(txtPassword!).0
        return (isEmailValid && isPassValid)
    }
    
}

extension LoginVC:UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        if txtEmail == textField {
            txtPassword?.becomeFirstResponder()
        } else if txtPassword == textField {
            txtPassword?.resignFirstResponder()
            loginUser()
        }
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if txtEmail == textField {
            let msz = ValidationHandler.isValidEmail(txtEmail).1
            txtEmail.leadingAssistiveLabel.text = msz
          
        } else if txtPassword == textField {
            let msz = ValidationHandler.isValidPass(txtPassword).1
            txtPassword.leadingAssistiveLabel.text = msz
        }
       
        if isValidateData() {
            btnLogIN.isEnabled = true
            btnLogIN.alpha = 1.0
        } else {
            btnLogIN.isEnabled = false
            btnLogIN.alpha = 0.5
        }
    }
    
    func textField(_ textField: UITextField,
                   shouldChangeCharactersIn range: NSRange,
                   replacementString string: String) -> Bool {
        if txtPassword == textField {
            let currentString: NSString = textField.text! as NSString
            let newString: NSString =
            currentString.replacingCharacters(in: range, with: string) as NSString
            if newString.length == 1 && newString == " " {
                return false
            }
            if ValidationHandler.isValidPass(text: newString as String).0 && ValidationHandler.isValidEmail(txtEmail).0{
                btnLogIN.isEnabled = true
                btnLogIN.alpha = 1.0
            } else {
                btnLogIN.isEnabled = false
                btnLogIN.alpha = 0.5
            }
            return true
        } else {
            return true
        }
    }
}
