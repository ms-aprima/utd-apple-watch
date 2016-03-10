//
//  StepsViewController.swift
//  APRIMA EHR APP
//
//  Created by henry dinh on 3/2/16.
//  Copyright © 2016 david nguyen. All rights reserved.
//

import UIKit

class StepsViewController: UIViewController {
    
    // initialize a HealthKit object to pull data from
    let health_kit: HealthKit = HealthKit()
    
    // View objects
    @IBOutlet var display_steps_text_view: UITextView!
    var steps = ""

    // Refreshes the UI
    func refreshUI(){
        //display_steps_text_view = health_kit.getSteps(<#T##completion: (Double, NSError?) -> ()##(Double, NSError?) -> ()#>)
        
        health_kit.getSteps { steps, error in
            self.steps = String(format: "%0.2f", steps)
        }
        display_steps_text_view.userInteractionEnabled = false
        display_steps_text_view.editable = false
        display_steps_text_view.text = steps
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
