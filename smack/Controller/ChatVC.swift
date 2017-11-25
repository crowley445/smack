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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        menuButton.addTarget(revealViewController(), action: #selector(SWRevealViewController.revealToggle(_:)), for: .touchUpInside)
        view.addGestureRecognizer(revealViewController().panGestureRecognizer())
        view.addGestureRecognizer(revealViewController().tapGestureRecognizer())
        
        CheckIfLoggedInAndUpdateInfo()
        
        MessageServices.instance.findAllChannels { (success) in
            if success {
                debugPrint(MessageServices.instance.channels)
            } else {
                debugPrint("FUCK!")
            }
        }
    }
    
    private func CheckIfLoggedInAndUpdateInfo () {
        
        if AuthServices.instance.loggedIn {
            AuthServices.instance.findUserByEmail(completion: { (success) in
                
                if success {
                    NotificationCenter.default.post(name: NOTIF_USER_DATA_DID_CHANGE, object: nil)
                } else {
                    debugPrint("failed to find user by email in ChatVC")
                }
            })
        }
        
    }
    

}
