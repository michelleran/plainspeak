//
//  Popup.swift
//  fbchat
//
//  Created by Michelle Ran on 6/25/16.
//  Copyright © 2016 Michelle Ran LLC. All rights reserved.
//

import Foundation
import UIKit

public class Popup {
    public static func pop(title: String, message: String, sender: UIViewController) {
        dispatch_async(dispatch_get_main_queue()) {
            let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
            sender.presentViewController(alert, animated: true, completion: nil)
        }
    }
    
    public static func popWithField(title: String, message: String, sender: UIViewController, completion: (String) -> ()) {
        dispatch_async(dispatch_get_main_queue()) {
            let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
            alert.addTextFieldWithConfigurationHandler { (textField) in }
            alert.addAction(UIAlertAction(title: "Go!", style: UIAlertActionStyle.Default) { (action) in
                completion(alert.textFields![0].text!)
            })
            sender.presentViewController(alert, animated: true, completion: nil)
        }
    }
}