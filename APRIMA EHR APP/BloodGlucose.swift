//
//  BloodGlucose.swift
//  APRIMA EHR APP
//
//  Created by david on 4/3/16.
//  Copyright © 2016 david nguyen. All rights reserved.
//

import Foundation

class BloodGlucose{
    
    // Properties
    var timestamp: String
    var value: Double
    
    // constructor/initializer to create object
    init(timestamp: String, value: Double){
        self.timestamp = timestamp
        self.value = value
    }
    
    func getTimestamp() -> String{
        return self.timestamp
    }
    
    func getValue() -> Double{
        return self.value
    }
}