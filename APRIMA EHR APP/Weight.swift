//
//  Weight.swift
//  APRIMA EHR APP
//
//  Created by henry dinh on 3/30/16.
//  Copyright © 2016 david nguyen. All rights reserved.
//
// Steps class that will store the pulled steps data from healthkit


import Foundation

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