//
//  HeartRate
//  APRIMA EHR APP
//
//  Created by henry dinh on 3/30/16.
//  Copyright © 2016 david nguyen. All rights reserved.
//
// Heartrate class that will store the pullec heartrate data from healthkit

import Foundation

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