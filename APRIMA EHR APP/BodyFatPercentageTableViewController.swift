//
//  BodyFatPercentageTableViewController.swift
//  APRIMA EHR APP
//
//  Created by henry dinh on 4/21/16.
//  Copyright © 2016 david nguyen. All rights reserved.
//

import UIKit
import HealthKit

class BodyFatPercentageTableViewController: UITableViewController {

    // Used to refresh data
    var refresh_control = UIRefreshControl()
    let is_health_kit_enabled = NSUserDefaults.standardUserDefaults().boolForKey("is_health_kit_enabled")
    
    // initialize a HealthKit object to pull data from
    let health_kit: HealthKit = HealthKit()
    
    // Array of body fat percentage samples pulled from HealhKit
    var body_fat_percentages = [HKSample]()
    // Array of our body fat percentage objects. Properties are timestamp and value
    var body_fat_percentage_objects = [BodyFatPercentage]()
    
    // Show all samples
    let limit = 0
    
    // Refreshes the UI
    func refreshUI(){
        // Make sure the user authorized health kit before attempting to pull data
        if self.is_health_kit_enabled == true{
            let start_date = NSUserDefaults.standardUserDefaults().objectForKey("new_start_date") as! NSDate
            
            // Set up array of heart rate objects to use for displaying
            setUpBodyFatPercentageObjects(start_date)
        }
    }
    
    
    // Sets up the array of BodyFatPercentage objects to display as table cells
    func setUpBodyFatPercentageObjects(start_date: NSDate){
        // First clear array to make sure it's empty
        body_fat_percentage_objects.removeAll()
        
        self.health_kit.getBodyFatPercentage(self.limit, start_date: start_date){ body_fat_percentages, error in
            self.body_fat_percentages = body_fat_percentages
        }
        let body_fat_percentage_unit: HKUnit = HKUnit(fromString: "%")
        // Format date to make it readable
        let date_formatter = NSDateFormatter()
        date_formatter.dateFormat = "MMM dd, yyyy hh:mm a"
        for h in self.body_fat_percentages as! [HKQuantitySample]{
            let body_fat_percentage_object = BodyFatPercentage(timestamp: date_formatter.stringFromDate(h.endDate), value: h.quantity.doubleValueForUnit(body_fat_percentage_unit))
            self.body_fat_percentage_objects.append(body_fat_percentage_object)
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
        self.refreshControl?.addTarget(self, action: #selector(BodyFatPercentageTableViewController.refresh(_:)), forControlEvents: UIControlEvents.ValueChanged)
        
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
        return self.body_fat_percentage_objects.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Body_fat_percentages", forIndexPath: indexPath)
        cell.textLabel?.text = self.body_fat_percentage_objects[indexPath.row].getTimestamp()
        cell.detailTextLabel?.text = String(self.body_fat_percentage_objects[indexPath.row].getValue() * 100.0) + "%"
        return cell
    }
}
