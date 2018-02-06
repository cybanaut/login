//
//  ForgotPassViewController.swift
//  login
//
//  Created by waynehui on 29/1/18.
//  Copyright © 2018 waynehui. All rights reserved.
//

import UIKit
import Alamofire

class ForgotPassViewController: UIViewController {
    
    @IBOutlet weak var textFieldUsername: UITextField!
    @IBOutlet weak var buttonSubmitUsername: UIButton!
    
    @IBOutlet weak var labelErrorMessage: UILabel!
    
    @IBOutlet weak var textFieldTempPassword: UITextField!
    @IBOutlet weak var buttonSubmitResetPassword: UIButton!
    
    let URL_requestTempPassword = "http://tester.onyourblog.com/server/resetPasscodeRequest.php"
    let URL_submitTempPassword = "http://tester.onyourblog.com/server/resetPasscodeSubmit.php"
    
    
    @IBAction func submitUsername(_ sender: UIButton) {
        if textFieldUsername.text?.isEmpty ?? true{
            self.labelErrorMessage.text = "No username/email"
        } else {
            let parm: Parameters = ["login_id":textFieldUsername.text!]
            labelErrorMessage.text?.removeAll()
            disablefunction(textfield: textFieldUsername, button: buttonSubmitUsername)
            Alamofire.request(URL_requestTempPassword, method: .post, parameters: parm).responseJSON
            {
                response in
                print(response)
                
                if let result = response.result.value {
                    let jsonData = result as! NSDictionary
                    
                    if((jsonData.value(forKey: "return_code")) as! Int != 0){
                        
                        let error_title = jsonData.value(forKey: "error_title") as! String
                        let error_msg = jsonData.value(forKey: "error_message") as! String
                        self.labelErrorMessage.text = "\(error_title): \(error_msg)"
                        self.enablefunction(textfield: self.textFieldUsername, button: self.buttonSubmitUsername)
                    } else {
                        self.enablefunction(textfield: self.textFieldTempPassword, button: self.buttonSubmitResetPassword)
                    }
                }
            }
        }
    }
    
    
    @IBAction func submitTempPass(_ sender: UIButton) {
        if textFieldTempPassword.text?.isEmpty ?? true{
            self.labelErrorMessage.text = "Please input passcode"
        } else {
            let parm: Parameters = ["login_id":textFieldUsername.text!, "passcode":textFieldTempPassword.text!]
            print("in submitTempPass: \(parm)")
            disablefunction(textfield: textFieldTempPassword, button: buttonSubmitResetPassword)
            Alamofire.request(URL_submitTempPassword, method: .post, parameters: parm).responseJSON
                {
                    response in
                    print(response)
                    
                    if let result = response.result.value {
                        let jsonData = result as! NSDictionary
                        
                        if((jsonData.value(forKey: "return_code")) as! Int != 0){
                            let error_title = jsonData.value(forKey: "error_title") as! String
                            let error_msg = jsonData.value(forKey: "error_message") as! String
                            self.labelErrorMessage.text = "\(error_title): \(error_msg)"
                            self.enablefunction(textfield: self.textFieldTempPassword, button: self.buttonSubmitResetPassword)
                            self.textFieldTempPassword.text?.removeAll()
                        } else {
                            self.performSegue(withIdentifier: "gotoChangePassword", sender: nil)
                        }
                    }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if textFieldUsername.text?.isEmpty ?? true{
            enablefunction(textfield: textFieldUsername, button: buttonSubmitUsername)
            disablefunction(textfield: textFieldTempPassword, button: buttonSubmitResetPassword)
        }
        
    }
    override func viewDidAppear(_ animated: Bool) {
        
 
    }
    
    func disablefunction (textfield: UITextField, button: UIButton){
        textfield.isEnabled = false
        textfield.isUserInteractionEnabled = false
        textfield.backgroundColor = UIColor.lightGray
        button.isEnabled = false
    }
    
    func enablefunction (textfield: UITextField, button: UIButton){
        textfield.isEnabled = true
        textfield.isUserInteractionEnabled = true
        textfield.backgroundColor = UIColor.clear
        button.isEnabled = true
    }
    
}

