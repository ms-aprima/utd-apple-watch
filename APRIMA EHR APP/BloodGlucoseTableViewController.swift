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

    
    let defaults = NSUserDefaults.standardUserDefaults()
    let health_kit: HealthKit = HealthKit()
    
    // View objects
   // @IBOutlet var display_blood_glucose_text_view: UITextView!
    var bloodglucose = [HKSample]()
    //var h_r = 0.0
    var blood_glucose_objects = [BloodGlucose]()
    
    // Refreshes the UI
    func refreshUI(){
        // Don't allowo user to interact with text views
//        self.display_blood_glucose_text_view.userInteractionEnabled = false
//        self.display_blood_glucose_text_view.editable = false
//        self.display_blood_glucose_text_view.scrollEnabled = false
//        
//         Make sure the user authorized health kit before attempting to pull data
            if Authorized.enabled == true{
                
                setUpBloodGlucoseObjects()
               

  
        }
   }
    
    // Called when the user loads the app so the data is restored
//    func loadDefaults(){
//        display_heart_rate_text_view.text = self.defaults.objectForKey("heart_rate") as? String
//    }
    
    func setUpBloodGlucoseObjects(){

        self.health_kit.getBloodGlucose{bloodgs, error in
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
        
//        health_kit.getBloodGlucose{ bloodg, error in
//            self.bloodglucose = bloodg
//        }
//        display_blood_glucose_text_view.userInteractionEnabled = false
//        display_blood_glucose_text_view.editable = false
//        var bg = ""
//        for bloodg in bloodglucose as! [HKQuantitySample]{
//            bg += String(format: "%0.2f: " + String(bloodg.endDate) + "\n\n", bloodg.quantity.(HKUnit.countUnit()))
//        }
//        
//        display_blood_glucose_text_view.text = bg
    
    }
    override func viewDidLoad() {
        super.viewDidLoad()
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
