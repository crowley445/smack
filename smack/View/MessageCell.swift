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
        
        guard var isoDate = message.timeStamp else { return }
        let end = isoDate.index(isoDate.endIndex, offsetBy: -5)
        isoDate = isoDate.substring(to: end)
        
        let isoFormatter = ISO8601DateFormatter()
        let chatDate = isoFormatter.date(from: isoDate.appending("Z"))
        
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d, h:mm a"
        
        if let finalDate = chatDate {
            let finalDate = formatter.string(from: finalDate)
            timestamp.text = finalDate
        }
    }
}
