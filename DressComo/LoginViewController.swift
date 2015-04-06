//
//  SecondViewController.swift
//  DressComo
//
//  Created by Guilherme Berger on 4/5/15.
//  Copyright (c) 2015 Guilherme Berger. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import MBProgressHUD
import SwiftValidator

class LoginViewController: UIViewController, ValidationDelegate {
    
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var locationField: UITextField!
    @IBOutlet weak var bioField: UITextField!
    
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var signupButton1: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var signupButton2: UIButton!
    
    let validator = Validator()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        validator.registerField(emailField, rules: [RequiredRule(), EmailRule()])
        validator.registerField(passwordField, rules: [RequiredRule(), MinLengthRule(length: 6)])
        validator.registerField(usernameField, rules: [RequiredRule(), MinLengthRule(length: 2), MaxLengthRule(length: 20), RegexRule(regex: "^[a-zA-Z0-9_\\.]+$")])
        validator.registerField(nameField, rules: [MaxLengthRule(length: 128)])
        validator.registerField(locationField, rules: [MaxLengthRule(length: 128)])
        validator.registerField(bioField, rules: [MaxLengthRule(length: 512)])
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func loginButtonPressed(sender: AnyObject) {
        // Gather data
        let givenEmail =  emailField.text!
        let givenPassword = passwordField.text!
        
        // Disable inputs
        self.disableInputs()
        
        // Loading
        MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        
        // Request
        let parameters = ["user": ["email": givenEmail, "password": givenPassword]]
        let url = "http://localhost:3000/users/sign_in.json"

        self.authenticate(url, parameters: parameters)
    }
    
    
    @IBAction func signupButton1Pressed(sender: AnyObject) {
        self.showSignupForm()
    }
    
    @IBAction func cancelButtonPressed(sender: AnyObject) {
        self.hideSignupForm()
    }
    
    @IBAction func signupButtonPressed(sender: AnyObject) {
        validator.validateAll(self)
    }
    
    func validationWasSuccessful() {
    
        // Gather data
        let givenEmail =  emailField.text!
        let givenPassword = passwordField.text!
        let givenUsername = usernameField.text!
        let givenName = nameField.text!
        let givenLocation = locationField.text!
        let givenBio = bioField.text!
        
        
        // Disable inputs
        self.disableInputs()
        
        // Loading
        MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        
        // Request
        let parameters = ["user": [
            "email": givenEmail,
            "password": givenPassword,
            "username": givenUsername,
            "name": givenName,
            "location": givenLocation,
            "bio": givenBio
        ]]
        
        let url = "http://localhost:3000/users.json"
        
        self.authenticate(url, parameters: parameters)

    }
    
    private func authenticate(url: String, parameters: [String: AnyObject]) {
        Manager.sharedInstance.request(.POST, url, parameters: parameters)
            .responseJSON { (request, response, data, error) in
                
                MBProgressHUD.hideHUDForView(self.view, animated: true)
                
                if response?.statusCode == 201 && data != nil {
                    let json = JSON(data!)
                    User.sharedInstance.update(json: json)
                    
                    let delegate = UIApplication.sharedApplication().delegate as AppDelegate
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let ctrl = storyboard.instantiateViewControllerWithIdentifier("MainTabBarController") as UITabBarController
                    delegate.window?.rootViewController = ctrl
                    
                } else {
                    self.enableInputs()
                }
                
        }
    }
    
    func validationFailed(errors: [UITextField: ValidationError]) {
        for (field, error) in errors {
            field.becomeFirstResponder()
            self.displayErrorAlert(error.errorMessage)
            return
        }
    }
    
    private func displayErrorAlert(message: String) {
        var alert = UIAlertController(title: "Error", message: message, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    private func enableInputs(state : Bool = true) {
        emailField.enabled = state
        passwordField.enabled = state
        usernameField.enabled = state
        nameField.enabled = state
        locationField.enabled = state
        bioField.enabled = state
        loginButton.enabled = state
        signupButton1.enabled = state
        cancelButton.enabled = state
        signupButton2.enabled = state
    }
    
    private func disableInputs() {
        self.enableInputs(state: false)
    }
    
    private func hideSignupForm(state : Bool = true) {
        usernameField.hidden = state
        nameField.hidden = state
        locationField.hidden = state
        bioField.hidden = state
        loginButton.hidden = !state
        signupButton1.hidden = !state
        cancelButton.hidden = state
        signupButton2.hidden = state
    }
    
    private func showSignupForm() {
        self.hideSignupForm(state: false)
    }

}





class MinLengthRule: Rule {
    
    private var DEFAULT_MIN_LENGTH: Int = 3
    
    init(){}
    
    init(length: Int){
        self.DEFAULT_MIN_LENGTH = length
    }
    
    func validate(value: String) -> Bool {
        return countElements(value) >= DEFAULT_MIN_LENGTH
    }
    
    func errorMessage() -> String {
        return "Must be at least \(DEFAULT_MIN_LENGTH) characters long"
    }
}

class MaxLengthRule: Rule {
    
    private var DEFAULT_MAX_LENGTH: Int = 16
    
    init(){}
    
    init(length: Int){
        self.DEFAULT_MAX_LENGTH = length
    }
    
    func validate(value: String) -> Bool {
        return countElements(value) <= DEFAULT_MAX_LENGTH
    }
    
    func errorMessage() -> String {
        return "Must be at most \(DEFAULT_MAX_LENGTH) characters long"
    }
}


class RegexRule : Rule {
    
    private var REGEX: String = "^(?=.*?[A-Z]).{8,}$"
    
    init(regex: String){
        self.REGEX = regex
    }
    
    func validate(value: String) -> Bool {
        if let test = NSPredicate(format: "SELF MATCHES %@", self.REGEX) {
            if test.evaluateWithObject(value) {
                return true
            }
        }
        return false
    }
    
    func errorMessage() -> String {
        return "Invalid Regular Expression"
    }
}



