//
//  ProfileVC.swift
//  smack
//
//  Created by Brian  Crowley on 22/11/2017.
//  Copyright © 2017 Brian Crowley. All rights reserved.
//

import UIKit

class ProfileVC: UIViewController {

    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var userEmail: UILabel!

    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setUpView()
    }

    func setUpView() {
        userImage.image = UIImage(named: UserDataServices.instance.avatarName)
        userImage.backgroundColor = UserDataServices.instance.returnUIColor(components: UserDataServices.instance.avatarColor)
        userName.text = UserDataServices.instance.name
        userEmail.text = UserDataServices.instance.email
        
        let closeTouch = UITapGestureRecognizer(target: self, action: #selector(ProfileVC.closeOnTap(_:)))
        backgroundView.addGestureRecognizer(closeTouch)
    }
    
    @objc func closeOnTap(_ recogniser: UITapGestureRecognizer) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func closeButtonPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func logoutButtonPressed(_ sender: Any) {
        UserDataServices.instance.logoutUser()
        NotificationCenter.default.post(name: NOTIF_USER_DATA_DID_CHANGE, object: nil)
        dismiss(animated: true, completion: nil)
    }
    
}
