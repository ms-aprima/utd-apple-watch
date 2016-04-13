//
//  FirstViewController.swift
//  APRIMA EHR APP
//
//  Created by david on 2/17/16.
//  Copyright © 2016 david nguyen. All rights reserved.
//

import UIKit
import HealthKit



class HomeViewController: UIViewController {
    
    // Used to store the user's data
    let defaults = NSUserDefaults.standardUserDefaults()
    let is_health_kit_enabled = NSUserDefaults.standardUserDefaults().boolForKey("is_health_kit_enabled")
    
    
    // initialize a HealthKit object to pull data from
    let health_kit: HealthKit = HealthKit()
    
    
    let limit = 0
    
    // Object arrays
    var heart_rates = [HKSample]()
    var heart_rate_objects = [HeartRate]()
    var stepcount = [HKSample]()
    var steps_objects = [Steps]()
    var weight = [HKSample]()
    var weight_objects = [Weight]()
    var bloodglucose = [HKSample]()
    var blood_glucose_objects = [BloodGlucose]()
    
    
    @IBOutlet var sync_button: UIButton!
    
    @IBAction func syncButtonTapped(){
        
        // Make sure the user authorized health kit before attempting to pull data
        if self.is_health_kit_enabled == true{
            let start_date = NSUserDefaults.standardUserDefaults().objectForKey("new_start_date") as! NSDate
//
//            // SET UP DATA
            self.setUpHeartRateObjects(start_date)
            self.setUpStepsObjects()
            self.setUpWeightObjects(start_date)
            self.setUpBloodGlucoseObjects(start_date)
        
        
        
            // Get the patient ID and JsonWebToken from NSUserdefaults
            let patient_id = self.defaults.objectForKey("patient_id") as! String
            let json_web_token = self.defaults.objectForKey("json_web_token") as! String
        
            // URL to send POST request to
            let url: NSURL = NSURL(string: "https://aprod-sbt2.servicebus.windows.net/7083c80b-29e2-4ee8-a485-3a3fdf373f58/api/v1/patients/\(patient_id)/attachmentscsv")!
        
            print("Patient ID: \(patient_id)")
            print("Json Web Token: \(json_web_token)")
            print("url: \(url)")
        
            // Make sure to set up post body, which will be the data (formatted) to send
            // TO DO - Set up post body here
            // let post_data = ...
        
            // create a session for the POST request
            let session = NSURLSession.sharedSession()
        
            // Create the POST request
            let request:NSMutableURLRequest = NSMutableURLRequest(URL: url)
            request.HTTPMethod = "POST"
            //        request.HTTPBody = post_data
            // Add headers
            request.setValue("application/json", forHTTPHeaderField: "Accept")
            request.setValue("C83BBF42-DA17-4F58-9AA0-68F417419313", forHTTPHeaderField: "ApiKey")
            request.setValue("application/json;charset=UTF-8", forHTTPHeaderField: "Content-Type")
            request.setValue("\(json_web_token)", forHTTPHeaderField: "Auth-Token")
        
        
        
        
        
        
        
            defaults.setObject(NSDate(), forKey: "new_start_date")
            defaults.synchronize()
        }
    }
    
    // Sets up the array of HeartRate objects to display as table cells
    func setUpHeartRateObjects(start_date: NSDate){
        // First clear array to make sure it's empty
        heart_rate_objects.removeAll()
        
        self.health_kit.getHeartRate(self.limit, start_date: start_date){ heart_rates, error in
            self.heart_rates = heart_rates
        }
        let heartRateUnit:HKUnit = HKUnit(fromString: "count/min")
        // Format date to make it readable
        let date_formatter = NSDateFormatter()
        date_formatter.dateFormat = "MMM dd, yyyy hh:mm a"
        for h in self.heart_rates as! [HKQuantitySample]{
            let heart_rate_object = HeartRate(timestamp: date_formatter.stringFromDate(h.endDate), value: h.quantity.doubleValueForUnit(heartRateUnit))
            self.heart_rate_objects.append(heart_rate_object)
            //            print(heart_rate_object.getTimestamp() + "\t" + String(heart_rate_object.getValue()))
        }
    }
    
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
    
    func setUpWeightObjects(start_date: NSDate)
    {
        
        weight_objects.removeAll()
        
        
        self.health_kit.getWeight2(self.limit, start_date: start_date){ weight, error in
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
    
    // Sets up the array of HeartRate objects to display as table cells
    func setUpBloodGlucoseObjects(start_date: NSDate){
        // First clear array to make sure it's empty
        blood_glucose_objects.removeAll()
        self.health_kit.getBloodGlucose(self.limit, start_date: start_date){bloodgs, error in
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
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    override func viewDidAppear(animated: Bool){
        // Automatically switch to login scene if user is not logged in
        if(!defaults.boolForKey("is_user_logged_in")){
            self.performSegueWithIdentifier("login_view_segue", sender: self)
        }

    }
}

//import AVFoundation
//
////code to play music
//class MusicHelper {
//    static let sharedHelper = MusicHelper()
//    var audioPlayer: AVAudioPlayer?
//    
//    func playBackgroundMusic() {
//        let aSound = NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("way-to-success", ofType: "mp3")!)
//        do {
//            audioPlayer = try AVAudioPlayer(contentsOfURL:aSound)
//            audioPlayer!.numberOfLoops = -1
//            audioPlayer!.prepareToPlay()
//            audioPlayer!.play()
//        } catch {
//            print("Cannot play the file")
//        }
//    }
//}
