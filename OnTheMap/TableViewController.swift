//
//  TableViewController.swift
//  OnTheMap
//
//  Created by Alex on 22.07.15.
//  Copyright (c) 2015 alexhendel. All rights reserved.
//

import UIKit

class TableViewController: UITableViewController, UITableViewDataSource, UITableViewDelegate {

    var appDelegate: AppDelegate!
    
    // MARK: functions
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        
        // Do any additional setup after loading the view, typically from a nib.
        self.appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
        // refresh data
        self.view.setNeedsDisplay()
    }
    
    //MARK: helper functions
    func showAlert(alertTitle: String, alertMessage: String) {
        
        let alertView = UIAlertView()
        
        alertView.title = alertTitle
        alertView.message = alertMessage
        alertView.addButtonWithTitle("OK")
        
        alertView.show()
    }
    
    // MARK: IBActions
    @IBAction func postNewPin(sender: UIBarButtonItem) {
        
        self.performSegueWithIdentifier("postNewPin", sender: self)
    }
    
    @IBAction func logout(sender: UIBarButtonItem) {
        
        self.appDelegate.udacityAPI?.logout()
        
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    // MARK: Conform to TableView Protocol
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if let count = self.appDelegate.pins?.students.count {
        
            return count
        } else {
        
            return 0
        }
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var myCell: CustomMapTableViewCell!
        myCell = self.tableView.dequeueReusableCellWithIdentifier("StudentCell") as! CustomMapTableViewCell
        
        if let student = self.appDelegate.pins?.students[indexPath.row] {
        
            myCell.loadItem(name: student.firstName + " " + student.lastName,
                            url: student.mediaURL,
                            location: student.mapString)
        }
        
        return myCell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        if let student = self.appDelegate.pins?.students[indexPath.row] {
        
            var mediaURL: NSURL!
            mediaURL = NSURL(string: student.mediaURL)
        
            if let url = mediaURL {
                // open the URL in safari
                UIApplication.sharedApplication().openURL(url)
            } else {
                // error handling - inform user that now student info can be shown
                showAlert("Open URL", alertMessage: "There was an error opening the URL '\(student.mediaURL)'.")
            }
        } else {
            showAlert("Open URL", alertMessage: "There was an error opening the URL.")
        }
    }
}
