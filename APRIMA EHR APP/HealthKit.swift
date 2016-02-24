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
    
    // Lets user authorize the app to use health kit
//    func authorize(completion: ((success:Bool, error:NSError!) -> Void)!){
//        
//        // Array of types to read from the health kit store
//        let hk_types_to_read = NSSet(array:[
//            HKObjectType.characteristicTypeForIdentifier(HKCharacteristicTypeIdentifierDateOfBirth),
//            HKObjectType.characteristicTypeForIdentifier(HKCharacteristicTypeIdentifierBloodType),
//            HKObjectType.characteristicTypeForIdentifier(HKCharacteristicTypeIdentifierBiologicalSex),
//            HKObjectType.quantityTypeForIdentifier(HKQuantityTypeIdentifierBodyMass),
//            HKObjectType.quantityTypeForIdentifier(HKQuantityTypeIdentifierHeight),
//            HKObjectType.workoutType()])
//        
//        // Array of types to write to the health kit store
//        let hk_types_to_write = NSSet(array:[
//            HKObjectType.quantityTypeForIdentifier(HKQuantityTypeIdentifierBodyMassIndex),
//            HKObjectType.quantityTypeForIdentifier(HKQuantityTypeIdentifierActiveEnergyBurned),
//            HKObjectType.quantityTypeForIdentifier(HKQuantityTypeIdentifierDistanceWalkingRunning),
//            HKObjectType.workoutType()])
//        
//        // Report error if health store is not available
//        if !HKHealthStore.isHealthDataAvailable(){
//            let error = NSError(domain: "com.aprima.APRIMA-EHR-APP", code: 2, userInfo: [NSLocalizedDescriptionKey:"HealthKit is not available in this Device"])
//            if( completion != nil ){
//                completion(success:false, error:error)
//            }
//            return;
//        }
//    
//        // Finally request HealthKit authorization since it is available at this point
//        hk_store.requestAuthorizationToShareTypes(Set(hk_types_to_write), readTypes: hk_types_to_read) { (success, error) -> Void in
//            
//            // authorization successsful
//            if( completion != nil ){
//                completion(success:success,error:error)
//            }
//        }
//    }
//    
//    func getSteps(completion: (Double, NSError?) -> ()){
//        var dateString = "15-2-2016 12:00"
//        let dateFormatter = NSDateFormatter()
//        dateFormatter.dateFormat = "dd-MM-yyyy HH:mm"
//        var newDate = dateFormatter.dateFromString(dateString)
//        
//        let type = HKSampleType.quantityTypeForIdentifier(HKQuantityTypeIdentifierStepCount)
//        let predicate = HKQuery.predicateForSamplesWithStartDate(newDate, endDate: NSDate(), options: .None)
//        let query = HKSampleQuery(sampleType: type!, predicate: predicate, limit: 0, sortDescriptors: nil){ query, results, error in
//            var steps: Double = 0
//            if results?.count > 0{
//                for result in results as! [HKQuantitySample]{
//                    steps += result.quantity.doubleValueForUnit(HKUnit.countUnit())
//                }
//            }
//            
//            completion(steps, error)
//        }
//        hStore.executeQuery(query)
//    }
}