//
//  ChatViewController.swift
//  fbchat
//
//  Created by Michelle Ran on 6/23/16.
//  Copyright © 2016 Michelle Ran LLC. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

class ChatViewController: UIViewController, UITableViewDataSource {
    @IBOutlet var msgField: UITextField!
    @IBOutlet var msgTable: UITableView!
    
    @IBAction func send(sender: AnyObject) {
        Cloud.sendMessage(["sender": Cloud.user.username, "msg": msgField.text!, "time": NSDateFormatter.localizedStringFromDate(NSDate(), dateStyle: .ShortStyle, timeStyle: .ShortStyle)], session: session)
        msgField.text = ""
    }
    
    @IBAction func tapped(sender: AnyObject) {
        view.endEditing(true)
    }
    
    var session: Session!
    var messages: [NSDictionary] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        msgTable.dataSource = self
        msgTable.rowHeight = UITableViewAutomaticDimension
        msgTable.estimatedRowHeight = 70.0
        Cloud.observeMessagesForSession(session.id, sender: self)
    }
    
    func updateMessages(message: NSDictionary) {
        messages.append(message)
        msgTable.beginUpdates()
        msgTable.insertRowsAtIndexPaths([NSIndexPath(forRow: messages.count-1, inSection: 0)], withRowAnimation: .Automatic)
        msgTable.endUpdates()
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell: MessageCell = tableView.dequeueReusableCellWithIdentifier("MessageCell", forIndexPath: indexPath) as! MessageCell
        let message = messages[indexPath.row]
        cell.senderLabel.text = message.valueForKey("sender") as? String
        cell.timeLabel.text = message.valueForKey("time") as? String
        cell.messageLabel.text = message.valueForKey("msg") as? String
        return cell
    }
}

