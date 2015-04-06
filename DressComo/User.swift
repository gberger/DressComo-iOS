//
//  User.swift
//  DressComo
//
//  Created by Guilherme Berger on 4/5/15.
//  Copyright (c) 2015 Guilherme Berger. All rights reserved.
//

import Foundation
import Locksmith
import SwiftyJSON

public struct User {
    
    static var sharedInstance : UserClass {
        struct Static {
            static let instance : UserClass = UserClass()
        }
        return Static.instance
    }
}

public class UserClass {
    
    var authenticated = false
    var email : String = ""
    var token : String = ""
    var username : String = ""
    var name : String = ""
    var location : String = ""
    var bio : String = ""
    
    init() {
        let (dictMaybe, err) = Locksmith.loadDataForUserAccount("userAccount")
        if let dict = dictMaybe {
            let email = dict["email"] as String?
            let token = dict["token"] as String?
            if email != nil && token != nil {
                self.email = email!
                self.token = token!
                self.authenticated = true
            }
        }
    }
    
    public func update (#json: JSON) {
        self.email = json["email"].stringValue
        self.token = json["authentication_token"].stringValue
        self.username = json["username"].stringValue
        self.authenticated = true
        Locksmith.saveData(["email": email, "token": token], forUserAccount: "userAccount")
        
        if let name = json["name"].string {
            self.name = name
        }
        if let location = json["location"].string {
            self.location = location
        }
        if let bio = json["bio"].string {
            self.bio = bio
        }
    }
    
    public func erase () {
        self.email = ""
        self.token = ""
        self.username = ""
        self.name = ""
        self.bio = ""
        self.location = ""
        self.authenticated = false
        Locksmith.deleteDataForUserAccount("userAccount")
    }
}