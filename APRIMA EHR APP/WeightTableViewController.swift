//
//  WeightTableViewController.swift
//  APRIMA EHR APP
//
//  Created by Timmy on 4/5/16.
//  Copyright © 2016 david nguyen. All rights reserved.
//
import HealthKit
import UIKit

class WeightTableViewController: UITableViewController {
    
    
    //@IBOutlet var display_weight_text_view: UITextView!
    var refresh_control = UIRefreshControl()
    let is_health_kit_enabled = NSUserDefaults.standardUserDefaults().boolForKey("is_health_kit_enabled")
    
    //init healthkit obj to pull data
    let health_kit: HealthKit = HealthKit()
    
    //array of weight data pulled from HK
    var weight = [HKSample]()
    //array of Weight objects.
    var weight_objects = [Weight]()
    
    func refreshUI()
    {
        
        if self.is_health_kit_enabled == true
        {
            setUpWeightObjects()
        }
    }
    
    func setUpWeightObjects()
    {
        
        weight_objects.removeAll()
        
        
        self.health_kit.getWeight2{ weight, error in
            self.weight = weight
        }
        
        let weightUnit:HKUnit = HKUnit(fromString: "lb")
        // Format date to make it readable
        let date_formatter = NSDateFormatter()
        date_formatter.dateFormat = "MMM dd, yyyy hh:mm a"
        for h in self.weight as! [HKQuantitySample]{
            let weight_object = Weight(timestamp: date_formatter.stringFromDate(h.endDate), value: h.quantity.doubleValueForUnit(weightUnit))
            self.weight_objects.append(weight_object)
            print(weight_object.getTimestamp() + "\t" + String(weight_object.getValue()))
        }
    }
    
    func refresh(sender: AnyObject) {
        // Updating your data here...
        self.tableView.reloadData()
        self.refreshControl?.endRefreshing()
        self.refreshUI()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        // set up the pull to refresh
        self.refreshControl?.addTarget(self, action: #selector(WeightTableViewController.refresh(_:)), forControlEvents: UIControlEvents.ValueChanged)
        
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
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        refreshUI()
        return weight_objects.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Weights", forIndexPath: indexPath)
        cell.textLabel?.text = weight_objects[indexPath.row].getTimestamp()
        cell.detailTextLabel?.text = String(weight_objects[indexPath.row].getValue())
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