//
//  LoginViewController.swift
//  APRIMA EHR APP
//
//  Created by henry dinh on 3/29/16.
//  Copyright © 2016 david nguyen. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController, UITextFieldDelegate {
    
    // Used to store the user's data
    let defaults = NSUserDefaults.standardUserDefaults()
    
    @IBOutlet var username_text_field: UITextField!
    @IBOutlet var password_text_field: UITextField!
    @IBOutlet var login_button: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func loginButtonTapped(){
        // get username and password entered
        let username: NSString = username_text_field.text!
        let password: NSString = password_text_field.text!
        
        if(username.isEqualToString("") || password.isEqualToString("")){
            // Check if username or password are empty. If it is, display alert
            let alertController = UIAlertController(title: "Sign in Failed!", message: "Please enter Username and Password", preferredStyle: .Alert)
            let OKAction = UIAlertAction(title: "OK", style: .Default) { (action) in }
            alertController.addAction(OKAction)
            self.presentViewController(alertController, animated: true) { }
        }else{
            // JSON login data for body of message
            let post_body: NSString = "{\"UserName\":\"\(username)\",\"Password\":\"\(password)\"}"
            print(post_body)
            
            // URL to send POST request to
            let url: NSURL = NSURL(string: "https://aprod-sbt2.servicebus.windows.net/7083c80b-29e2-4ee8-a485-3a3fdf373f58/api/patient/v1/login")!
            
            // stuff
            let post_data:NSData = post_body.dataUsingEncoding(NSASCIIStringEncoding)!
            
            //let post_length:NSString = String( post_data.length )
            
            let session = NSURLSession.sharedSession()
            
            // Create the POST request
            let request:NSMutableURLRequest = NSMutableURLRequest(URL: url)
            request.HTTPMethod = "POST"
            request.HTTPBody = post_data
            // Add headers
            request.setValue("application/json", forHTTPHeaderField: "Accept")
            request.setValue("C83BBF42-DA17-4F58-9AA0-68F417419313", forHTTPHeaderField: "ApiKey")
            request.setValue("application/json;charset=UTF-8", forHTTPHeaderField: "Content-Type")
            
            let task = session.dataTaskWithRequest(request, completionHandler: {urlData, response, error -> Void in
                if (urlData != nil) {
                    let res = response as! NSHTTPURLResponse!;
                    print(res)
                    if 200..<300 ~= res.statusCode {
                        //If login is successful, save that user is logged in and go back to home scene
                        do {
                            let jsonData:NSDictionary = try NSJSONSerialization.JSONObjectWithData(urlData!, options:NSJSONReadingOptions.MutableContainers ) as! NSDictionary
                            print(jsonData)
                            //On success, invoke `completion` with passing jsonData.
                            let sessionId:String = jsonData.valueForKey("Id") as! String
                            if(sessionId != "") {
                                
                                self.defaults.setObject(username, forKey: "username")
                                self.defaults.setObject(sessionId, forKey: "session_id")
                                self.defaults.setBool(true, forKey: "is_user_logged_in")
                                self.defaults.synchronize()
                                
                                self.dismissViewControllerAnimated(true, completion: nil)
                            } else {
                                
                                /* var error_msg:NSString
                                 if jsonData["error_message"] as? NSString != nil {
                                 error_msg = jsonData["error_message"] as! NSString
                                 } else {
                                 error_msg = "Unknown Error"
                                 } */
                                
                                dispatch_async(dispatch_get_main_queue(), {
                                    
                                    let alertController = UIAlertController(title: "Sign in Failed!", message: "Failed to retrieve data", preferredStyle: .Alert)
                                    let OKAction = UIAlertAction(title: "OK", style: .Default) { (action) in }
                                    alertController.addAction(OKAction)
                                    self.presentViewController(alertController, animated: true) { }
                                })
                            }
                        } catch _ as NSError {
                            dispatch_async(dispatch_get_main_queue(), {
                                
                                let alertController = UIAlertController(title: "Sign in Failed!", message: "Server error", preferredStyle: .Alert)
                                let OKAction = UIAlertAction(title: "OK", style: .Default) { (action) in }
                                alertController.addAction(OKAction)
                                self.presentViewController(alertController, animated: true) { }
                            })
                        }
                    } else {
                        dispatch_async(dispatch_get_main_queue(), {
                            
                            let alertController = UIAlertController(title: "Sign in Failed!", message: "Check Credentials", preferredStyle: .Alert)
                            let OKAction = UIAlertAction(title: "OK", style: .Default) { (action) in }
                            alertController.addAction(OKAction)
                            self.presentViewController(alertController, animated: true) { }
                        })
                    }
                } else {
                    dispatch_async(dispatch_get_main_queue(), {
                        let alertController = UIAlertController(title: "Sign in Failed!", message: "Check Internet Connection", preferredStyle: .Alert)
                        let OKAction = UIAlertAction(title: "OK", style: .Default) { (action) in }
                        alertController.addAction(OKAction)
                        self.presentViewController(alertController, animated: true) { }
                    })
                }
            })
            task.resume()
        }
        
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
