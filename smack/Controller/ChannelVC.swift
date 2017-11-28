//
//  ChannelVC.swift
//  smack
//
//  Created by Brian  Crowley on 16/11/2017.
//  Copyright © 2017 Brian Crowley. All rights reserved.
//

import UIKit

class ChannelVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
   
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var userImage: CircleImage!
    @IBAction func prepareForUnwind(segue: UIStoryboardSegue){}
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        revealViewController().rearViewRevealWidth = view.frame.size.width - 60
        
        NotificationCenter.default.addObserver(self, selector: #selector(userDataDidChange(_:)), name: NOTIF_USER_DATA_DID_CHANGE, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(channelsLoaded(_:)), name: NOTIF_CHANNELS_LOADED, object: nil)
        
        SocketServices.instance.getChatMessage { (newMessage) in
            if MessageServices.instance.selectedChannel?.id != newMessage.channelId && AuthServices.instance.loggedIn {
                MessageServices.instance.unreadChannels.append(newMessage.channelId)
                self.tableView.reloadData()
            }
        }
        
        SocketServices.instance.getChannel { (succes) in
            if succes {
                self.tableView.reloadData()
            } 
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        setupUserInfo()
    }

    @objc func userDataDidChange(_ notif: Notification) {
        setupUserInfo()
    }
    
    @objc func channelsLoaded(_ notif: Notification) {
        tableView.reloadData()
    }
    
    func setupUserInfo () {
        if AuthServices.instance.loggedIn {
            loginButton.setTitle(UserDataServices.instance.name, for: .normal)
            userImage.image = UIImage(named: UserDataServices.instance.avatarName)
            userImage.backgroundColor = UserDataServices.instance.returnUIColor(components: UserDataServices.instance.avatarColor)
        } else {
            loginButton.setTitle("Login", for: .normal)
            userImage.image = UIImage(named: "menuProfileIcon")
            userImage.backgroundColor = UIColor.lightGray
            tableView.reloadData()
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "channelCell", for: indexPath) as? ChannelCell {
            cell.configureCell(channel: MessageServices.instance.channels[indexPath.row])
            return cell
        }
        return UITableViewCell()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return MessageServices.instance.channels.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let channel = MessageServices.instance.channels[indexPath.row]
        if MessageServices.instance.unreadChannels.count > 0 {
            MessageServices.instance.unreadChannels = MessageServices.instance.unreadChannels.filter{$0 != channel.id}
        }
        
        let index = IndexPath(item: indexPath.row, section: 0)
        tableView.reloadRows(at: [indexPath], with: .none)
        tableView.selectRow(at: index, animated: false, scrollPosition: .none)
        
        MessageServices.instance.selectedChannel = MessageServices.instance.channels[indexPath.row]
        NotificationCenter.default.post(name: NOTIF_CHANNEL_SELECTED, object: nil)
        revealViewController().revealToggle(animated: true)
    }
    
    @IBAction func addChannelPressed(_ sender: Any) {
        if AuthServices.instance.loggedIn {
            let addChannel = AddChannelVC()
            addChannel.modalPresentationStyle = .custom
            present(addChannel, animated: true, completion: nil)
        }
    }
    
    @IBAction func loginButtonPressed(_ sender: Any) {
        if AuthServices.instance.loggedIn {
            let profile = ProfileVC()
            profile.modalPresentationStyle = .custom
            present(profile, animated: true, completion: nil)
        }else {
            performSegue(withIdentifier: TO_LOGIN, sender: nil)
        }
    }
}
