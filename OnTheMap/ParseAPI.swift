//
//  ParseAPI.swift
//  OnTheMap
//
//  Created by Alex on 23.07.15.
//  Copyright (c) 2015 alexhendel. All rights reserved.
//

import Foundation

class ParseAPI: NSObject {

    // MARK: const
    let PAPI_STRING = "https://api.parse.com/1/classes/StudentLocation"
    let PAPI_PARAM_LIMIT = "limit="
    let PAPI_APP_ID = "QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr"
    let PAPI_REST_KEY = "QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY"
    
    // MARK: functions
    
    /* 
     *  Sample Data:
     *
     * Optional({"results":[{"createdAt":"2015-08-01T05:59:00.350Z","firstName":"Ivan","lastName":"lares","latitude":33.836318,"longitude":-118.340038,"mapString":"torrance ca","mediaURL":"google.com","objectId":"GeDBIGi8Pk","uniqueKey":"u35788505","updatedAt":"2015-08-01T05:59:00.350Z"},
    */
    func getStudentLocations(limit: Int, completionHandler: ((Bool, NSError?, [StudentInformation]?) -> Void)!) -> Void {
    
        // make request URL string
        var url: String
        url = PAPI_STRING + "?" + PAPI_PARAM_LIMIT + String(limit)
        
        // setup request
        let request = NSMutableURLRequest(URL: NSURL(string: url)!)
        request.addValue(PAPI_APP_ID, forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue(PAPI_REST_KEY, forHTTPHeaderField: "X-Parse-REST-API-Key")
        
        // url session
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(request) { data, response, error in
            
            // Handle error
            if error != nil {
                return completionHandler(false, error, nil)
            }
            
            // parse JSON
            let jsonReadOpt = NSJSONReadingOptions()
            var parseError: NSError?
            
            if let json = NSJSONSerialization.JSONObjectWithData(data, options: jsonReadOpt, error: &parseError) as? [String: AnyObject] {
                
                // parse user name
                if var results = json["results"] as? [[String: AnyObject]] {
                    
                    var newPins: [StudentInformation] = []
                    
                    for student in results {
                    
                        var s = StudentInformation(studentDict: student)
                        newPins.append(s)
                    }
                    
                    return completionHandler(true, nil, newPins)
                } else {
                    
                    var err: NSError?
                    
                    if let stat = json["error"] as? String {
                        
                        // deliver description
                        err = NSError(domain: "parse.error", code: 500, userInfo: ["localizedDescription": "Couldn't retrieve Student locations. " + stat])
                        return completionHandler(false, err!, nil)
                        
                    } else {
                        
                        // some other error
                        err = NSError(domain: "parse.error", code: 600, userInfo: ["localizedDescription": "Couldn't retrieve Student locations."])
                        return completionHandler(false, err!, nil)
                    }
                }
            } else {
                
                return completionHandler(false, parseError!, nil)
            }
        }
        
        task.resume()
    }
    
    func getSpecificStudent(limit: Int, student: StudentInformation) {
        // make request URL string
        var url: String
        url = PAPI_STRING + "?" + PAPI_PARAM_LIMIT + String(limit) + "&" +
              "where=%7B%22uniqueKey%22%3A%22\(student.uniqueKey)%22%7D"
        
        // setup request
        let request = NSMutableURLRequest(URL: NSURL(string: url)!)
        request.addValue(PAPI_APP_ID, forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue(PAPI_REST_KEY, forHTTPHeaderField: "X-Parse-REST-API-Key")
        
        // url session
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(request) { data, response, error in
            if error != nil { // Handle error...
                return
            }
            println(NSString(data: data, encoding: NSUTF8StringEncoding))
        }
        task.resume()
    }
    
    func postStudentLocation(limit: Int, student: StudentInformation, completionHandler: ((Bool, NSError?) -> Void)!) -> Void {
    
        // make request URL string
        var url: String
        url = PAPI_STRING + "?" + PAPI_PARAM_LIMIT + String(limit)
        
        // setup request
        let request = NSMutableURLRequest(URL: NSURL(string: url)!)
        request.HTTPMethod = "POST"
        request.addValue(PAPI_APP_ID, forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue(PAPI_REST_KEY, forHTTPHeaderField: "X-Parse-REST-API-Key")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        var myjson: String
        myjson = "{\"uniqueKey\": \"\(student.uniqueKey)\", " +
                  "\"firstName\": \"\(student.firstName)\", " +
                  "\"lastName\": \"\(student.lastName)\", " +
                  "\"mapString\": \"\(student.mapString)\", " +
                  "\"mediaURL\": \"\(student.mediaURL)\", " +
                  "\"latitude\": \(student.latitude), " +
                  "\"longitude\": \(student.longitude)}"
        
        request.HTTPBody = myjson.dataUsingEncoding(NSUTF8StringEncoding)
        
        // url session
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(request) { data, response, error in
            
            // Handle error
            if error != nil {
                return completionHandler(false, error)
            } else {
                return completionHandler(true, nil)
            }
        }
        
        task.resume()
    }
}