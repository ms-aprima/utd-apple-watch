//
//  StepsViewController.swift
//  APRIMA EHR APP
//
//  Created by henry dinh on 3/2/16.
//  Copyright © 2016 david nguyen. All rights reserved.
//
import UIKit
import HealthKit

class StepsViewController: UITableViewController {
    
    // initialize a HealthKit object to pull data from
    let defaults = NSUserDefaults.standardUserDefaults()
    let is_health_kit_enabled = NSUserDefaults.standardUserDefaults().boolForKey("is_health_kit_enabled")
    
    let health_kit: HealthKit = HealthKit()
    
    // View objects
    //@IBOutlet var display_steps_text_view: UITextView!
    var stepcount = [HKSample]()
    var steps_objects = [Steps]()
    
    func setUpStepsObjects(){
        steps_objects.removeAll()
        
        self.health_kit.getSteps{stepcount, error in
            self.stepcount = stepcount
        }
        
        
        
        let date_formatter = NSDateFormatter()
        date_formatter.dateFormat = "MMM dd, yyyy hh:mm a"
        for s in self.stepcount as! [HKQuantitySample]{
            let steps_object = Steps(timestamp: date_formatter.stringFromDate(s.endDate), value: s.quantity.doubleValueForUnit(HKUnit.countUnit()))
            self.steps_objects.append(steps_object)
            print(steps_object.getTimestamp() + "\t" + String(steps_object.getValue()))
        }
        
        
    }
    
    // Refreshes the UI
    func refreshUI(){
        // Make sure the user authorized health kit before attempting to pull data
        if self.is_health_kit_enabled == true{
            
            setUpStepsObjects()
                  
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.refreshControl?.addTarget(self, action: #selector(StepsViewController.refresh(_:)), forControlEvents: UIControlEvents.ValueChanged)
        // Do any additional setup after loading the view.
        refreshUI()
    }
    
    override func viewWillAppear(animated: Bool) {
        refreshUI()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func refresh(sender:AnyObject)
    {
        // Updating your data here...
        
        self.tableView.reloadData()
        self.refreshControl?.endRefreshing()
        refreshUI()
    }
    
    
    
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