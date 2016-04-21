//
//  HealthKit.swift
//  APRIMA EHR APP
//
//  Created by macOS on 2/21/16.
//  Copyright © 2016 david nguyen. All rights reserved.
// This class serves to authorize usage of the health kit

import Foundation
import HealthKit

// global variable to use anywhere so other view controllers can tell if user authorized health kit or not
// Make sure to check Authorized.enabled == true before pulling data.
let defaults = NSUserDefaults.standardUserDefaults()


class HealthKit{
    // Create instance of health kit store
    let hk_store:HKHealthStore = HKHealthStore()
    
    // initially start date is distantPast and default limit is 0
//    var start_date = defaults.objectForKey("new_start_date") as! NSDate
    
    //Lets user authorize the app to use health kit. returns if authorization was successful
    func authorize() -> Bool{
        
        var is_enabled = true
        
        // Array for types of data we want to read from the healthkit. Incomplete
        let read_hk_types: Set = [HKObjectType.characteristicTypeForIdentifier(HKCharacteristicTypeIdentifierDateOfBirth)!,
                                          HKQuantityType.quantityTypeForIdentifier(HKQuantityTypeIdentifierStepCount)!,
                                          HKObjectType.quantityTypeForIdentifier(HKQuantityTypeIdentifierHeight)!,
                                          HKObjectType.characteristicTypeForIdentifier(HKCharacteristicTypeIdentifierBiologicalSex)!,
                                          HKObjectType.quantityTypeForIdentifier(HKQuantityTypeIdentifierBodyMass)!,
                                          HKQuantityType.quantityTypeForIdentifier(HKQuantityTypeIdentifierHeartRate)!,
                                          HKCharacteristicType.characteristicTypeForIdentifier(HKCharacteristicTypeIdentifierBloodType)!,
                                          HKQuantityType.quantityTypeForIdentifier(HKQuantityTypeIdentifierBloodGlucose)!,
                                          HKQuantityType.quantityTypeForIdentifier(HKQuantityTypeIdentifierBloodPressureSystolic)!,
                                          HKQuantityType.quantityTypeForIdentifier(HKQuantityTypeIdentifierBloodPressureDiastolic)!]
        
        
        // check it see if healthkit is accessible on this device
        if HKHealthStore.isHealthDataAvailable(){
            // request authorization. no write type
            hk_store.requestAuthorizationToShareTypes(nil, readTypes: read_hk_types) { (success, error) -> Void in
                is_enabled = success
            }
        }else{
            is_enabled = false
        }
        // Remember that health kit is enabled
        defaults.setObject(NSDate.distantPast(), forKey: "new_start_date")
        defaults.setBool(true, forKey: "is_health_kit_enabled")
        defaults.synchronize()
        return is_enabled
    }

    // Gets steps. Still need to define how we want to display this data.
    func getSteps(limit: Int, start_date: NSDate, completion: (Array<HKSample>, NSError?) -> ()){
        // Testing getting steps from yesterday to today. Get yesterday's date by subtracting 24 hours (in secs) from today's date
        // So with yesterday's date as start parameter and today's date as the end parameter to the method below
        // Temporary of course
        let today = NSDate()
        
        // The type of data being requested
        let sortDescriptor = NSSortDescriptor(key: HKSampleSortIdentifierEndDate, ascending: false)
        let type = HKSampleType.quantityTypeForIdentifier(HKQuantityTypeIdentifierStepCount)
        
        // Search predicate will fetch data from now until a day ago for testing purposes for now.
        //let predicate = HKQuery.predicateForSamplesWithStartDate(newDate, endDate: NSDate(), options: .None)
        let predicate = HKQuery.predicateForSamplesWithStartDate(start_date, endDate: today,options: .None)
        
        // Query to fetch steps
        let query = HKSampleQuery(sampleType: type!, predicate: predicate, limit: limit, sortDescriptors: [sortDescriptor]){ query, results, error in
            //            var stepcount: Double = 0.0
            //            let stepsunit:HKUnit = HKUnit(fromString: "steps")
            //            if results?.count > 0{
            //                for s in results as! [HKQuantitySample]{
            //                    stepcount += s.quantity.doubleValueForUnit(stepsunit)
            //                }
            //            }
            completion(results!, error)
        }
        hk_store.executeQuery(query)
    }
    
