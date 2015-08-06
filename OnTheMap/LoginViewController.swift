//
//  LoginViewController.swift
//  OnTheMap
//
//  Created by Alex on 21.07.15.
//  Copyright (c) 2015 alexhendel. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController, UITextFieldDelegate {
    
    // var
    var appDelegate: AppDelegate!
    
    // MARK: IBOutlets
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    // MARK: functions
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view, typically from a nib.
        emailTextField.delegate = self
        passwordTextField.delegate = self
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        
        self.appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        self.activityIndicator.stopAnimating()
    }
    
    // MARK: IBActions
    @IBAction func signUpToUdacity(sender: UIButton) {
        
        // sign up to udacity
        UIApplication.sharedApplication().openURL(NSURL(string: "https://www.udacity.com/account/auth#!/signin")!)
    }
    
    @IBAction func unwindToLoginViewController(segue: UIStoryboardSegue) {
    
    }
    
    @IBAction func performLoginToUdacity(sender: AnyObject) {
        
        // check email not nil
        if emailTextField.text.isEmpty {
            
            // AlertView to ask user to enter an email
            self.showAlert("Login", alertMessage: "Please enter your email / username.")
            
            self.passwordTextField.text = ""
            self.emailTextField.text = ""
            self.emailTextField.nextResponder()
        } else {
        
            // check password not nil
            if passwordTextField.text.isEmpty {
                
                // AlertView to ask user to an password
                self.showAlert("Login", alertMessage: "Please enter your password.")
                
                self.passwordTextField.text = ""
                self.emailTextField.text = ""
                self.emailTextField.nextResponder()
            } else {
            
                // indicate that something is happening
                self.activityIndicator.startAnimating()
                
                // verify the user&password against the UdacityAPI
                self.appDelegate.udacityAPI!.verifyLogin(emailTextField.text, password: passwordTextField.text, completionHandler: {completed, error -> Void in
                    
                    // stop activity indicator
                    self.activityIndicator.stopAnimating()
                    
                    if (completed == true) {
                        
                        NSOperationQueue.mainQueue().addOperationWithBlock {
                            self.appDelegate.udacityAPI!.getPuplicUserData(self.appDelegate.udacityAPI!.account.key!, completionHandler: {completed, error -> Void in
                                
                                NSOperationQueue.mainQueue().addOperationWithBlock {
                                    if (completed == true) {
                                        
                                        // add name to Student object
                                        self.appDelegate.newStudent?.firstName = self.appDelegate.udacityAPI?.first_name
                                        self.appDelegate.newStudent?.lastName = self.appDelegate.udacityAPI?.last_name
                                    } else {
                                    
                                        // do something else
                                        self.appDelegate.newStudent?.firstName = "Jon"
                                        self.appDelegate.newStudent?.lastName = "Doe"
                                        self.appDelegate.newStudent?.uniqueKey = "1234"
                                    }
                                    
                                    // clear input fields
                                    self.passwordTextField.text = ""
                                    self.emailTextField.text = ""
                                    
                                    // got the login and name
                                    self.performSegueWithIdentifier("showApp", sender: self)
                                }
                            })
                        }
                    } else {
                        
                        // login failed
                        if let e = error {
                            self.showAlert("Login", alertMessage: "Login failed. \(e.localizedDescription)")
                        } else {
                            self.showAlert("Login", alertMessage: "Login failed.")
                        }
                    }
                })
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
    
    // MARK: TextField Delegate
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        
        self.view.endEditing(true)
        self.performLoginToUdacity(self)
        return true
    }
}