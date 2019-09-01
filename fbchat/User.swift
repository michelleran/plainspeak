//
//  User.swift
//  fbchat
//
//  Created by Michelle Ran on 6/25/16.
//  Copyright © 2016 Michelle Ran LLC. All rights reserved.
//

import Foundation

public class User {
    var id: String = ""
    var username: String = ""
    var email: String = ""
    var sessions: [String] = []
    
    init(id: String, username: String, email: String) {
        self.id = id
        self.username = username
        self.email = email
    }
    
    init(id: String, username: String, email: String, sessions: [String]) {
        self.id = id
        self.username = username
        self.email = email
        self.sessions = sessions
    }
    
    init() { }
}