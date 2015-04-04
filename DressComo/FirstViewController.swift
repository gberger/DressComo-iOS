//
//  FirstViewController.swift
//  DressComo
//
//  Created by Guilherme Berger on 3/21/15.
//  Copyright (c) 2015 Guilherme Berger. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import Haneke

class FirstViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet
    var tableView: UITableView!
    
    var posts : [DressComoPost] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
                        var post = DressComoPost()
                        post.id = Int(postJson["id"].double!)
                        post.text = postJson["text"].stringValue
                        post.cloudinary_image_id = postJson["cloudinary_image_id"].stringValue
                        
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
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.posts.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("PostCell", forIndexPath: indexPath) as PostTableViewCell
        
        cell.setPost(self.posts[indexPath.item])
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
    }


}

