//
//  Session.swift
//  fbchat
//
//  Created by Michelle Ran on 6/26/16.
//  Copyright © 2016 Michelle Ran LLC. All rights reserved.
//

import Foundation

public class Session {
    var id: String!
    var members: [String] = []
    var messages: [String] = [] // handle later, also may change type
    var latest: [String: String] = [:]
    
    init(id: String, members: [String]) { // may change parameters later
        self.id = id
        self.members = members
    }
    
    init(id: String, members: [String], latest: [String: String]) { // may change parameters later
        self.id = id
        self.members = members
        self.latest = latest
    }
}