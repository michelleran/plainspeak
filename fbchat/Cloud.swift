//
//  Cloud.swift
//  fbchat
//
//  Created by Michelle Ran on 6/25/16.
//  Copyright © 2016 Michelle Ran LLC. All rights reserved.
//

import Foundation
import Firebase
import FirebaseAuth
import FirebaseDatabase

public class Cloud {
    // will transfer chatting-related funcs into here later
    public static var ref: FIRDatabaseReference!
    public static var usersRef: FIRDatabaseReference!
    public static var sessionsRef: FIRDatabaseReference!
    public static var messagesRef: FIRDatabaseReference!
    
    public static var user: User = User()
    
    //--- General ---//
    public static func setup() {
        ref = FIRDatabase.database().reference()
        usersRef = ref.child("users")
        sessionsRef = ref.child("sessions")
        messagesRef = ref.child("messages")
    }
    
    //--- Users ---//
    public static func authUser(username: String, email: String, password: String, completion: (NSError?) -> ()) {
        FIRAuth.auth()?.signInWithEmail(email, password: password) { (user, error) in
            if error != nil {
                FIRAuth.auth()?.createUserWithEmail(email, password: password) { (user, error) in
                    // creating user signs them in too
                    if error == nil {
                        let userArray = [
                            "username": username,
                            "email": email
                        ]
                        self.usersRef.child(user!.uid).setValue(userArray)
                        self.user = User(id: user!.uid, username: username, email: email)
                    }
                    completion(error)
                }
            } else {
                self.user = User(id: user!.uid, username: username, email: email)
                completion(error)
            }
        }
    }
    
    public static func getUserWithKey(key: String, equalTo: String, completion: (User?) -> ()) {
        usersRef.queryOrderedByChild(key).queryEqualToValue(equalTo).observeSingleEventOfType(.Value) { (snapshot: FIRDataSnapshot!) in
            // assuming there's exactly 1 result for rn
            var info: NSDictionary = snapshot.value as! NSDictionary
            let id = info.allKeys.first! as! String
            info = info.valueForKey(id) as! NSDictionary
            let sessions = (info["sessions"] == nil) ? [] : ((info["sessions"] as! NSDictionary).allKeys as! [String])
            let user = User(id: id, username: info["username"] as! String, email: info["email"] as! String, sessions: sessions)
            completion(user)
            // but what if none are found? i think value will be nil...
        }
    }
    
    public static func setValueForUser(user: String, key: String, value: AnyObject) {
        usersRef.child("\(user)/\(key)").setValue(value)
    }
    
    public static func updateValueForUser(user: String, key: String, value: NSDictionary) {
        // assumes that the values to add & the existing values are of the same dictionary type, i.e. same type of keys & values
        updateHelper(user, key: key, value: value) { (new: NSDictionary) in
            usersRef.child("\(user)/\(key)").setValue(new)
        }
    }
    
    private static func updateHelper(user: String, key: String, value: NSDictionary, completion: (NSDictionary) -> ()) {
        usersRef.child("\(user)/\(key)").observeSingleEventOfType(.Value) { (snapshot: FIRDataSnapshot) in
            if let data = snapshot.value as? NSDictionary {
                let new = data
                for key in value.allKeys as! [String] { new.setValue(value.valueForKey(key), forKey: key) }
                completion(new)
            } else {
                // temp, may change later, b/c this might not be the proper response (snapshot.value == nil doesn't work)
                completion(value)
            }
        }
    }
    
    //--- Sessions ---//
    public static func newSession(members: [String]) -> Session {
        let sessionRef = sessionsRef.childByAutoId()
        var dict: [String: Bool] = [:]
        for member in members {
            dict[member] = true
            updateValueForUser(member, key: "sessions", value: [sessionRef.key: true])
        }
        sessionRef.setValue(["members": dict, "latest": ["sender": "None", "msg": "No messages yet.", "time": ""]])
        return Session(id: sessionRef.key, members: members)
    }
    
    public static func observeSessions(completion: (Session) -> ()) {
        usersRef.child("\(user.id)/sessions").observeEventType(.ChildAdded) { (snapshot: FIRDataSnapshot) in
            getSessionWithId(snapshot.key) { (session: Session) in
                completion(session)
            }
        }
    }
    
    public static func getSessionWithId(id: String, completion: (Session) -> ()) {
        sessionsRef.child(id).observeSingleEventOfType(.Value) { (snapshot: FIRDataSnapshot) in
            let data = snapshot.value as! NSDictionary
            let members = data.valueForKey("members") as! NSDictionary
            completion(Session(id: snapshot.key, members: members.allKeys as! [String], latest: data.valueForKey("latest") as! [String: String]))
            //completion(Session(id: snapshot.key, members: data["members"] as! [String])) // not gonna retrieve messages yet
        }
    }
    
    public static func sendMessage(message: [String: String], session: Session) {
        let itemRef = messagesRef.child(session.id).childByAutoId()
        itemRef.setValue(message)
        sessionsRef.child("\(session.id)/latest").setValue(message)
    }
    
    public static func observeMessagesForSession(session: String, sender: UIViewController) {
        messagesRef.child(session).observeEventType(.ChildAdded) { (snapshot: FIRDataSnapshot!) in
            let message = snapshot.value as! NSDictionary
            if let chatVC = sender as? ChatViewController {
                chatVC.updateMessages(message)
            }
        }
        // currently doesn't handle any local storage of messages
    }
}
