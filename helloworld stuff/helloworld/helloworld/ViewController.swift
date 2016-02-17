//
//  ViewController.swift
//  helloworld
//
//  Created by macOS on 2/4/16.
//  Copyright © 2016 macOS. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet var inputTextField : UITextField!
    @IBOutlet var resultsTextView : UITextView! 
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func buttonTapped(sender : AnyObject){
        var input = 0.0
        input = Double((inputTextField.text! as NSString).doubleValue)
        input += 10
        resultsTextView.text = String(format: "%0.2f", input)
    }
    @IBAction func viewTapped(sender : AnyObject) {
        inputTextField.resignFirstResponder()
    }

}

