//
//  UdacityAPI.swift
//  OnTheMap
//
//  Created by Alex on 21.07.15.
//  Copyright (c) 2015 alexhendel. All rights reserved.
//

/*
Login Success JSON
Optional({"account": {"registered": true, "key": "3630888859"}, "session": {"id": "1468227343S3ecfe82b46c0ac8b79072b2037dbfb5f", "expiration": "2015-09-10T08:55:43.787320Z"}})

*/

import Foundation

class UdacityAPI: NSObject {
    
    // const
    let UAPI_STRING = "https://www.udacity.com/api/"
    let UAPI_SESSION_DATA = "session"
    let UAPI_USER_DATA = "users"
    
    // variable
    var first_name: String?
    var last_name: String?
    
    struct uapi_session {
        var id: String?
        var expiration: String?
    }
    
    struct uapi_account {
        var key: String?
        var registered: String?
    }
    
    var session: uapi_session
    var account: uapi_account

    // initializer
    override init() {
        
        self.session = uapi_session()
        self.account = uapi_account()
        
        super.init()
    }
    
    // verify login data
    func verifyLogin(user: String?, password: String?, completionHandler: ((Bool, NSError?) -> Void)!) -> Void
    {
        let request = NSMutableURLRequest(URL: NSURL(string: UAPI_STRING + UAPI_SESSION_DATA)!)
        
        // setup the request
        request.HTTPMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let myjson = "{\"udacity\": {\"username\": \"" + user! +
            "\", \"password\": \"" + password! + "\"}}"
        
        request.HTTPBody = myjson.dataUsingEncoding(NSUTF8StringEncoding)
        
        let urlsession = NSURLSession.sharedSession()
        
        let task = urlsession.dataTaskWithRequest(request, completionHandler: {(data, response, error) in
            
            // Handle error…
            if error != nil {
                return completionHandler(false, error)
            }
            
            let newData = data!.subdataWithRange(NSMakeRange(5, data!.length - 5))
            // print(NSString(data: newData, encoding: NSUTF8StringEncoding))
            
            let jsonReadOpt = NSJSONReadingOptions()
            var parseError: NSError?
            
            if let json = NSJSONSerialization.JSONObjectWithData(newData, options: jsonReadOpt, error: &parseError) as? [String: AnyObject] {
            
                //println(NSString(data: newData, encoding: NSUTF8StringEncoding))
                
                // change local variables for session
                if var userSession = json["session"] as? [String: AnyObject] {
            
                    self.session.id = userSession["id"] as? String
                    self.session.expiration = userSession["expiration"] as? String
            
            
                    if var userAccount = json["account"] as? [String: AnyObject] {
            
                        self.account.key = userAccount["key"] as? String
                        self.account.registered = userAccount["registered"] as? String
            
                        return completionHandler(true, nil)
                    }
                } else {
            
                    var err: NSError?
                
                    if let stat = json["error"] as? String {
                    
                        // deliver description
                        err = NSError(domain: "login.error", code: 100, userInfo: ["localizedDescription": stat])
                        return completionHandler(false, err!)
                    
                    } else {
                        
                        // some other error
                        err = NSError(domain: "login.error", code: 200, userInfo: ["localizedDescription": "Unknown Error occured."])
                        return completionHandler(false, err!)
                    }
                }
            } else {
                
                return completionHandler(false, parseError!)
            }
        })
        
        task.resume()
    }
    
    func getPuplicUserData(userkey: String, completionHandler: ((Bool, NSError?) -> Void)!) -> Void {
    
        // build request URL
        let requestString = UAPI_STRING + UAPI_USER_DATA + "/" + userkey
        
        let request = NSMutableURLRequest(URL: NSURL(string: requestString)!)
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(request, completionHandler: {(data, response, error) in
            
            // Handle error
            if error != nil {
                return completionHandler(false, error)
            }
            
            // retrieve request data
            let newData = data.subdataWithRange(NSMakeRange(5, data.length - 5)) /* subset response data! */
            
            // parse JSON
            let jsonReadOpt = NSJSONReadingOptions()
            var parseError: NSError?
            
            if let json = NSJSONSerialization.JSONObjectWithData(newData, options: jsonReadOpt, error: &parseError) as? [String: AnyObject] {
                
                // parse user name
                if var userdata = json["user"] as? [String: AnyObject] {
                
                    self.first_name = userdata["first_name"] as? String
                    self.last_name = userdata["last_name"] as? String
                    
                    return completionHandler(true, nil)
                } else {
                
                    var err: NSError?
                    
                    if let stat = json["error"] as? String {
                        
                        // deliver description
                        err = NSError(domain: "login.error", code: 300, userInfo: ["localizedDescription": stat])
                        return completionHandler(false, err!)
                        
                    } else {
                        
                        // some other error
                        err = NSError(domain: "login.error", code: 400, userInfo: ["localizedDescription": "Unknown Error occured."])
                        return completionHandler(false, err!)
                    }
                }
            } else {
            
                return completionHandler(false, parseError!)
            }
        })
    
        task.resume()
    }
    
    func logout() {
    
        // setup the request
        let request = NSMutableURLRequest(URL: NSURL(string: UAPI_STRING + UAPI_SESSION_DATA)!)
        request.HTTPMethod = "DELETE"
        
        // handle cookies - nom nom nom... says cookie monster
        var xsrfCookie: NSHTTPCookie? = nil
        let sharedCookieStorage = NSHTTPCookieStorage.sharedHTTPCookieStorage()
        
        for cookie in sharedCookieStorage.cookies as! [NSHTTPCookie] {
            if cookie.name == "XSRF-TOKEN" { xsrfCookie = cookie }
        }
        
        if let xsrfCookie = xsrfCookie {
            request.addValue(xsrfCookie.value!, forHTTPHeaderField: "X-XSRF-Token")
        }
        
        // URL Session
        let urlsession = NSURLSession.sharedSession()
        let task = urlsession.dataTaskWithRequest(request) {(data, response, error) in
            
            if error != nil { // Handle error…
                return
            }
            
            let newData = data.subdataWithRange(NSMakeRange(5, data.length - 5)) /* subset response data! */
            // println(NSString(data: newData, encoding: NSUTF8StringEncoding))
            
        }
        
        task.resume()
    }
}