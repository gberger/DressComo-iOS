//
//  PostTableViewCell.swift
//  DressComo
//
//  Created by Guilherme Berger on 4/4/15.
//  Copyright (c) 2015 Guilherme Berger. All rights reserved.
//

import Foundation
import UIKit
import Alamofire
import SwiftyJSON

public class PostTableViewCell : UITableViewCell {
    
    var post : DressComoPost? = nil
    
    @IBOutlet weak var outfitImage: UIImageView!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var dislikeButton: UIButton!
    @IBOutlet weak var likeLabel: UILabel!
    @IBOutlet weak var dislikeLabel: UILabel!
    
    
    public func setPost(post: DressComoPost) {
        self.post = post
        let url : NSURL = post.image_url()
        
        outfitImage!.hnk_setImageFromURL(url)
        descriptionLabel.text = post.text
        likeLabel.text = "\(post.likes)"
        dislikeLabel.text = "\(post.dislikes)"
    }
    
    @IBAction func likeButtonPressed(sender: UIButton) {
        let url = "\(self.post!.url())/likes.json"
        Manager.sharedInstance.request(.POST, url).responseJSON { (request, response, data, error) in
            self.updatePost()
        }
    }
    
    @IBAction func dislikeButtonPressed(sender: UIButton) {
        let url = "\(self.post!.url())/dislikes.json"
        Manager.sharedInstance.request(.POST, url).responseJSON { (request, response, data, error) in
            self.updatePost()
        }
    }
    
    public func updatePost() {
        let url = "\(self.post!.url()).json"
        Manager.sharedInstance.request(.GET, url).responseJSON { (req, res, data, err) in
            var json = JSON(data!)
            self.post!.updateFromJSON(json)
            self.setPost(self.post!)
        }
    }
}