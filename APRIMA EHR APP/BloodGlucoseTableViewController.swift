//
//  BloodGlucoseTableViewController.swift
//  APRIMA EHR APP
//
//  Created by david on 3/30/16.
//  Copyright © 2016 david nguyen. All rights reserved.
//

import UIKit
import HealthKit

class BloodGlucoseTableViewController: UITableViewController {

    // Use defaults to save important stuff (like if health kit is enabled)
    let defaults = NSUserDefaults.standardUserDefaults()
    let is_health_kit_enabled = NSUserDefaults.standardUserDefaults().boolForKey("is_health_kit_enabled")
    let limit = 0
    
    let health_kit: HealthKit = HealthKit()
    
    // View objects
   // @IBOutlet var display_blood_glucose_text_view: UITextView!
    var bloodglucose = [HKSample]()
    //var h_r = 0.0
    var blood_glucose_objects = [BloodGlucose]()

    
    // Sets up the array of HeartRate objects to display as table cells
    func setUpBloodGlucoseObjects(start_date: NSDate){
        // First clear array to make sure it's empty
        blood_glucose_objects.removeAll()
        self.health_kit.getBloodGlucose(self.limit, start_date: start_date){ bloodgs, error in
            self.bloodglucose = bloodgs
        }
        
        let bloodGUNIT:HKUnit = HKUnit(fromString: "mg/dL")
        
        let date_formatter = NSDateFormatter()
        date_formatter.dateFormat = "MMM dd, yyyy hh:mm a"
        for bg in self.bloodglucose as! [HKQuantitySample]{
            let blood_glucose_object = BloodGlucose(timestamp: date_formatter.stringFromDate(bg.endDate), value: bg.quantity.doubleValueForUnit(bloodGUNIT))
            self.blood_glucose_objects.append(blood_glucose_object)
            print(blood_glucose_object.getTimestamp() + "\t" + String(blood_glucose_object.getValue()))
        }
    }

    
    
    // Refreshes the UI
    func refreshUI(){
        // Make sure the user authorized health kit before attempting to pull data
        if self.is_health_kit_enabled == true{
            let start_date = NSUserDefaults.standardUserDefaults().objectForKey("new_start_date") as! NSDate

            // Set up array of heart rate objects to use for displaying
            setUpBloodGlucoseObjects(start_date)
        }
    }

    
    // refresh data and UI
    func refresh(sender: AnyObject) {
        // Updating your data here...
        self.tableView.reloadData()
        self.refreshControl?.endRefreshing()
        self.refreshUI()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // set up the pull to refresh
        self.refreshControl?.addTarget(self, action: #selector(BloodGlucoseTableViewController.refresh(_:)), forControlEvents: UIControlEvents.ValueChanged)
        self.refreshUI()
    }
    
    
    override func viewWillAppear(animated: Bool) {
        refreshUI()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    //    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
    //        // #warning Incomplete implementation, return the number of sections
    //        return 0
    //    }
    //
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        refreshUI()
        return blood_glucose_objects.count
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Blood_Glucoses", forIndexPath: indexPath)
        cell.textLabel?.text = blood_glucose_objects[indexPath.row].getTimestamp()
        cell.detailTextLabel?.text = String(blood_glucose_objects[indexPath.row].getValue())
        return cell
    }

    // MARK: - Table view data source

   // override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
    //    return 0
   // }

    //override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
      //  return 0
    //}

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
