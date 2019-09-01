//
//  NewChatController.swift
//  fbchat
//
//  Created by Michelle Ran on 7/1/16.
//  Copyright © 2016 Michelle Ran LLC. All rights reserved.
//

import Foundation
import UIKit

class NewChatController: UIViewController {
    @IBOutlet var field: UITextField!
    
    @IBAction func pressed(sender: UIButton) {
        if let email = field.text {
            Cloud.getUserWithKey("email", equalTo: email) { (user: User?) in
                if let u = user {
                    let session = Cloud.newSession([Cloud.user.id, u.id])
                    self.new = session
                    self.performSegueWithIdentifier("newChat", sender: self)
                }
            }
        }
    }
    
    var new: Session!
    
    // may change to a TVC later
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let chatVC = segue.destinationViewController as? ChatViewController {
            chatVC.session = new
        }
    }
}