//
//  changePasswordVC.swift
//  login
//
//  Created by waynehui on 3/2/18.
//  Copyright © 2018 waynehui. All rights reserved.
//

import UIKit
import Alamofire

class changePasswordVC: UIViewController{
    
    @IBOutlet weak var textfieldNewPassword: UITextField!
    @IBOutlet weak var textfieldRetypeNewPasswor: UITextField!
    
    @IBOutlet weak var labelErrorMessage: UILabel!
    
    let URL_newPasswordSave = "http://tester.onyourblog.com/server/newPasswordSave.php"
    
    @IBAction func buttonSave(_ sender: UIButton) {
        
        if textfieldNewPassword.text != textfieldRetypeNewPasswor.text {
            labelErrorMessage.text = "New password not the same, please retype"
        } else {
            // send new password and reset, if no error go to profile page
            let parm: Parameters = ["password":textfieldNewPassword.text!]
            Alamofire.request(URL_newPasswordSave, method: .post, parameters: parm).responseJSON
                {
                    response in
                    print(response)
                    
                    if let result = response.result.value {
                        let jsonData = result as! NSDictionary
                        
                        if((jsonData.value(forKey: "return_code")) as! Int != 0){
                            // Display error message
                        } else {
                            self.performSegue(withIdentifier: "gotoProfile", sender: nil)
                        }
                    }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let backButton = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.plain, target: navigationController, action: nil)
        navigationItem.leftBarButtonItem = backButton
        
        labelErrorMessage.numberOfLines = 0
        labelErrorMessage.lineBreakMode = .byWordWrapping
        labelErrorMessage.sizeToFit()
        
    }
    
}



