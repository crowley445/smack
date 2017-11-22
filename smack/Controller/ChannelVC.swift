//
//  ChannelVC.swift
//  smack
//
//  Created by Brian  Crowley on 16/11/2017.
//  Copyright © 2017 Brian Crowley. All rights reserved.
//

import UIKit

class ChannelVC: UIViewController {

    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var userImage: CircleImage!
    @IBAction func prepareForUnwind(segue: UIStoryboardSegue){}
    
    override func viewDidLoad() {
        super.viewDidLoad()
        revealViewController().rearViewRevealWidth = view.frame.size.width - 60
        NotificationCenter.default.addObserver(self, selector: #selector(userDataDidChange(_:)), name: NOTIF_USER_DATA_DID_CHANGE, object: nil)
    }

    @objc func userDataDidChange(_ notif: Notification) {
        if AuthServices.instance.loggedIn {
            loginButton.setTitle(UserDataServices.instance.name, for: .normal)
            userImage.image = UIImage(named: UserDataServices.instance.avatarName)
            userImage.backgroundColor = UserDataServices.instance.returnUIColor(components: UserDataServices.instance.avatarColor)
        } else {
            loginButton.setTitle("Login", for: .normal)
            userImage.image = UIImage(named: "menuProfileIcon")
            userImage.backgroundColor = UIColor.lightGray
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
