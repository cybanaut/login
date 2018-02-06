//
//  ViewController.swift
//  login
//
//  Created by waynehui on 14/1/18.
//  Copyright © 2018 waynehui. All rights reserved.
//

import UIKit
import Alamofire

class LoginViewController: UIViewController {

    let URL_login = "http://tester.onyourblog.com/server/loginSubmit.php"
   // let URL_login = "http://tester.onyourblog.com/server/testPost.php"
    
    let URL_checkLogin = "http://tester.onyourblog.com/server/checkLogin.php"
    
    let userData = UserDefaults.standard
    
    @IBOutlet weak var labelMessage: UILabel!
    @IBOutlet weak var textFieldUsername: UITextField!
    @IBOutlet weak var textFieldPassword: UITextField!
    
    @IBAction func buttonLogin(_ sender: UIButton) {
        
        if ((textFieldUsername.text?.isEmpty)! || (textFieldPassword.text?.isEmpty)! ) {
            
            print("got empty field")
            
        } else {
            
            let parameters: Parameters=[
                "login":textFieldUsername.text!,
                "password":textFieldPassword.text!
            ]
            
            
            Alamofire.request(URL_login, method: .post, parameters: parameters).responseJSON
                {
                    response in
                    print(response)
                    
                    if let result = response.result.value {
                        let jsonData = result as! NSDictionary
                        
                        if((jsonData.value(forKey: "return_code")) as! Int == 0){
                            
                            //getting user values
                            let userId = jsonData.value(forKey: "user_id")
                            self.userData.set(userId, forKey: "userid")
                            
                            if let gotUsername = jsonData["username"] {
                                let userName = gotUsername
                                self.userData.set(userName, forKey: "username")
                            }
                            
                            //saving user values to defaults
                            self.performSegue(withIdentifier: "gotoProfileFromLogin", sender: nil)
                        } else {
                            let error_title = jsonData.value(forKey: "error_title") as! String
                            let error_msg = jsonData.value(forKey: "error_message") as! String
                            self.labelMessage.text = error_title + " " + error_msg
                        }
                    }
                } //end Alamofire request
        
        }
        
    }
    
    
    @IBAction func buttonForgotPassword(_ sender: UIButton) {
        performSegue(withIdentifier: "gotoForgotPass", sender: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let backButton = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.plain, target: navigationController, action: nil)
        navigationItem.leftBarButtonItem = backButton
    }
    
    override func viewDidAppear(_ animated: Bool) {
        Alamofire.request(URL_checkLogin, method: .post).responseJSON
            {
                response in
                
                print(response)
                
                if let result = response.result.value {
                    let jsonData = result as! NSDictionary
                    
                    if((jsonData.value(forKey: "isLoggedIn")as! Int) == 1){
                        let profileViewController = self.storyboard?.instantiateViewController(withIdentifier: "ProfileViewController") as! ProfileViewController
                        self.navigationController?.pushViewController(profileViewController, animated: true)
                    }
                }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

