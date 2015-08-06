//
//  MapViewController.swift
//  OnTheMap
//
//  Created by Alex on 22.07.15.
//  Copyright (c) 2015 alexhendel. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController, MKMapViewDelegate  {
    
    var appDelegate: AppDelegate!
    
    // MARK: IBOutlet
    @IBOutlet weak var mapView: MKMapView!
    
    // MARK: view controller functions
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.delegate = self
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        
        // Do any additional setup after loading the view, typically from a nib.
        self.appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        getStudentInfo()
        
        self.view.setNeedsDisplay()
    }
    
    // MARK: own functions
    /*
     * retrieve student data and store them in appDelegate.pins
     */
    func getStudentInfo() -> Bool {
    
        let parseAPI = ParseAPI()
        parseAPI.getStudentLocations(100, completionHandler: {completed, error, pins -> Void in
            if (completed == true) {
                
                // add pins to global pin object
                if let p = pins {
                    self.appDelegate.pins = p
                }
                
                // show pins on the map
                for student in self.appDelegate.pins {
                
                    var pin = CustomAnnotationPin(coordinate: CLLocationCoordinate2D(latitude: CLLocationDegrees(student.latitude), longitude: CLLocationDegrees(student.longitude)))
                    
                    pin.title = student.firstName + " " + student.lastName
                    pin.subtitle = student.mediaURL
                    pin.locationName = student.mapString
                    
                    self.mapView.addAnnotation(pin)
                }
                
                // refresh annotation on the map
                let center = self.mapView.centerCoordinate
                self.mapView.centerCoordinate = center
                
            } else {
            
                // error handling - inform user that now student info can be shown
                let alertView = UIAlertView()
                
                alertView.title = "Student Information"
                alertView.message = "There was an error downloading student information."
                alertView.addButtonWithTitle("OK")
                
                alertView.show()
            }
        })
        
        return true
    }
    
    // MARK: IBActions
    @IBAction func postNewPin(sender: UIBarButtonItem) {
        
        self.performSegueWithIdentifier("postNewPin", sender: self)
    }
    
    @IBAction func logout(sender: UIBarButtonItem) {
        
        self.appDelegate.udacityAPI?.logout()
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    // MARK: MapView Protocol
    func mapView(mapView: MKMapView!, viewForAnnotation annotation: MKAnnotation!) -> MKAnnotationView! {
        if annotation is CustomAnnotationPin {
            let pinAnnotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "studentPin")
            
            pinAnnotationView.pinColor = .Purple
            pinAnnotationView.draggable = false
            pinAnnotationView.canShowCallout = true
            pinAnnotationView.animatesDrop = true
            
            let infoButton = UIButton.buttonWithType(UIButtonType.InfoLight) as! UIButton
            infoButton.frame.size.width = 44
            infoButton.frame.size.height = 44
            
            pinAnnotationView.leftCalloutAccessoryView = infoButton
            
            return pinAnnotationView
        }
        
        return nil
    }
    
    func mapView(mapView: MKMapView!, annotationView view: MKAnnotationView!, calloutAccessoryControlTapped control: UIControl!) {
        if let annotation = view.annotation as? CustomAnnotationPin {
                        
            if let url = NSURL(string: annotation.subtitle!) {
                // open the URL in safari
                UIApplication.sharedApplication().openURL(url)
            } else {
                // error handling - inform user that now student info can be shown
                showAlert("Open URL", alertMessage: "There was an error opening the URL '\(annotation.subtitle)'.")
            }
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
}
