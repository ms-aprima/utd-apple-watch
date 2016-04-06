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
    let health_kit: HealthKit = HealthKit()
    let is_health_kit_enabled = NSUserDefaults.standardUserDefaults().boolForKey("is_health_kit_enabled")
    
    // View objects
    @IBOutlet var display_steps_text_view: UITextView!
    var steps = [HKSample]()
    
    // Refreshes the UI
    func refreshUI(){
        // Make sure the user authorized health kit before attempting to pull data
        if self.is_health_kit_enabled == true{
            //display_steps_text_view = health_kit.getSteps()
        
            health_kit.getSteps { steps, error in
                self.steps = steps
            }
            display_steps_text_view.userInteractionEnabled = false
            display_steps_text_view.editable = false
            var t = ""
            for step in steps as! [HKQuantitySample]{
                t += String(format: "%0.2f: " + String(step.endDate) + "\n\n",step.quantity.doubleValueForUnit(HKUnit.countUnit()))
            }
            
            display_steps_text_view.text = t
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
    
    /*
     // MARK: - Navigation
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}