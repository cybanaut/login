//
//  ProfileViewConroller.swift
//  login
//
//  Created by waynehui on 14/1/18.
//  Copyright © 2018 waynehui. All rights reserved.
//

import UIKit
import Alamofire

class ProfileViewController: UIViewController{
    
    @IBOutlet weak var ImageProfilePic: UIImageView!
    
    @IBOutlet weak var labelUsername: UILabel!
    
    let URL_logout = "http://tester.onyourblog.com/server/submitLogout.php"
    
    let URL_checkLogin = "http://tester.onyourblog.com/server/checkLogin.php"
    
    @IBAction func buttonLogout(_ sender: UIButton) {

        Alamofire.request(URL_logout, method: .post).responseJSON
            {
                response in
                
                print(response)
                
                UserDefaults.standard.removePersistentDomain(forName: Bundle.main.bundleIdentifier!)
                UserDefaults.standard.synchronize()
                
                let loginViewController = self.storyboard?.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
                self.navigationController?.pushViewController(loginViewController, animated: true)
                self.dismiss(animated: false, completion: nil)
                
        }
        
        
    }
    
    
    
    @IBAction func checkLogin(_ sender: UIButton) {
        Alamofire.request(URL_checkLogin, method: .post).responseJSON
            {
                response in
                
                print(response)
                
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let backButton = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.plain, target: navigationController, action: nil)
        navigationItem.leftBarButtonItem = backButton
        
        let defaultValues = UserDefaults.standard
        
        if defaultValues.string(forKey: "userid") == nil {
            let loginViewController = self.storyboard?.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
            self.navigationController?.pushViewController(loginViewController, animated: true)
            self.dismiss(animated: false, completion: nil)
            
        } else {
            if let firstname = defaultValues.string(forKey: "username") {
                
                labelUsername.text = firstname
                
                /*
                 if let profileImgUrl = defaultValues.string(forKey: "profileImage") {
                 load_image(image_url_string: profileImgUrl, view: ImageProfilePic)
                 }
                 */
                
            } else {
                labelUsername.text = "Guess"
            }
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
   /*
    func load_image(image_url_string:String, view:UIImageView) {
        /*
         var image_url: NSURL = NSURL(string: image_url_string)!
         let image_from_url_request: NSURLRequest = NSURLRequest(URL: image_url as URL)
         NSURLConnection.sendAsynchronousRequest(image_from_url_request as URLRequest,
         queue: OperationQueue.main,
         completionHandler:{(
         response: URLResponse!,
         data: NSData!,
         error: NSError!) -> Void in
         if error == nil && data != nil {
         view.image = UIImage(data:data)
         }
         }) */
        let session = URLSession(configuration: .default)
        
        //creating a dataTask
        let getImageFromUrl = session.dataTask(with: image_url_string) { (data, response, error) in
            
            //if there is any error
            if let e = error {
                //displaying the message
                print("Error Occurred: \(e)")
                
            } else {
                //in case of now error, checking wheather the response is nil or not
                if (response as? HTTPURLResponse) != nil {
                    
                    //checking if the response contains an image
                    if let imageData = data {
                        
                        //getting the image
                        let image = UIImage(data: imageData)
                        
                        //displaying the image
                        view.image = image
                        
                    } else {
                        print("Image file is currupted")
                    }
                } else {
                    print("No response from server")
                }
            }
        }
        
        //starting the download task
        getImageFromUrl.resume()
    }
*/
}


