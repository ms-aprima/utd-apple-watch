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
    var is_health_kit_enabled = NSUserDefaults.standardUserDefaults().boolForKey("is_health_kit_enabled")
    
    
    // initialize a HealthKit object to pull data from
    let health_kit: HealthKit = HealthKit()
    
    var sync_times_timestamps = [String]()
    var sync_times_data = [String]()
    
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
    var sex = ""
    var dob = ""
    var bloodType = ""
    var height: HKQuantitySample!
    var h = 0.0
    var blood_pressures = [HKSample]()
    var blood_pressure_objects = [BloodPressure]()
    var body_fat_percentages = [HKSample]()
    var body_fat_percentage_objects = [BodyFatPercentage]()
    
    
    // Post body to be set up and formatted
    var post_body = ""
    
    @IBOutlet var sync_button: UIButton!
    
    @IBAction func syncButtonTapped(){
        
        // Make sure the user authorized health kit before attempting to pull data
        if self.is_health_kit_enabled == true{
            let start_date = defaults.objectForKey("new_start_date") as! NSDate
            print("Hello")
            print(start_date)

            // SET UP DATA
            self.setUpHeartRateObjects(start_date)
            self.setUpStepsObjects(start_date)
            self.setUpWeightObjects(start_date)
            self.setUpBloodGlucoseObjects(start_date)
            self.sex=formatSex(health_kit.getSex())
            self.dob=formatDateofBirth(health_kit.getBirthday())
            self.bloodType = health_kit.getBloodType()
            setHeight()
            self.setUpBloodPressureObjects(start_date)
            self.setUpBodyFatPercentageObjects(start_date)

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
            self.formatPostBody()
            let post_body_NSString: NSString = self.post_body
            print(post_body_NSString)
            
            // Store stnc time and data to array to display
            self.sync_times_timestamps =  NSUserDefaults.standardUserDefaults().objectForKey("sync_times_timestamp") as! [String]
            self.sync_times_data = NSUserDefaults.standardUserDefaults().objectForKey("sync_times_data") as! [String]
            let date_formatter = NSDateFormatter()
            date_formatter.dateFormat = "MMM dd, yyyy hh:mm a"
            let sync_time = SyncTime(timestamp: date_formatter.stringFromDate(NSDate()), data: self.post_body)
            self.sync_times_timestamps.append(sync_time.getTimestamp())
//            self.sync_times_data.append(sync_time.getData())
            self.sync_times_data.append("hi")
            
            // Encode post data
            let post_data:NSData = post_body_NSString.dataUsingEncoding(NSASCIIStringEncoding)!
        
            // create a session for the POST request
            let session = NSURLSession.sharedSession()
        
            // Create the POST request
            let request:NSMutableURLRequest = NSMutableURLRequest(URL: url)
            request.HTTPMethod = "POST"
            request.HTTPBody = post_data
            // Add headers
            request.setValue("application/json", forHTTPHeaderField: "Accept")
            request.setValue("C83BBF42-DA17-4F58-9AA0-68F417419313", forHTTPHeaderField: "ApiKey")
            request.setValue("application/json;charset=UTF-8", forHTTPHeaderField: "Content-Type")
            request.setValue("\(json_web_token)", forHTTPHeaderField: "Auth-Token")
        
            // Do this task
            let task = session.dataTaskWithRequest(request, completionHandler: {urlData, response, error -> Void in
                if (urlData != nil) {
                    // Get the response and print it
                    let res = response as! NSHTTPURLResponse!;
                    print(res)
                    if 200..<300 ~= res.statusCode {
                        //If sending is successful
                        do {
                            let jsonData:NSDictionary = try NSJSONSerialization.JSONObjectWithData(urlData!, options:NSJSONReadingOptions.MutableContainers ) as! NSDictionary
                            print(jsonData)
                        } catch _ as NSError {
                            dispatch_async(dispatch_get_main_queue(), {
                                
                                let alertController = UIAlertController(title: "Sending failed!", message: "Server error", preferredStyle: .Alert)
                                let OKAction = UIAlertAction(title: "OK", style: .Default) { (action) in }
                                alertController.addAction(OKAction)
                                self.presentViewController(alertController, animated: true) { }
                            })
                        }
                    }else {
                        dispatch_async(dispatch_get_main_queue(), {
                            
                            let alertController = UIAlertController(title: "Syncing unsuccessful!", message: "Unable to send data", preferredStyle: .Alert)
                            let OKAction = UIAlertAction(title: "OK", style: .Default) { (action) in }
                            alertController.addAction(OKAction)
                            self.presentViewController(alertController, animated: true) { }
                        })
                    }
                }else {
                    dispatch_async(dispatch_get_main_queue(), {
                        let alertController = UIAlertController(title: "Syncing failed!", message: "Check Internet Connection", preferredStyle: .Alert)
                        let OKAction = UIAlertAction(title: "OK", style: .Default) { (action) in }
                        alertController.addAction(OKAction)
                        self.presentViewController(alertController, animated: true) { }
                    })
                }
            })
            task.resume()
        
            // Set new start date for syncing next time
            defaults.setObject(NSDate(), forKey: "new_start_date")
            defaults.setObject(self.sync_times_timestamps, forKey: "sync_times_timestamp")
            defaults.setObject(self.sync_times_data, forKey: "sync_times_data")
            defaults.synchronize()
        }
    }

    
    // Formats the post body for the request
    func formatPostBody(){
        // Make sure it's initially empty
        self.post_body = ""
        // Add first cuurly brace
        self.post_body += "{\n"
        
        // Add heart rate array to post body
        self.post_body += "\t\"HeartRates\":[\n"
        for i in 0..<self.heart_rate_objects.count{
            self.post_body += "\t\t{\n"
            self.post_body += "\t\t\t\"BPM\": \(Int(self.heart_rate_objects[i].getValue())),\n"
            self.post_body += "\t\t\t\"DateTaken\": \"\(self.heart_rate_objects[i].getTimestamp())\"\n"
            if(i == self.heart_rate_objects.count - 1){
                // No comma if it's the last object in the array
                self.post_body += "\t\t}\n"
            }else{
                // Else put a comma lol
                self.post_body += "\t\t},\n"
            }
        }
        self.post_body += "\t],\n"
        
        // Add step array to post body
        self.post_body += "\t\"Steps\":[\n"
        for i in 0..<self.steps_objects.count{
            self.post_body += "\t\t{\n"
            self.post_body += "\t\t\t\"StepsTaken\": \(Int(self.steps_objects[i].getValue())),\n"
            self.post_body += "\t\t\t\"DateTaken\": \"\(self.steps_objects[i].getTimestamp())\"\n"
            if(i == self.steps_objects.count - 1){
                // No comma if it's the last object in the array
                self.post_body += "\t\t}\n"
            }else{
                // Else put a comma lol
                self.post_body += "\t\t},\n"
            }
        }
        self.post_body += "\t],\n"
        
        // Add weight array to post body
        self.post_body += "\t\"Weights\":[\n"
        for i in 0..<self.weight_objects.count{
            self.post_body += "\t\t{\n"
            self.post_body += "\t\t\t\"WeightTaken\": \(self.weight_objects[i].getValue()),\n"
            self.post_body += "\t\t\t\"DateTaken\": \"\(self.weight_objects[i].getTimestamp())\"\n"
            if(i == self.weight_objects.count - 1){
                // No comma if it's the last object in the array
                self.post_body += "\t\t}\n"
            }else{
                // Else put a comma lol
                self.post_body += "\t\t},\n"
            }
        }
        self.post_body += "\t],\n"
        
        // Add blood glucose array to post body
        self.post_body += "\t\"BloodGlucose\":[\n"
        for i in 0..<self.blood_glucose_objects.count{
            self.post_body += "\t\t{\n"
            self.post_body += "\t\t\t\"BloodGlucose\": \(self.blood_glucose_objects[i].getValue()),\n"
            self.post_body += "\t\t\t\"DateTaken\": \"\(self.blood_glucose_objects[i].getTimestamp())\"\n"
            if(i == self.blood_glucose_objects.count - 1){
                // No comma if it's the last object in the array
                self.post_body += "\t\t}\n"
            }else{
                // Else put a comma lol
                self.post_body += "\t\t},\n"
            }
        }
        self.post_body += "\t],\n"
        
        self.post_body += "\t\"Sex\": \"\(self.sex)\",\n"
        self.post_body += "\t\"DOB\": \"\(self.dob)\",\n"
        self.post_body += "\t\"BloodType\": \"\(self.bloodType)\",\n"
        self.post_body += "\t\"Height\": \(self.h),\n"
        
        // Add blood pressure array to post body
        self.post_body += "\t\"BloodPressure\":[\n"
        for i in 0..<self.blood_pressure_objects.count{
            self.post_body += "\t\t{\n"
            self.post_body += "\t\t\t\"SystolicBloodPressure\": \(self.blood_pressure_objects[i].getSystolicValue()),\n"
            self.post_body += "\t\t\t\"DiastolicBloodPressure\": \(self.blood_pressure_objects[i].getDiastolicValue()),\n"
            self.post_body += "\t\t\t\"DateTaken\": \"\(self.blood_pressure_objects[i].getTimestamp())\"\n"
            if(i == self.blood_pressure_objects.count - 1){
                // No comma if it's the last object in the array
                self.post_body += "\t\t}\n"
            }else{
                // Else put a comma lol
                self.post_body += "\t\t},\n"
            }
        }
        self.post_body += "\t],\n"
        
        // Add body fat percentage array to post body
        self.post_body += "\t\"BodyFatPercentage\":[\n"
        for i in 0..<self.body_fat_percentage_objects.count{
            self.post_body += "\t\t{\n"
            self.post_body += "\t\t\t\"BodyFatPercentage\": \(self.body_fat_percentage_objects[i].getValue()),\n"
            self.post_body += "\t\t\t\"DateTaken\": \"\(self.body_fat_percentage_objects[i].getTimestamp())\"\n"
            if(i == self.body_fat_percentage_objects.count - 1){
                // No comma if it's the last object in the array
                self.post_body += "\t\t}\n"
            }else{
                // Else put a comma lol
                self.post_body += "\t\t},\n"
            }
        }
        self.post_body += "\t]\n"
        
        // ^^^^ ALSO the last "]" should not have a comma after it. So make sure not to put a comma ^^^^
        // i.e. self.post_body += "\t]\n"
        
        // Add final curly brace
        self.post_body += "}"
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
    
    func setUpStepsObjects(start_date: NSDate){
        steps_objects.removeAll()
        self.health_kit.getSteps(self.limit, start_date: start_date){stepcount, error in
            self.stepcount = stepcount
        }
        let date_formatter = NSDateFormatter()
        date_formatter.dateFormat = "MMM dd, yyyy hh:mm a"
        for s in self.stepcount as! [HKQuantitySample]{
            let steps_object = Steps(timestamp: date_formatter.stringFromDate(s.endDate), value: s.quantity.doubleValueForUnit(HKUnit.countUnit()))
            self.steps_objects.append(steps_object)
//            print(steps_object.getTimestamp() + "\t" + String(steps_object.getValue()))
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
//            print(weight_object.getTimestamp() + "\t" + String(weight_object.getValue()))
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
//            print(blood_glucose_object.getTimestamp() + "\t" + String(blood_glucose_object.getValue()))
        }
    }
    
    func setHeight(){

        
        self.health_kit.getHight({ (height, error) -> Void in
            self.height = (height as? HKQuantitySample)!
            self.h = self.height.quantity.doubleValueForUnit(HKUnit.inchUnit())
            
        })
    }
    
    func formatSex(biological_sex: HKBiologicalSexObject) -> String{
        var sex: String
        let bio_sex = biological_sex.biologicalSex
        switch bio_sex.rawValue{
        case 0:
            sex = ""
        case 1:
            sex = "Female"
        case 2:
            sex = "Male"
        case 3:
            sex = "Other"
        default:
            sex = ""
        }
        return sex
    }

    func formatDateofBirth(date: NSDate) -> String{
        let date_formatter = NSDateFormatter()
        date_formatter.dateFormat = "MMM dd, yyyy"
        return date_formatter.stringFromDate(date)
    }
    
    // Sets up the array of Blood Pressure objects to display as table cells
    func setUpBloodPressureObjects(start_date: NSDate){
        // First clear array to make sure it's empty
        blood_pressure_objects.removeAll()
        
        self.health_kit.getBloodPressure(self.limit, start_date: start_date){ heart_rates, error in
            self.blood_pressures = heart_rates
        }
        // Format date to make it readable
        let date_formatter = NSDateFormatter()
        date_formatter.dateFormat = "MMM dd, yyyy hh:mm a"
        for b in self.blood_pressures as! [HKCorrelation]{
            let systolic_data = b.objectsForType(HKObjectType.quantityTypeForIdentifier(HKQuantityTypeIdentifierBloodPressureSystolic)!).first as? HKQuantitySample
            let diastolic_data = b.objectsForType(HKObjectType.quantityTypeForIdentifier(HKQuantityTypeIdentifierBloodPressureDiastolic)!).first as? HKQuantitySample
            
            let systolic_value = systolic_data!.quantity.doubleValueForUnit(HKUnit.millimeterOfMercuryUnit())
            let diastolic_value = diastolic_data!.quantity.doubleValueForUnit(HKUnit.millimeterOfMercuryUnit())
            
            
            let blood_pressure_object = BloodPressure(timestamp: date_formatter.stringFromDate(b.endDate), systolic_value: systolic_value, diastolic_value: diastolic_value)
            self.blood_pressure_objects.append(blood_pressure_object)
            print(blood_pressure_object.getTimestamp() + "\t" + String(blood_pressure_object.getSystolicValue()) + "-" + String(blood_pressure_object.getDiastolicValue()))
        }
    }
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.is_health_kit_enabled = NSUserDefaults.standardUserDefaults().boolForKey("is_health_kit_enabled")
    }
    
    override func viewWillAppear(animated: Bool) {
        self.is_health_kit_enabled = NSUserDefaults.standardUserDefaults().boolForKey("is_health_kit_enabled")
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
