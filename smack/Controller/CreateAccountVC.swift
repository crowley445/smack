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

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    @IBAction func createAccountPressed (_ sender: Any) {
        
        //guard let username = usernameTextField.text , usernameTextField.text != "" else { return }
        guard let email = emailTextField.text , emailTextField.text != "" else { return }
        guard let password = passwordTextField.text, passwordTextField.text != "" else { return }
        
        AuthServices.instance.registerUser(email: email, password: password) { (success) in
            if success {
                print("registered user!")
                
                AuthServices.instance.loginUser(email: email, password: password, completion: { (success) in
                    if success {
                        print("user logged in!")
                    } else {
                        print("user login failed.")
                    }
                })
                
            } else {
                print("registered user failed!")
            }
        }
    }
    
    @IBAction func closeButtonWasPressed(_ sender: Any) {
        performSegue(withIdentifier: UNWIND_TO_CHANNEL, sender: nil)
    }
}
