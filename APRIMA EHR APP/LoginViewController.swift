//
//  LoginViewController.swift
//  APRIMA EHR APP
//
//  Created by henry dinh on 3/29/16.
//  Copyright © 2016 david nguyen. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
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
        // Check username and password credentials here. TO-DO later
        
        //If login is successful, save that user is logged in and go back to home scene
        // For now, jst go back to home scene if login button is pressed
        self.dismissViewControllerAnimated(true, completion: nil)
        defaults.setBool(true, forKey: "is_user_logged_in")
        defaults.synchronize()
        
        // If login is not successful, do this instead
        
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
