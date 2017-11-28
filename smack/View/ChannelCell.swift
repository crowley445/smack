//
//  ChannelCell.swift
//  smack
//
//  Created by Brian  Crowley on 25/11/2017.
//  Copyright © 2017 Brian Crowley. All rights reserved.
//

import UIKit

class ChannelCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        if selected {
            backgroundColor = UIColor(white: 1, alpha: 0.2)
        } else {
            backgroundColor = UIColor.clear
        }
    }
    
    func configureCell(channel : Channel) {
        let channelName = channel.name ?? ""
        nameLabel.text = "#\(channelName)"
        nameLabel.font = UIFont(name: "Avenir-Book", size: 17)
        
        for id in MessageServices.instance.unreadChannels {
            if id == channel.id {
                nameLabel.font = UIFont(name: "Avenir-Heavy", size: 20)
            }
        }
    }
}
