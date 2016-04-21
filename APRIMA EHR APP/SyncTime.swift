//
//  SyncTime.swift
//  APRIMA EHR APP
//
//  Created by henry dinh on 4/21/16.
//  Copyright © 2016 david nguyen. All rights reserved.
//

import Foundation

class SyncTime{
    
    // Properties
    var timestamp: String
    var data: String
    
    // constructor/initializer to create object
    init(timestamp: String, data: String){
        self.timestamp = timestamp
        self.data = data
    }
    
    func getTimestamp() -> String{
        return self.timestamp
    }
    
    func getData() -> String{
        return self.data
    }
    
}