//
//  HeartRateTableViewController.swift
//  APRIMA EHR APP
//
//  Created by henry dinh on 3/22/16.
//  Copyright © 2016 david nguyen. All rights reserved.
//

import UIKit
import HealthKit

class HeartRateTableViewController: UITableViewController {
    
    // Used to store the user's data
//    let defaults = NSUserDefaults.standardUserDefaults()

    // initialize a HealthKit object to pull data from
    let health_kit: HealthKit = HealthKit()
    
    // View objects
//    @IBOutlet var display_heart_rate_text_view: UITextView!
    // Array of heart rate samples pulled from HealhKit
    var heart_rates = [HKSample]()
    // Array of our HeartRate objects. Properties are timestamp and value
    var heart_rate_objects = [HeartRate]()
    
    // Refreshes the UI
    func refreshUI(){
        // Don't allow user to interact with text views
//        self.display_heart_rate_text_view.userInteractionEnabled = false
//        self.display_heart_rate_text_view.editable = false
//        self.display_heart_rate_text_view.scrollEnabled = false
        
        // Make sure the user authorized health kit before attempting to pull data
        if Authorized.enabled == true{
            
            // Set up array of heart rate objects to use for displaying
            setUpHeartRateObjects()
            
            
            // Set up keys to store in NSUserDefaults
//            self.defaults.setObject(display_heart_rate_text_view.text, forKey: "heart_rate")
//            self.defaults.synchronize()
        }
    }
    
    func setUpHeartRateObjects(){
        self.health_kit.getHeartRate{ heart_rates, error in
            self.heart_rates = heart_rates
        }
        let heartRateUnit:HKUnit = HKUnit(fromString: "count/min")
        // Format date to make it readable
        let date_formatter = NSDateFormatter()
        date_formatter.dateFormat = "MMM dd, yyyy hh:mm a"
        for h in self.heart_rates as! [HKQuantitySample]{
            let heart_rate_object = HeartRate(timestamp: date_formatter.stringFromDate(h.endDate), value: h.quantity.doubleValueForUnit(heartRateUnit))
            self.heart_rate_objects.append(heart_rate_object)
            print(heart_rate_object.getTimestamp() + "\t" + String(heart_rate_object.getValue()))
        }
    }
    
    func refresh(sender:AnyObject)
    {
        // Updating your data here...
        
        self.tableView.reloadData()
        self.refreshControl?.endRefreshing()
        refreshUI()
    }
    
    // Called when the user loads the app so the data is restored
    func loadDefaults(){
//        display_heart_rate_text_view.text = self.defaults.objectForKey("heart_rate") as? String
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.refreshControl?.addTarget(self, action: #selector(HeartRateTableViewController.refresh(_:)), forControlEvents: UIControlEvents.ValueChanged)
        loadDefaults()
        refreshUI()
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
        return heart_rate_objects.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Heart_Rates", forIndexPath: indexPath)
        cell.textLabel?.text = heart_rate_objects[indexPath.row].getTimestamp()
        cell.detailTextLabel?.text = String(heart_rate_objects[indexPath.row].getValue())
        return cell
    }
    

    /*
    // Override to support conditional editing of the table view.z
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
