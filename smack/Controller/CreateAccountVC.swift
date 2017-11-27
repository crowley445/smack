//
//  CreateAccountVC.swift
//  smack
//
//  Created by Brian  Crowley on 17/11/2017.
//  Copyright © 2017 Brian Crowley. All rights reserved.
//

import UIKit

class CreateAccountVC: UIViewController {

    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var userImage: UIImageView!
    
    var loadingScreen : LoadingScreenVC!
    
    var avatarName = "profileDefault"
    var avatarColor = "[0.5, 0.5, 0.5, 1]"
    var bgColor: UIColor?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        if UserDataServices.instance.avatarName != "" {
            self.avatarName = UserDataServices.instance.avatarName
            userImage.image = UIImage(named: self.avatarName)
        }
        
        if avatarName.contains("light") && bgColor == nil {
            userImage.backgroundColor = UIColor.lightGray
        }
    }

    @IBAction func createAccountPressed (_ sender: Any) {
        
        guard let username = usernameTextField.text , usernameTextField.text != "" else { return }
        guard let email = emailTextField.text , emailTextField.text != "" else { return }
        guard let password = passwordTextField.text, passwordTextField.text != "" else { return }
        
        present(loadingScreen!, animated: true, completion: nil)
        
        AuthServices.instance.registerUser(email: email, password: password) { (success) in
            if success {
                                
                AuthServices.instance.loginUser(email: email, password: password, completion: { (success) in
                    if success {
                        
                        AuthServices.instance.createUser(name: username, email: email, avatarName: self.avatarName, avatarColor: self.avatarColor, completion: { (success) in
                            
                            if success {
                                self.loadingScreen.hide(completion: { (completed) in
                                    NotificationCenter.default.post(name:NOTIF_USER_DATA_DID_CHANGE, object: nil)
                                    self.performSegue(withIdentifier: UNWIND_TO_CHANNEL, sender: nil)
                                })
                            } else {
                                debugPrint("failed to create user in CreateAccountVC")
                            }

                        })
                        
                    } else {
                        print("user login failed.")
                    }
                })
                
            } else {
                print("registered user failed!")
            }
        }
    }
    
    @IBAction func chooseAvatarButtonPressed(_ sender: Any) {
        self.performSegue(withIdentifier: TO_AVATAR_PICKER, sender: nil)
    }
    
    @IBAction func pickBGColorPressed(_ sender: Any) {
        let r = CGFloat( arc4random_uniform(255) ) / 255
        let g = CGFloat( arc4random_uniform(255) ) / 255
        let b = CGFloat( arc4random_uniform(255) ) / 255

        bgColor = UIColor(red: r, green: g, blue: b, alpha: 1)
        avatarColor = "[\(r), \(g), \(b), 1]"
        
        UIView.animate(withDuration: 0.2) {
            self.userImage.backgroundColor = self.bgColor
        }
    }
    
    @IBAction func closeButtonWasPressed(_ sender: Any) {
        performSegue(withIdentifier: UNWIND_TO_CHANNEL, sender: nil)
    }
    
    func setUpView () {
        
        usernameTextField.attributedPlaceholder = NSAttributedString(string: "username", attributes: [NSAttributedStringKey.foregroundColor: COLOR_PURPLE])
        emailTextField.attributedPlaceholder = NSAttributedString(string: "email", attributes: [NSAttributedStringKey.foregroundColor: COLOR_PURPLE])
        passwordTextField.attributedPlaceholder = NSAttributedString(string: "password", attributes: [NSAttributedStringKey.foregroundColor: COLOR_PURPLE])
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(CreateAccountVC.handleTap))
        view.addGestureRecognizer(tap)
        
        loadingScreen = LoadingScreenVC()
        loadingScreen.modalPresentationStyle = .custom
    }


    @objc func handleTap () {
        view.endEditing(true)
    }
    
}