    // Gets the user's date of birth
    func getBirthday()-> NSDate{
        var birth_day: NSDate?
        
        //for use in the catch block
        var dateNull : NSDate
        
        //test
        //intializes a 0 for date
        let c = NSDateComponents()
        c.year = 0
        c.month = 0
        c.day = 0

        //converts NSDateComponents to usable NSdate for return
        var gregorian = NSCalendar(identifier:NSCalendarIdentifierGregorian)
        var dateNull2 = gregorian!.dateFromComponents(c)
        
        do{
            birth_day = try hk_store.dateOfBirth()
        }catch{
            // Throw some kind of error. commented out for now
            //fatalError() <-- Don't uncomment yet cause fatalError will crash the app lol
            
            //if user doesn not have a birthday set, return a default date 
            //prevents the app from crashing when trying to pull non-existant data
            //Not sure how to display 'blank' data since function requires returning an NSdate object
            
            //2 options
            // returning dateNull --- will return current date
            // returning dateNull2 -- will return date set to 0
            // will decide later which to keep as I explore better options
            dateNull = NSDate.init()
            return dateNull2!
        }
        return birth_day!
    }
    
    // Get the user's gender/biological sex
    func getSex() -> HKBiologicalSexObject{
        var biological_sex: HKBiologicalSexObject?
        do{
            biological_sex = try hk_store.biologicalSex()
        }catch{
            // Error here
            //biological_sex =
        }
        return biological_sex!
    }
    
    func pullBloodType() -> HKBloodTypeObject{
        var bloodType: HKBloodTypeObject?
        do{
                bloodType = try hk_store.bloodType()
        }catch{
            //Error
        }
        return bloodType!
    }
    
    // Get the user's height
    func getHight(completion:((HKSample!, NSError!) -> Void)!) {
        let type = HKSampleType.quantityTypeForIdentifier(HKQuantityTypeIdentifierHeight)
        let old = NSDate.distantPast()
        let current = NSDate()
        let predicate = HKQuery.predicateForSamplesWithStartDate(old, endDate: current, options: .None)
        let sortDescriptor = NSSortDescriptor(key: HKSampleSortIdentifierStartDate, ascending: false)
        let limit = 1
        let query = HKSampleQuery(sampleType: type!, predicate: predicate, limit: limit, sortDescriptors: [sortDescriptor])
        { (query, results, error) -> Void in
            if let queryError = error{
                completion(nil, error)
                return;
            }
            
            let height = results!.first as? HKQuantitySample
            if completion != nil{
                completion(height, nil)
            }
        }
        self.hk_store.executeQuery(query)
    }
    
    
    func getBloodType() -> String
    {
        var bloodType: String
        
        let bio_btype = pullBloodType().bloodType
        //print(bio_btype)
        
        switch bio_btype.rawValue{
            case 0:
                bloodType = ""
            case 1:
                bloodType = "A+"
            case 2:
                bloodType = "A-"
            case 3:
                bloodType = "B+"
            case 4:
                bloodType = "B-"
            case 5:
                bloodType = "AB+"
            case 6:
                bloodType = "AB-"
            case 7:
                bloodType = "O+"
            case 8:
                bloodType = "O-"
            default:
                bloodType = ""
        }
        //print(bloodType)
        return bloodType
    }
    
    // Get the user's weight
    func getWeight(completion:((HKSample!, NSError!) -> Void)!) {
        let type = HKSampleType.quantityTypeForIdentifier(HKQuantityTypeIdentifierBodyMass)
        let old = NSDate.distantPast()
        let current = NSDate()
        let predicate = HKQuery.predicateForSamplesWithStartDate(old, endDate: current, options: .None)
        let sortDescriptor = NSSortDescriptor(key: HKSampleSortIdentifierStartDate, ascending: false)
        let limit = 1
        let query = HKSampleQuery(sampleType: type!, predicate: predicate, limit: limit, sortDescriptors: [sortDescriptor])
        { (query, results, error) -> Void in
            if let queryError = error{
                completion(nil, error)
                return;
            }
            
            let weight = results!.first as? HKQuantitySample
            if completion != nil{
                completion(weight, nil)
            }
        }
        self.hk_store.executeQuery(query)
    }
    
    func getWeight2(limit: Int, start_date: NSDate, completion:(Array<HKSample>, NSError?) -> ()) {
        
        let type = HKSampleType.quantityTypeForIdentifier(HKQuantityTypeIdentifierBodyMass)
//        let old = NSDate.distantPast()
        let current = NSDate()
        
        let predicate = HKQuery.predicateForSamplesWithStartDate(start_date, endDate: current, options: .None)
        
        
        let sortDescriptor = NSSortDescriptor(key: HKSampleSortIdentifierStartDate, ascending: false)
        
        let limit = 25
        
        
        let query = HKSampleQuery(sampleType: type!, predicate: predicate, limit: limit, sortDescriptors: [sortDescriptor])
        { query, results, error in
            var weight: Double = 0.0
            let weightUnit:HKUnit = HKUnit(fromString: "lb")
            
            if results?.count > 0
            {
                for h in results as! [HKQuantitySample]
                {
                    weight += h.quantity.doubleValueForUnit(weightUnit)
                }
            }
            
            completion(results!, error)
            
        }
        
        
        
        self.hk_store.executeQuery(query)
    }

