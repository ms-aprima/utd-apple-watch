//
//  ViewController.swift
//  HelloWorldApp
//
//  Created by david on 1/30/16.
//  Copyright © 2016 david nguyen. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

   
    @IBOutlet weak var displaylabel: UILabel!
    
    @IBAction func buttontapped(sender: UIButton) {
        displaylabel.text = "Hello World!"
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

