//
//  CustomAnnotationPin.swift
//  OnTheMap
//
//  Created by Alex on 06.08.15.
//  Copyright (c) 2015 alexhendel. All rights reserved.
//

import Foundation
import MapKit

class CustomAnnotationPin: NSObject, MKAnnotation {

    var title: String?
    var subtitle: String?
    var locationName: String?
    
    let coordinate: CLLocationCoordinate2D
    
    init (coordinate: CLLocationCoordinate2D!) {
        
        // init coordinate
        if let c = coordinate {
            self.coordinate = coordinate
        } else {
            self.coordinate = CLLocationCoordinate2D()
        }
        
        super.init()
    }
    
    var discipline: String {
        
        return "Udacity Student"
    }
}