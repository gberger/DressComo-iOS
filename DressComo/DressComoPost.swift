//
//  DressComoPost.swift
//  DressComo
//
//  Created by Guilherme Berger on 4/4/15.
//  Copyright (c) 2015 Guilherme Berger. All rights reserved.
//

import Foundation
import SwiftyJSON

public class DressComoPost {
    var id : Int? = nil
    var text : String? = nil
    var cloudinary_image_id : String = ""
    var author : String? = nil
    var likes : Int = 0
    var dislikes : Int = 0

    init(json: JSON) {
        self.updateFromJSON(json)
    }
    
    func updateFromJSON(json: JSON) {
        self.id = Int(json["id"].doubleValue)
        self.text = json["text"].stringValue
        self.cloudinary_image_id = json["cloudinary_image_id"].stringValue
        self.likes = Int(json["cached_votes_up"].doubleValue)
        self.dislikes = Int(json["cached_votes_down"].doubleValue)
    }
    
    func image_url () -> NSURL {
        return NSURL(string: "http://res.cloudinary.com/gberger/image/upload/\(self.cloudinary_image_id).jpg")!
    }
    
    func url () -> String {
        return "http://localhost:3000/api/posts/\(self.id!)"
    }
}
