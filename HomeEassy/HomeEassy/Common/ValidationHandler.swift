

import Foundation
import UIKit
//import MaterialComponents.MaterialTextControls_OutlinedTextFields

public let invalidEmail = "Please provide valid email address"
public let invalidName = "Please provide valid name"
public let invalidMobile = "Please provide valid mobile number"
public let invalidZip = "Please provide valid Pincode"
public let invalidAddress = "Please provide valid Address"
public let invalidReg = "Please provide valid Registration number"
public let invalidCity = "Please provide  City"
public let invalidState = "Please provide State"
public let invalidPass = "Please provide password"
public let mobilelength = 10
public let addresslength = 150
private let addresslengthForVaild = 3
public let ziplength = 6
public let emaillength = 50
public let namelength = 50

class ValidationHandler : NSObject {
    
    class func isValidEmail(_ textField: UITextField? = nil , text : String? = nil) -> (Bool,String?) {
        var isValid = true
        var message : String?
        if let text = text ?? textField?.text {
            if !text.containsWhitespace{
                if text.isValidEmail() == false  {
                    isValid = false
                    message = invalidEmail
                }}
            else {
                isValid = false
                message = invalidEmail
            }
        }
        else {
            isValid = false
            message = invalidEmail
        }
      //  textField?.leadingAssistiveLabel.text = message
        
        return (isValid,message)
    }
    //
    
    
    
    class func isValidName(_ textField: UITextField? = nil, text : String? = nil) -> (Bool,String?) {
        var isValid = true
        var message : String?
        if let text = text ?? textField?.text {
            let trimmedText = text.actualString()
            if trimmedText.count < 1 || trimmedText.containsSpecialCharacter {
                isValid = false
                message = invalidName
            }}
        else {
            isValid = false
            message = invalidName
        }
        //textField?.leadingAssistiveLabel.text = message
        
        return (isValid,message)
    }
    
    class func isValidPass(_ textField: UITextField? = nil, text : String? = nil) -> (Bool,String?) {
        var isValid = true
        var message : String?
        if let text = text ?? textField?.text {
            let trimmedText = text.actualString()
            if trimmedText.count < 1  {
                isValid = false
                message = invalidPass
            }}
        else {
            isValid = false
            message = invalidPass
        }
        //textField?.leadingAssistiveLabel.text = message
        
        return (isValid,message)
    }
    
    class func isValidPassword(_ textField: UITextField? = nil, text: String? = nil) -> (Bool, String?) {
        var isValid = true
        var message: String?
        
        if let text = text ?? textField?.text {
            let trimmedText = text.trimmingCharacters(in: .whitespacesAndNewlines)
            
            let passwordRegex = "^(?=.*[A-Z])(?=.*[0-9])(?=.*[a-z]).{8,}$"
            let passwordTest = NSPredicate(format: "SELF MATCHES %@", passwordRegex)
            
            if !passwordTest.evaluate(with: trimmedText) {
                isValid = false
                message = "Password should contain one capital & small letter,one number & one special character"
            }
        } else {
            isValid = false
            message = invalidPass
        }
        
        return (isValid, message)
    }

    
    class func isValidMobile(_ textField: UITextField? = nil, text : String? = nil) -> (Bool,String?) {
        var isValid = true
        var message : String?
        if let text = text ?? textField?.text {
            let trimmedText = text.actualString()
            if (trimmedText.count != mobilelength) {
                isValid = false
                message = invalidMobile
            }
            
            if isValid && trimmedText.first == "0" {
                isValid = false
                message = invalidMobile
            }
            if isValid && trimmedText.first == "1" {
                isValid = false
                message = invalidMobile
            }
        }
        else {
            isValid = false
            message = invalidMobile
        }
        //textField?.leadingAssistiveLabel.text = message
        return (isValid,message)
    }
    
    class func isValidReg(_ textField: UITextField? = nil, text : String? = nil) -> (Bool,String?) {
        var isValid = true
        var message : String?
        if let text = text ?? textField?.text {
            let trimmedText = text.actualString()
            if (trimmedText.count <= 1) {
                isValid = false
                message = invalidReg
            }
            
        }
        else {
            isValid = false
            message = invalidReg
        }
        //textField?.leadingAssistiveLabel.text = message
        return (isValid,message)
    }
    class func isValidZip(_ textField: UITextField? = nil, text : String? = nil) -> (Bool,String?) {
        var isValid = true
        var message : String?
        if let text = text ?? textField?.text {
            let trimmedText = text.actualString()
            if trimmedText.count != ziplength {
                isValid = false
                message = invalidZip
            }
            if isValid && trimmedText.first == "0" {
                isValid = false
                message = invalidZip
            }
        }
        else {
            isValid = false
            message = invalidZip
        }
       // textField?.leadingAssistiveLabel.text = message
        
        return (isValid,message)
    }
    
    class func isValidAddress(_ textField: UITextField? = nil, text : String? = nil) -> (Bool,String?) {
        var isValid = true
        var message : String?
        if let text = text ?? textField?.text {
            let trimmedText = text.actualString()
            if text.isValidateAddress()  ||  trimmedText.count < addresslengthForVaild {
                isValid = false
                message = invalidAddress
            }}else{
                isValid = false
                message = invalidAddress
            }
       // textField?.leadingAssistiveLabel.text = message
        
        return (isValid,message)
    }
    
    class func isValidAddress2(_ textField: UITextField? = nil, text : String? = nil) -> (Bool,String?) {
        var isValid = true
        var message : String?
        if let text = text ?? textField?.text {
            let trimmedText = text.actualString()
            if text.isValidateAddress(){
                isValid = false
                message = invalidAddress
            }}else{
                isValid = false
                message = invalidAddress
            }
       // textField?.leadingAssistiveLabel.text = message
        
        return (isValid,message)
    }
    
    class func isValidCity(_ textField: UITextField? = nil, text : String? = nil) -> (Bool,String?) {
        var isValid = true
        var message : String?
        if let text = text ?? textField?.text {
            let trimmedText = text.actualString()
            if trimmedText.count < 1 {
                isValid = false
                message = invalidCity
            }}
        else {
            isValid = false
            message = invalidCity
        }
        //textField?.leadingAssistiveLabel.text = message
        
        return (isValid,message)
    }
    class func isValidState(_ textField: UITextField? = nil, text : String? = nil) -> (Bool,String?) {
        var isValid = true
        var message : String?
        if let text = text ?? textField?.text {
            let trimmedText = text.actualString()
            if trimmedText.count < 1{
                isValid = false
                message = invalidState
            }}
        else {
            isValid = false
            message = invalidState
        }
        //textField?.leadingAssistiveLabel.text = message
        
        return (isValid,message)
    }

}

