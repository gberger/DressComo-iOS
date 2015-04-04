//
//  DressComoPost.swift
//  DressComo
//
//  Created by Guilherme Berger on 4/4/15.
//  Copyright (c) 2015 Guilherme Berger. All rights reserved.
//

import Foundation

public class DressComoPost {
    var id : Int? = nil
    var text : String? = nil
    var cloudinary_image_id : String = ""
    var author : String? = nil
    var likes : Int = 0
    var dislikes : Int = 0
    
    func image_url () -> NSURL {
        return NSURL(string: "http://res.cloudinary.com/gberger/image/upload/\(self.cloudinary_image_id).jpg")!
    }
}
