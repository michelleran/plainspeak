//
//  AuthViewController.swift
//  fbchat
//
//  Created by Michelle Ran on 6/25/16.
//  Copyright © 2016 Michelle Ran LLC. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import FirebaseAuth

class AuthViewController: UIViewController {
    @IBOutlet var usernameField: UITextField!
    @IBOutlet var emailField: UITextField!
    @IBOutlet var passwordField: UITextField!
    
    @IBAction func login(sender: AnyObject) {
        Cloud.authUser(usernameField.text!, email: emailField.text!, password: passwordField.text!) { (error: NSError?) in
            if error == nil {
                self.usernameField.text = ""
                self.emailField.text = ""
                self.passwordField.text = ""
                self.performSegueWithIdentifier("authd", sender: nil)
            } else {
                Popup.pop("Oops!", message: "Couldn't authenticate.", sender: self)
            }
        }
    }
    
    var userToChatWith: User = User()
}