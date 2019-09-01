//
//  ChatsViewController.swift
//  fbchat
//
//  Created by Michelle Ran on 6/30/16.
//  Copyright © 2016 Michelle Ran LLC. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import FirebaseAuth

class ChatsViewController: UITableViewController {
    @IBAction func logout(sender: AnyObject) {
        do {
            try FIRAuth.auth()?.signOut()
            Cloud.user = User()
            self.dismissViewControllerAnimated(true, completion: nil)
            // but fields in authvc are still filled in...
        } catch {
            Popup.pop("Oops!", message: "Couldn't log out.", sender: self)
        }
    }
    
    var chats: [Session] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Cloud.observeSessions { (session: Session) in
            self.update(session)
        }
        // currently still doesn't like update latest message though
    }
    
    func update(with: Session) {
        chats.append(with)
        tableView.beginUpdates()
        tableView.insertRowsAtIndexPaths([NSIndexPath(forRow: self.chats.count-1, inSection: 0)], withRowAnimation: .Automatic)
        tableView.endUpdates()
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return chats.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell: ChatCell = tableView.dequeueReusableCellWithIdentifier("ChatCell", forIndexPath: indexPath) as! ChatCell
        let chat = chats[indexPath.row]
        cell.membersLabel.text = "\(chat.members.count) members"
        cell.latestMessage.text = "\(chat.latest["sender"]!): \(chats[indexPath.row].latest["msg"]!)"
        cell.timeLabel.text = chat.latest["time"]!
        return cell
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let chatVC = segue.destinationViewController as? ChatViewController  {
            chatVC.session = chats[tableView.indexPathForSelectedRow!.row]
        }
    }
}
