//
//  SecondViewController.swift
//  APRIMA EHR APP
//
//  Created by david on 2/17/16.
//  Copyright © 2016 david nguyen. All rights reserved.
//

import UIKit


class HealthDataViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    // MARK: - Segues
    // Let individual table cells segue into new table views. i.e. fitness --> fitness table view
//    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
//        if segue.identifier ==  fitness_segue_identifier {
//            if let fitness_view_controller = segue.destinationViewController as? FitnessViewController {
//                fitness_view_controller.healthManager = healthManager
//            }
//        }
//    }
    
//    @IBAction func authroizeHealthKit(){
//        hk_store.authorize()
//    }
//    
//    @IBAction func updateStepCOunt(){
//        hk_store.getSteps { steps, error in
//            self.steps_data.text = String(format: "%0.2f", steps)
//        }
//        steps_data.text = "5248"
//        
//    }


}

