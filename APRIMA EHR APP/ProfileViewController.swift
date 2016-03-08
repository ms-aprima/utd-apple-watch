//
//  ProfileViewController.swift
//  APRIMA EHR APP
//
//  Created by henry dinh on 2/23/16.
//  Copyright © 2016 david nguyen. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {
    
    // initialize a HealthKit object to pull data from
    let health_kit: HealthKit = HealthKit()
    
    // View objects
    
    @IBOutlet var table_view: UITableView!
    
    // Refreshes the UI
    func refreshUI(){
        // Make sure the user authorized health kit before attempting to pull data
        if Authorized.enabled == true{
            
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    // Called everytime the UI is displayed (i.e. the user goes to the profile tab)
    override func viewWillAppear(animated: Bool) {
        refreshUI()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
