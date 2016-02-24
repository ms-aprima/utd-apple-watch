//
//  HealthKit.swift
//  APRIMA EHR APP
//
//  Created by macOS on 2/21/16.
//  Copyright © 2016 david nguyen. All rights reserved.
// This class serves to authorize usage of the health kit

import Foundation
import HealthKit


class HealthKit{
    // Create instance of health kit store
    let hk_store:HKHealthStore = HKHealthStore()
    
    //Lets user authorize the app to use health kit. returns if authorization was successful
    func authorize() -> Bool{
        
        var is_enabled = true
        
        // check it see if healthkit is accessible on this device
        if HKHealthStore.isHealthDataAvailable(){
            let steps = NSSet(object: HKQuantityType.quantityTypeForIdentifier(HKQuantityTypeIdentifierStepCount)!)
            // request authorization. no write type
            hk_store.requestAuthorizationToShareTypes(nil, readTypes: steps as! Set<HKObjectType>) { (success, error) -> Void in
            is_enabled = success
            }
        }else{
            is_enabled = false
        }
        return is_enabled
    }

    func getSteps(completion: (Double, NSError?) -> ()){
        var dateString = "15-2-2016 12:00"
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy HH:mm"
        var newDate = dateFormatter.dateFromString(dateString)
        
        let type = HKSampleType.quantityTypeForIdentifier(HKQuantityTypeIdentifierStepCount)
        let predicate = HKQuery.predicateForSamplesWithStartDate(newDate, endDate: NSDate(), options: .None)
        let query = HKSampleQuery(sampleType: type!, predicate: predicate, limit: 0, sortDescriptors: nil){ query, results, error in
            var steps: Double = 0
            if results?.count > 0{
                for result in results as! [HKQuantitySample]{
                    steps += result.quantity.doubleValueForUnit(HKUnit.countUnit())
                }
            }
            
            completion(steps, error)
        }
        hk_store.executeQuery(query)
    }
}