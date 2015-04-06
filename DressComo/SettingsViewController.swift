//
//  SecondViewController.swift
//  DressComo
//
//  Created by Guilherme Berger on 3/21/15.
//  Copyright (c) 2015 Guilherme Berger. All rights reserved.
//

import UIKit

class SettingsViewController : UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func logoutButtonPressed(sender: AnyObject) {
        let logoutAlert = UIAlertController(title: "Logout", message: "Are you sure you want to logout?", preferredStyle: UIAlertControllerStyle.Alert)
        
        logoutAlert.addAction(UIAlertAction(title: "Ok", style: .Default, handler: { (action: UIAlertAction!) in
            User.sharedInstance.erase()
            
            let delegate = UIApplication.sharedApplication().delegate as AppDelegate
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let ctrl = storyboard.instantiateViewControllerWithIdentifier("LoginViewController") as UIViewController
            delegate.window?.rootViewController = ctrl
        }))
        
        logoutAlert.addAction(UIAlertAction(title: "Cancel", style: .Default, handler: { (action: UIAlertAction!) in
            // noop
        }))
        
        presentViewController(logoutAlert, animated: true, completion: nil)
    }
}

