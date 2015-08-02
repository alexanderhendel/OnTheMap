//
//  NewPinViewController.swift
//  OnTheMap
//
//  Created by Alex on 22.07.15.
//  Copyright (c) 2015 alexhendel. All rights reserved.
//

import UIKit
import MapKit

class NewPinViewController: UIViewController, UITextFieldDelegate {
    
    // MARK: IBOutlets
    @IBOutlet weak var mapStringTextField: UITextField!
    @IBOutlet weak var linkTextField: UITextField!
    @IBOutlet weak var studyLabel: UILabel!
    @IBOutlet weak var linkLabel: UILabel!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var findOnMapButton: UIButton!
    @IBOutlet weak var postPinButton: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    // MARK: variables
    var pins: StudentInformation!
    var appDelegate: AppDelegate!
    
    let POST_FIND_LOCATAION = 0
    let POST_PIN = 1
    
    // MARK: functions
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapStringTextField.delegate = self
        linkTextField.delegate = self
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        
        // Do any additional setup after loading the view, typically from a nib.
        self.appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate

        // hide the correct stuff
        self.activeElements(POST_FIND_LOCATAION)
        self.activityIndicator.stopAnimating()
        
        // redraw view
        self.view.setNeedsDisplay()
    }
    
    func activeElements(elements: Int) {
    
        switch elements {
            case POST_PIN:
                // hide the correct stuff
                linkLabel.hidden = false
                linkTextField.hidden = false
                mapView.hidden = false
                postPinButton.hidden = false
                
                // make sure the rest is visible
                studyLabel.hidden = true
                mapStringTextField.hidden = true
                findOnMapButton.hidden = true
            
            case POST_FIND_LOCATAION:
                // hide the correct stuff
                linkLabel.hidden = true
                linkTextField.hidden = true
                mapView.hidden = true
                postPinButton.hidden = true
                
                // make sure the rest is visible
                studyLabel.hidden = false
                mapStringTextField.hidden = false
                findOnMapButton.hidden = false
            default:
                // hide the correct stuff
                linkLabel.hidden = true
                linkTextField.hidden = true
                mapView.hidden = true
                postPinButton.hidden = true
                
                // make sure the rest is visible
                studyLabel.hidden = false
                mapStringTextField.hidden = false
                findOnMapButton.hidden = false
        }
        
        // also clear text fields
        mapStringTextField.text = ""
        linkTextField.text = ""
    }
    
    // MARK: IBActions
    @IBAction func cancelPost(sender: UIBarButtonItem) {
    
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func postPin(sender: AnyObject) {
        
        var link = linkTextField.text
        
        // verify textfield entry in not empty
        if link.isEmpty == false {
        
            // student
            self.appDelegate.newStudent?.mediaURL = link
            //self.appDelegate.newStudent?.uniqueKey = self.appDelegate.udacityAPI?.account.key
            
            // post student location
            self.activityIndicator.startAnimating()
            
            var api = ParseAPI()
            api.postStudentLocation(100, student: self.appDelegate.newStudent!, completionHandler: {completed, error -> Void in
                
                self.activityIndicator.stopAnimating()
                
                if (completed == true) {
                
                    self.dismissViewControllerAnimated(true, completion: nil)
                } else {
                    
                    self.showAlert("New Pin", alertMessage: "Sorry posting your Pin went wrong.")
                    self.dismissViewControllerAnimated(true, completion: nil)
                }
            })
            //api.getSpecificStudent(100, student: self.appDelegate.newStudent!)
        } else {
        
            // show error to the user
            self.showAlert("Your Link", alertMessage: "You must enter a URL to post your Pin.")
        }
    }
    
    @IBAction func findOnMap(sender: AnyObject) {
    
        var address = mapStringTextField.text
        
        if address.isEmpty == false {
            
            // activity indicator
            self.activityIndicator.startAnimating()
            self.findOnMapButton.enabled = false
            self.mapStringTextField.enabled = false
            
            // geocode location
            var geocoder = CLGeocoder()
            
            geocoder.geocodeAddressString(address, completionHandler: {(placemarks: [AnyObject]!, error: NSError!) -> Void in
                if let placemark = placemarks?[0] as? CLPlacemark {
                    
                    // go to next view
                    self.activeElements(self.POST_PIN)
                    
                    // set annotation mark on map
                    var region: MKCoordinateRegion!
                    var annotation = MKPlacemark(placemark: placemark)
                    
                    region = MKCoordinateRegionMakeWithDistance(annotation.coordinate, 5000, 5000)
                    
                    // show it all on the map
                    self.mapView.setRegion(region, animated: true)
                    self.mapView.addAnnotation(annotation)
                    
                    // pass the info to our newStudent struct
                    self.appDelegate.newStudent?.longitude = Float(annotation.coordinate.longitude)
                    self.appDelegate.newStudent?.latitude = Float(annotation.coordinate.latitude)
                    self.appDelegate.newStudent?.mapString = placemark.name
                    
                    // activity indicator
                    self.activityIndicator.stopAnimating()
                    self.findOnMapButton.enabled = true
                    self.mapStringTextField.enabled = true
                    
                } else {
                    
                    // error finding the place
                    self.activeElements(self.POST_FIND_LOCATAION)
                    self.showAlert("Your Location", alertMessage: "Your location could not be found. Please try again.")
                    
                    // activity indicator
                    self.activityIndicator.stopAnimating()
                    self.findOnMapButton.enabled = true
                    self.mapStringTextField.enabled = true
                    
                    self.mapStringTextField.text = ""
                    self.mapStringTextField.isFirstResponder()
                }
            })
        } else {
        
            self.showAlert("Your Location", alertMessage: "You must enter a location to search for on the map.")
        }
    }
    
    //MARK: helper functions
    func showAlert(alertTitle: String, alertMessage: String) {
        
        let alertView = UIAlertView()
        
        alertView.title = alertTitle
        alertView.message = alertMessage
        alertView.addButtonWithTitle("OK")
        
        alertView.show()
    }
    
    // MARK: TextField Delegate
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        
        if (textField == mapStringTextField) {
            self.findOnMap(self)
        }
        
        if (textField == linkTextField) {
            
            self.view.endEditing(true)
            self.postPin(self)
        }
        
        return true
    }
}