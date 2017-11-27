//
//  ChatVC.swift
//  smack
//
//  Created by Brian  Crowley on 16/11/2017.
//  Copyright © 2017 Brian Crowley. All rights reserved.
//

import UIKit

class ChatVC: UIViewController {

    @IBOutlet weak var menuButton : UIButton!
    @IBOutlet weak var channelNameLabel: UILabel!
    @IBOutlet weak var messageField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(ChatVC.handleTap))
        view.addGestureRecognizer(tap)
        
        menuButton.addTarget(revealViewController(), action: #selector(SWRevealViewController.revealToggle(_:)), for: .touchUpInside)
        view.addGestureRecognizer(revealViewController().panGestureRecognizer())
        view.addGestureRecognizer(revealViewController().tapGestureRecognizer())
        
        NotificationCenter.default.addObserver(self, selector: #selector(userDataDidChange(_:)), name: NOTIF_USER_DATA_DID_CHANGE, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(channelSelected(_:)), name: NOTIF_CHANNEL_SELECTED, object: nil)
        view.bindToKeyboard()
        
        CheckIfLoggedInAndUpdateInfo()
    }
    
    
    @objc func userDataDidChange(_ notif: Notification) {
        if AuthServices.instance.loggedIn {
            getMessagesOnLogin()
        } else {
            channelNameLabel.text = "Please Login"
        }
    }
    
    @objc func channelSelected(_ notif: Notification) {
        updateWithChannel()
    }
    
    @objc func handleTap () {
        view.endEditing(true)
    }
    
    func updateWithChannel () {
        let channelName = MessageServices.instance.selectedChannel?.name ?? ""
        channelNameLabel.text = "#\(channelName)"
        getMessages()
    }
    
    
    func CheckIfLoggedInAndUpdateInfo () {
        
        if AuthServices.instance.loggedIn {
            AuthServices.instance.findUserByEmail(completion: { (success) in
                if success {
                    NotificationCenter.default.post(name: NOTIF_USER_DATA_DID_CHANGE, object: nil)
                } else {
                    print("failed to find user by email in ChatVC")
                }
            })
        }
    }
    
    func getMessagesOnLogin () {
        MessageServices.instance.findAllChannels { (success) in
            if success {
                if MessageServices.instance.channels.count > 0 {
                    MessageServices.instance.selectedChannel = MessageServices.instance.channels[0]
                    self.updateWithChannel()
                } else {
                    self.channelNameLabel.text = "No channels yet!"
                }
            } else {
                print("failed to findAllChannels in ChatVC")
            }
        }
    }
    
    func getMessages () {
        
        guard let channelId = MessageServices.instance.selectedChannel?.id else { return }
        MessageServices.instance.findAllMessagesByChannel(id: channelId) { (success) in
            if success {
                print("SUCCESS: \(MessageServices.instance.messages[0])")
            }
        }
    }

    @IBAction func sendMessagePressed(_ sender: Any) {
                
        if AuthServices.instance.loggedIn {
            guard let message = messageField.text else { return }
            guard let channelId = MessageServices.instance.selectedChannel?.id else { return }

            SocketServices.instance.addMessage(messageBody: message, userId: UserDataServices.instance.id, channelId: channelId, completion: { (success) in
                if success {
                    self.messageField.text = ""
                    self.messageField.resignFirstResponder()
                } else {
                    print("failed to send message in ChatVC")
                }
            })
        }
    }
    

}
