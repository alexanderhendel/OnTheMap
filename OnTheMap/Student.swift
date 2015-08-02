//
//  student.swift
//  OnTheMap
//
//  Created by Alex on 22.07.15.
//  Copyright (c) 2015 alexhendel. All rights reserved.
//

/*
Sample Person Data JSON

{
"createdAt":"2015-02-24T22:30:54.442Z",
"firstName":"Jason",
"lastName":"Schatz",
"latitude":37.7617,
"longitude":-122.4216,
"mapString":"18th and Valencia, San Francisco, CA",
"mediaURL":"http://en.wikipedia.org/wiki/Swift_%28programming_language%29",
"objectId":"hiz0vOTmrL",
"uniqueKey":"2362758535",
"updatedAt":"2015-03-10T17:20:31.828Z"
},
*/

import Foundation
import MapKit

class Student: NSObject, MKAnnotation {
    
    var uniqueKey: String!
    var firstName: String!
    var lastName: String!
    var latitude: Float!
    var longitude: Float!
    var mapString: String!
    var mediaURL: String!
    
    // mapkit stuff
    let coordinate: CLLocationCoordinate2D
    
    init (student: Student!, coordinate: CLLocationCoordinate2D!) {
        
        if let s = student {
            self.uniqueKey = student.uniqueKey
            self.firstName = student.firstName
            self.lastName = student.lastName
            self.latitude = student.latitude
            self.longitude = student.longitude
            self.mapString = student.mapString
            self.mediaURL = student.mediaURL
        }
        
        if let c = coordinate {
            self.coordinate = coordinate
        } else {
            self.coordinate = CLLocationCoordinate2D()
        }
    
        super.init()
    }
    
    var title: String? {
    
        let str = self.firstName + " " + self.lastName
        return str
    }
    
    var subtitle: String? {
        
        return self.mediaURL
    }
    
    var locationName: String {
    
        return self.mapString
    }
    
    var discipline: String {
    
        return "Udacity Student"
    }
}