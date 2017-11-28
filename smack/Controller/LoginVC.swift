//
//  LoginVC.swift
//  smack
//
//  Created by Brian  Crowley on 16/11/2017.
//  Copyright © 2017 Brian Crowley. All rights reserved.
//

import UIKit

class LoginVC: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    var loadingScreen : LoadingScreenVC!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
    }
    
    @IBAction func closeButtonWasPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func createAccountButtonPressed(_ sender: Any) {
        performSegue(withIdentifier: TO_CREATE_ACCOUNT, sender: nil)
    }
    
    @IBAction func loginButtonWasPressed(_ sender: Any) {
        guard let email = emailTextField.text, emailTextField.text != "" else { return }
        guard let password = passwordTextField.text, passwordTextField.text != "" else { return }
        
        present(loadingScreen, animated: false, completion: nil)
        
        AuthServices.instance.loginUser(email: email, password: password) { (success) in
            
            if success {
                AuthServices.instance.findUserByEmail(completion: { (success) in
                    if success {
                        self.loadingScreen.hide(completion: { (complete) in
                            NotificationCenter.default.post(name: NOTIF_USER_DATA_DID_CHANGE, object: nil)
                            self.dismiss(animated: true, completion: nil)
                        })
                    }
                })
            } else {
                print("failed to log in by LoginVC")
            }
        }

    }
    
    func setUpView () {
        emailTextField.attributedPlaceholder = NSAttributedString(string: "email", attributes: [NSAttributedStringKey.foregroundColor: COLOR_PURPLE])
        passwordTextField.attributedPlaceholder = NSAttributedString(string: "password", attributes: [NSAttributedStringKey.foregroundColor: COLOR_PURPLE])
        
        loadingScreen = LoadingScreenVC()
        loadingScreen.modalPresentationStyle = .custom
    }
}
