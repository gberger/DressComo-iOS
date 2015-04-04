//
//  PostTableViewCell.swift
//  DressComo
//
//  Created by Guilherme Berger on 4/4/15.
//  Copyright (c) 2015 Guilherme Berger. All rights reserved.
//

import Foundation
import UIKit

public class PostTableViewCell : UITableViewCell {
    
    @IBOutlet weak var outfitImage: UIImageView!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var dislikeButton: UIButton!
    @IBOutlet weak var likeLabel: UILabel!
    @IBOutlet weak var dislikeLabel: UILabel!
    
    public func setPost(post: DressComoPost) {
        var url : NSURL
        url = post.image_url()
        outfitImage!.hnk_setImageFromURL(url)
        descriptionLabel.text = post.text
        likeLabel.text = "\(post.likes)"
        dislikeLabel.text = "\(post.dislikes)"
    }
}