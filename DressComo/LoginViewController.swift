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

class LoginViewController: UIViewController {
    
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var signupButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func login(sender: AnyObject) {
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
        Manager.sharedInstance.request(.POST, url, parameters: parameters)
            .responseJSON { (request, response, data, error) in
                
                MBProgressHUD.hideHUDForView(self.view, animated: true)
                
                if response?.statusCode == 201 && data != nil {
                    let json = JSON(data!)
                    let user = User()
                    let email = json["email"].stringValue as String
                    let token = json["authentication_token"].stringValue as String
                    User.sharedInstance.updateCredentials(email: email, token: token)
                    
                    let ctrl = self.storyboard?.instantiateViewControllerWithIdentifier("MainTabBarController") as UITabBarController
                    self.navigationController?.pushViewController(ctrl, animated: true)
                    
                } else {
                    
                    var alert = UIAlertController(title: "Error", message: "Wrong email/password", preferredStyle: UIAlertControllerStyle.Alert)
                    alert.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default, handler: nil))
                    self.presentViewController(alert, animated: true, completion: nil)
                    
                    self.enableInputs()
                    
                    
                }
                
        }
    }
    
    
    @IBAction func signup(sender: AnyObject) {
        
    }
    
    private func disableInputs() {
        emailField.enabled = false
        passwordField.enabled = false
        loginButton.enabled = false
        signupButton.enabled = false
    }
    
    private func enableInputs() {
        emailField.enabled = true
        passwordField.enabled = true
        loginButton.enabled = true
        signupButton.enabled = true
    }

}