    // Get all heart rate samples within limit
    func getHeartRate(limit: Int, start_date: NSDate, completion:(Array<HKSample>, NSError?) ->()){
        // Date range to pull datat from. From distant past to today
        let end_date = NSDate()
//        let start_date = NSDate.distantPast()
        let predicate = HKQuery.predicateForSamplesWithStartDate(start_date, endDate: end_date, options: .None)
        
        // Create a heart rate BPM sample
        let sortDescriptor = NSSortDescriptor(key: HKSampleSortIdentifierEndDate, ascending: false)
//        let limit = 25
        let heart_rate_type = HKSampleType.quantityTypeForIdentifier(HKQuantityTypeIdentifierHeartRate)
        
        // Create query for latest sample
        let heart_rate_query = HKSampleQuery(sampleType: heart_rate_type!, predicate: predicate, limit: limit, sortDescriptors: [sortDescriptor]){ query, results, error in
            var heart_rate: Double = 0.0
            let heartRateUnit:HKUnit = HKUnit(fromString: "count/min")
            if results?.count > 0{
                for h in results as! [HKQuantitySample]{
                    heart_rate += h.quantity.doubleValueForUnit(heartRateUnit)
                }
            }
            completion(results!, error)
        }
        self.hk_store.executeQuery(heart_rate_query)
    }
    
    // Get all blood pressure samples (systolic and diastolic values)
    func getBloodPressure(limit: Int, start_date: NSDate, completion:(Array<HKSample>, NSError?) ->()){
        // Date range to pull datat from. From distant past to today
        let end_date = NSDate()
        //        let start_date = NSDate.distantPast()
        let predicate = HKQuery.predicateForSamplesWithStartDate(start_date, endDate: end_date, options: .None)
        
        // Create a heart rate BPM sample
        let sortDescriptor = NSSortDescriptor(key: HKSampleSortIdentifierEndDate, ascending: false)
        //        let limit = 25
        let type = HKQuantityType.correlationTypeForIdentifier(HKCorrelationTypeIdentifierBloodPressure)

        // Create query for sample
        let heart_rate_query = HKSampleQuery(sampleType: type!, predicate: predicate, limit: limit, sortDescriptors: [sortDescriptor]){ query, results, error in
//            let data_list = results as? [HKCorrelation]
            
            completion(results!, error)
        }
        self.hk_store.executeQuery(heart_rate_query)
    }

    func getBloodGlucose(limit: Int, start_date: NSDate, completion: (Array<HKSample>, NSError?) -> ()){
        // Testing getting steps from yesterday to today. Get yesterday's date by subtracting 24 hours (in secs) from today's date
        // So with yesterday's date as start parameter and today's date as the end parameter to the method below
        // Temporary of course
        let today = NSDate()
//        let yesterday = NSDate.distantPast()
        
        // The type of data being requested
        let sortDescriptor = NSSortDescriptor(key: HKSampleSortIdentifierEndDate, ascending: false)
        let type = HKSampleType.quantityTypeForIdentifier(HKQuantityTypeIdentifierBloodGlucose)
//        let limit = 25
    
        // Search predicate will fetch data from now until a day ago for testing purposes for now.
        //let predicate = HKQuery.predicateForSamplesWithStartDate(newDate, endDate: NSDate(), options: .None)
        let predicate = HKQuery.predicateForSamplesWithStartDate(start_date, endDate: today,options: .None)
        
        // Query to fetch steps
        let query = HKSampleQuery(sampleType: type!, predicate: predicate, limit: limit, sortDescriptors: [sortDescriptor]){ query, results, error in
            var bloodglucose: Double = 0.0
            let bloodglucoseunit:HKUnit = HKUnit(fromString: "mg/dL")
            if results?.count > 0{
                for bg in results as! [HKQuantitySample]{
                    bloodglucose += bg.quantity.doubleValueForUnit(bloodglucoseunit)
                }
            }
            completion(results!, error)
        }
        hk_store.executeQuery(query)
    }

    
    
    
}