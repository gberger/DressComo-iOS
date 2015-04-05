//
//  User.swift
//  DressComo
//
//  Created by Guilherme Berger on 4/5/15.
//  Copyright (c) 2015 Guilherme Berger. All rights reserved.
//

import Foundation
import Locksmith

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
    
    public func updateCredentials (#email: String, token: String) {
        self.email = email
        self.token = token
        self.authenticated = true
        Locksmith.saveData(["email": email, "token": token], forUserAccount: "userAccount")
    }
    
    public func eraseCredentials () {
        self.email = ""
        self.token = ""
        self.authenticated = false
        Locksmith.deleteDataForUserAccount("userAccount")
    }
}