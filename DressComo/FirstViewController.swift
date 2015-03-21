//
//  FirstViewController.swift
//  DressComo
//
//  Created by Guilherme Berger on 3/21/15.
//  Copyright (c) 2015 Guilherme Berger. All rights reserved.
//

import UIKit
import Alamofire

class FirstViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let url = "http://localhost:3000/api/posts.json"
        
        let manager = Manager.sharedInstance
        
        manager.session.configuration.HTTPAdditionalHeaders = [
            "Content-Type": "application/json",
            "User-Agent": "DressComo-iOS/beta",
            "X-User-Token": "rPwfMF-2tMxyWJVsNr_T",
            "X-User-Email": "gberger@unc.edu"
        ]
        
        manager.request(.GET, url)
            .responseJSON { (request, response, data, error) in
                println(data)
        }

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

