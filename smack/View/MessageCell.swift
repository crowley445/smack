//
//  MessageCell.swift
//  smack
//
//  Created by Brian  Crowley on 28/11/2017.
//  Copyright © 2017 Brian Crowley. All rights reserved.
//

import UIKit

class MessageCell: UITableViewCell {

    @IBOutlet weak var avatar: CircleImage!
    @IBOutlet weak var username: UILabel!
    @IBOutlet weak var timestamp: UILabel!
    @IBOutlet weak var messageBody: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func configureCell(message: Message) {
        avatar.image = UIImage(named: message.avatarName)
        avatar.backgroundColor = UserDataServices.instance.returnUIColor(components: message.avatarColor)
        username.text = message.userName
        messageBody.text = message.message
    }

}
