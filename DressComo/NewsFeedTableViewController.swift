//
//  NewsFeedViewController.swift
//  DressComo
//
//  Created by Guilherme Berger on 4/4/15.
//  Copyright (c) 2015 Guilherme Berger. All rights reserved.
//

import Foundation
import UIKit
import Alamofire
import SwiftyJSON
import Haneke

class NewsFeedTableViewController: UITableViewController {
    
    var posts : [DressComoPost] = []
    
    @IBOutlet var rightGestureRecognizer: UISwipeGestureRecognizer!
    @IBOutlet var leftGestureRecognizer: UISwipeGestureRecognizer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let bar = self.navigationController!.navigationBar
        bar.barStyle = UIBarStyle.Black
        bar.tintColor = UIColor(rgba: "#652c90")
        bar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        
        self.tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        let url = "http://localhost:3000/api/posts.json"
        let manager = Manager.sharedInstance
        
        manager.session.configuration.HTTPAdditionalHeaders = [
            "Content-Type": "application/json",
            "User-Agent": "DressComo-iOS/beta",
            "X-User-Token": "zowBCfiRLC8zBwtSb2Fs",
            "X-User-Email": "gberger@unc.edu"
        ]
        
        manager.request(.GET, url)
            .responseJSON { (request, response, data, error) in
                if data != nil {
                    var json = JSON(data!)
                    for (index: String, postJson: SwiftyJSON.JSON) in json {
                        var post = DressComoPost(json: postJson)
                        self.posts.append(post)
                    }
                }
                self.tableView.reloadData()
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.posts.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("PostCell", forIndexPath: indexPath) as PostTableViewCell
        
        cell.setPost(self.posts[indexPath.item])
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
    }
    
    @IBAction func rec(sender: AnyObject) {
        println("right")
    }
    
}

