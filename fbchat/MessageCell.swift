//
//  MessageCell.swift
//  fbchat
//
//  Created by Michelle Ran on 7/1/16.
//  Copyright © 2016 Michelle Ran LLC. All rights reserved.
//

import Foundation
import UIKit

class MessageCell: UITableViewCell {
    @IBOutlet var senderLabel: UILabel!
    @IBOutlet var timeLabel: UILabel!
    @IBOutlet var messageLabel: UILabel!
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}