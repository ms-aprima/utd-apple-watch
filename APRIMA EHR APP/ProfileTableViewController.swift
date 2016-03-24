//
//  ProfileTableViewController.swift
//  APRIMA EHR APP
//
//  Created by henry dinh on 3/7/16.
//  Copyright © 2016 david nguyen. All rights reserved.
//

import UIKit
import HealthKit

class ProfileTableViewController: UITableViewController {
    
    // initialize a HealthKit object to pull data from
    let health_kit: HealthKit = HealthKit()
    
    // View objects
    @IBOutlet var display_dob_text_view: UITextView!
    @IBOutlet var display_sex_text_view: UITextView!
    @IBOutlet var display_height_text_view: UITextView!
    var height: HKQuantitySample!
    var h = 0.0
    
    // Refreshes the UI
    func refreshUI(){
        // Make sure the user authorized health kit before attempting to pull data
        if Authorized.enabled == true{
            // Used to store the user's data
            let defaults = NSUserDefaults.standardUserDefaults()
            
            // Don't let user interact with displayed text view.
            display_dob_text_view.userInteractionEnabled = false
            display_dob_text_view.editable = false
            display_dob_text_view.scrollEnabled = false
            display_dob_text_view.text = formatDate(health_kit.getBirthday())
            
            display_sex_text_view.userInteractionEnabled = false
            display_sex_text_view.editable = false
            display_sex_text_view.scrollEnabled = false
            display_sex_text_view.text = formatSex(health_kit.getSex())
            
            self.health_kit.getHight({ (height, error) -> Void in
                self.height = (height as? HKQuantitySample)!
                self.h = self.height.quantity.doubleValueForUnit(HKUnit.inchUnit())
                
            })
            display_sex_text_view.userInteractionEnabled = false
            display_sex_text_view.editable = false
            display_sex_text_view.scrollEnabled = false
            display_height_text_view.text = String(format: "%0.2f", h)
            
            
            // Syncronize/save the user's data
            defaults.setObject(display_dob_text_view.text, forKey: "date of birth")
            defaults.setObject(display_sex_text_view.text, forKey: "sex")
            defaults.setObject(display_height_text_view.text, forKey: "height")
            defaults.synchronize()
        }
    }
    
    // Called when the user loads the app so the data is restored
    func loadDefaults(){
        let defaults = NSUserDefaults.standardUserDefaults()
        display_dob_text_view.text = defaults.objectForKey("date of birth") as? String
        display_sex_text_view.text = defaults.objectForKey("sex") as? String
        display_height_text_view.text = defaults.objectForKey("height") as? String
    }
    
    // Called everytime the UI is displayed (i.e. the user goes to the profile tab)
    override func viewWillAppear(animated: Bool) {
        refreshUI()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        loadDefaults()
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
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
    
    // Formats the sex to display it as text
    func formatSex(biological_sex: HKBiologicalSexObject) -> String{
        var sex: String
        let bio_sex = biological_sex.biologicalSex
        switch bio_sex.rawValue{
        case 0:
            sex = ""
        case 1:
            sex = "Female"
        case 2:
            sex = "Male"
        case 3:
            sex = "Other"
        default:
            sex = ""
        }
        return sex
    }

    // MARK: - Table view data source

//    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
//        // #warning Incomplete implementation, return the number of sections
//        return 0
//    }

//    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        // #warning Incomplete implementation, return the number of rows
//        return 0
//    }

    /*
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
