//
//  StudentInformation.swift
//  OnTheMap
//
//  Created by Alex on 22.07.15.
//  Copyright (c) 2015 alexhendel. All rights reserved.
//

import Foundation

struct StudentInformation {
    
    var uniqueKey: String!
    var firstName: String!
    var lastName: String!
    var latitude: Float!
    var longitude: Float!
    var mapString: String!
    var mediaURL: String!
    
    // initializer with NSDictionary
    init(studentDict: NSDictionary?) {
        
        // try to fill the data in this struct if the dictionary isn't empty
        if let student = studentDict {
        
            self.uniqueKey = student.valueForKey("uniqueKey") as! String
            self.firstName = student.valueForKey("firstName") as! String
            self.lastName = student.valueForKey("lastName") as! String
            self.latitude = student.valueForKey("latitude") as! Float
            self.longitude = student.valueForKey("longitude") as! Float
            self.mapString = student.valueForKey("mapString") as! String
            self.mediaURL = student.valueForKey("mediaURL") as! String
        }
    }
}
