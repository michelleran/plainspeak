//
//  ChatCell.swift
//  fbchat
//
//  Created by Michelle Ran on 6/30/16.
//  Copyright © 2016 Michelle Ran LLC. All rights reserved.
//

import Foundation
import UIKit

class ChatCell: UITableViewCell {
    @IBOutlet var membersLabel: UILabel!
    @IBOutlet var latestMessage: UILabel!
    @IBOutlet var timeLabel: UILabel!
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}