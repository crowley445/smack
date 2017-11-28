//
//  ChatVC.swift
//  smack
//
//  Created by Brian  Crowley on 16/11/2017.
//  Copyright © 2017 Brian Crowley. All rights reserved.
//

import UIKit

class ChatVC: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var menuButton : UIButton!
    @IBOutlet weak var channelNameLabel: UILabel!
    @IBOutlet weak var messageField: UITextField!
    @IBOutlet weak var tableview: UITableView!
    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var isTypingLabel: UILabel!
    
    var isTyping = false
    
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
        
        SocketServices.instance.getChatMessage { (success) in
            if (success) {
                self.tableview.reloadData()
                let endIndex = IndexPath(row: MessageServices.instance.messages.count - 1, section: 0)
                self.tableview.scrollToRow(at: endIndex, at: .bottom, animated: false)
            }
        }
        
        SocketServices.instance.getTypingUsers { (typingUsers) in
            guard let channelId = MessageServices.instance.selectedChannel?.id else { return }
            var names = ""
            var numberOfTypers = 0
            
            for (typingUser, channel) in typingUsers {
                if typingUser != UserDataServices.instance.name && channel == channelId {
                    names = names == "" ? typingUser : "\(names), \(typingUser)"
                    numberOfTypers += 1
                }
            }
            
            if numberOfTypers > 0 && AuthServices.instance.loggedIn {
                let verb = numberOfTypers > 1 ? "are" : "is"
                self.isTypingLabel.text = "\(names) \(verb) typing a message"
            } else {
                self.isTypingLabel.text = ""
            }
        }
        
        tableview.delegate = self
        tableview.dataSource = self
        tableview.estimatedRowHeight = 80
        tableview.rowHeight = UITableViewAutomaticDimension
        
        sendButton.isHidden = true
        
        CheckIfLoggedInAndUpdateInfo()
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
    
    @objc func userDataDidChange(_ notif: Notification) {
        if AuthServices.instance.loggedIn {
            getMessagesOnLogin()
        } else {
            tableview.reloadData()
            channelNameLabel.text = "Please Login"
        }
    }
    
    @objc func channelSelected(_ notif: Notification) {
        updateWithChannel()
    }
    
    @objc func handleTap () {
        view.endEditing(true)
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
    
    func updateWithChannel () {
        let channelName = MessageServices.instance.selectedChannel?.name ?? ""
        channelNameLabel.text = "#\(channelName)"
        getMessages()
    }
    
    func getMessages () {
        
        guard let channelId = MessageServices.instance.selectedChannel?.id else { return }
        MessageServices.instance.findAllMessagesByChannel(id: channelId) { (success) in
            if success {
                self.tableview.reloadData()
            }
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableview.dequeueReusableCell(withIdentifier: "messageCell", for: indexPath) as? MessageCell {
            let message = MessageServices.instance.messages[indexPath.row]
            cell.configureCell(message: message)
            return cell
        }
        
        return MessageCell()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return MessageServices.instance.messages.count
    }
    
    @IBAction func sendMessagePressed(_ sender: Any) {
                
        if AuthServices.instance.loggedIn {
            guard let message = messageField.text else { return }
            guard let channelId = MessageServices.instance.selectedChannel?.id else { return }

            SocketServices.instance.addMessage(messageBody: message, userId: UserDataServices.instance.id, channelId: channelId, completion: { (success) in
                if success {
                    self.messageField.text = ""
                    self.messageField.resignFirstResponder()
                    SocketServices.instance.socket?.emit("stopType", UserDataServices.instance.name, channelId)
                } else {
                    print("failed to send message in ChatVC")
                }
            })
        }
    }
    
    @IBAction func messageFieldEditing(_ sender: Any) {
        guard let channelId = MessageServices.instance.selectedChannel?.id else { return }
        
        if messageField.text == ""  {
            isTyping = false
            sendButton.isHidden = true
            SocketServices.instance.socket?.emit("stopType", UserDataServices.instance.name, channelId)
        } else {
            if !isTyping {
                sendButton.isHidden = false
                SocketServices.instance.socket?.emit("startType", UserDataServices.instance.name, channelId)
            }
            isTyping = true
        }
    }
    
}
