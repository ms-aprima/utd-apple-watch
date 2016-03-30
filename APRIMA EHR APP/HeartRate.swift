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
    
    // Properties
    var timestamp: NSDate
    var value: Int
    
    // constructor/initializer to create object
    init(timestamp: NSDate, value: Int){
        self.timestamp = timestamp
        self.value = value
    }
    
    func getTimestamp() -> NSDate{
        return self.timestamp
    }
    
    func getValue() -> Int{
        return self.value
    }
}