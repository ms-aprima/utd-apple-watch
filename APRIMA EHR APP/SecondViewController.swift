//
//  SecondViewController.swift
//  APRIMA EHR APP
//
//  Created by david on 2/17/16.
//  Copyright © 2016 david nguyen. All rights reserved.
//

import UIKit


class SecondViewController: UIViewController {
    let hKit = healthKit()
    
    @IBOutlet weak var steps_data: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func authroizeHealthKit(){
        hKit.authorize()
    }
    
    @IBAction func updateStepCOunt(){
        hKit.getSteps { steps, error in
            self.steps_data.text = String(format: "%0.2f", steps)
        }
        steps_data.text = "5248"
        
    }


}

