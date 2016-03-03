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
    @IBOutlet var display_dob_text_view: UITextView!
    
    // Refreshes the UI
    func refreshUI(){
        // Don't let user interact with displayed DOB.
        display_dob_text_view.userInteractionEnabled = false
        display_dob_text_view.editable = false
        display_dob_text_view.text = formatDate(health_kit.getAge())
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        refreshUI()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Formats date to make it readable
    func formatDate(date: NSDate) -> String{
        let date_formatter = NSDateFormatter()
        date_formatter.dateFormat = "MMM dd, yyyy"
        return date_formatter.stringFromDate(date)
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
