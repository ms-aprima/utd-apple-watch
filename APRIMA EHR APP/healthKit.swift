//
//  healthKit.swift
//  APRIMA EHR APP
//
//  Created by macOS on 2/21/16.
//  Copyright © 2016 david nguyen. All rights reserved.
//

import Foundation
import HealthKit


class healthKit{
    let hStore = HKHealthStore()
    
    func authorize() -> Bool{
        var isEnabled = true
        
        if HKHealthStore.isHealthDataAvailable(){
            let steps = NSSet(object: HKQuantityType.quantityTypeForIdentifier(HKQuantityTypeIdentifierStepCount)!)
            hStore.requestAuthorizationToShareTypes(nil, readTypes: steps as! Set<HKObjectType>) { (success, error) -> Void in
                isEnabled = success
            }
        }else{
            isEnabled = false
        }
        return isEnabled
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
        hStore.executeQuery(query)
    }
}