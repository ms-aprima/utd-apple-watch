//
//  BloodPressure.swift
//  APRIMA EHR APP
//
//  Created by henry dinh on 4/20/16.
//  Copyright © 2016 david nguyen. All rights reserved.
//

import Foundation

class BloodPressure{
    
    // Properties
    var timestamp: String
    var systolic_value: Double
    var diastolic_value: Double
    
    // constructor/initializer to create object
    init(timestamp: String, systolic_value: Double, diastolic_value: Double){
        self.timestamp = timestamp
        self.systolic_value = systolic_value
        self.diastolic_value = diastolic_value
    }
    
    func getTimestamp() -> String{
        return self.timestamp
    }
    
    func getSystolicValue() -> Double{
        return self.systolic_value
    }
    
    func getDiastolicValue() -> Double{
        return self.diastolic_value
    }
}

class BodyFatPercentage{
    
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

class Weight{
    
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

class Steps{
    
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

class HeartRate{
    
    // Properties. The date will already be formatted as a string
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