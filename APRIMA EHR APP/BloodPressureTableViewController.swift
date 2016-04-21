//
//  BloodPressureTableViewController.swift
//  APRIMA EHR APP
//
//  Created by henry dinh on 4/21/16.
//  Copyright © 2016 david nguyen. All rights reserved.
//

import UIKit
import HealthKit

class BloodPressureTableViewController: UITableViewController {

    // Used to refresh data
    var refresh_control = UIRefreshControl()
    let is_health_kit_enabled = NSUserDefaults.standardUserDefaults().boolForKey("is_health_kit_enabled")
    
    // initialize a HealthKit object to pull data from
    let health_kit: HealthKit = HealthKit()
    
    // Array of heart rate samples pulled from HealhKit
    var blood_pressures = [HKSample]()
    // Array of our HeartRate objects. Properties are timestamp and value
    var blood_pressure_objects = [BloodPressure]()
    
    
    let limit = 0
    
    // Refreshes the UI
    func refreshUI(){
        // Make sure the user authorized health kit before attempting to pull data
        if self.is_health_kit_enabled == true{
            let start_date = NSUserDefaults.standardUserDefaults().objectForKey("new_start_date") as! NSDate
            
            // Set up array of heart rate objects to use for displaying
            setUpBloodPressureObjects(start_date)
        }
    }
    
    
    // Sets up the array of Blood Pressure objects to display as table cells
    func setUpBloodPressureObjects(start_date: NSDate){
        // First clear array to make sure it's empty
        blood_pressure_objects.removeAll()
        
        self.health_kit.getBloodPressure(self.limit, start_date: start_date){ heart_rates, error in
            self.blood_pressures = heart_rates
        }
        // Format date to make it readable
        let date_formatter = NSDateFormatter()
        date_formatter.dateFormat = "MMM dd, yyyy hh:mm a"
        for b in self.blood_pressures as! [HKCorrelation]{
            let systolic_data = b.objectsForType(HKObjectType.quantityTypeForIdentifier(HKQuantityTypeIdentifierBloodPressureSystolic)!).first as? HKQuantitySample
            let diastolic_data = b.objectsForType(HKObjectType.quantityTypeForIdentifier(HKQuantityTypeIdentifierBloodPressureDiastolic)!).first as? HKQuantitySample
            
            let systolic_value = systolic_data!.quantity.doubleValueForUnit(HKUnit.millimeterOfMercuryUnit())
            let diastolic_value = diastolic_data!.quantity.doubleValueForUnit(HKUnit.millimeterOfMercuryUnit())

            
            let blood_pressure_object = BloodPressure(timestamp: date_formatter.stringFromDate(b.endDate), systolic_value: systolic_value, diastolic_value: diastolic_value)
            self.blood_pressure_objects.append(blood_pressure_object)
            print(blood_pressure_object.getTimestamp() + "\t" + String(blood_pressure_object.getSystolicValue()) + "-" + String(blood_pressure_object.getDiastolicValue()))
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
        self.refreshControl?.addTarget(self, action: #selector(BloodPressureTableViewController.refresh(_:)), forControlEvents: UIControlEvents.ValueChanged)
        
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
        return blood_pressure_objects.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Blood_Pressures", forIndexPath: indexPath)
        cell.textLabel?.text = blood_pressure_objects[indexPath.row].getTimestamp()
        cell.detailTextLabel?.text = String(blood_pressure_objects[indexPath.row].getSystolicValue()) + "-" + String(blood_pressure_objects[indexPath.row].getDiastolicValue())
        return cell
    }

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
