//
//  LoginVC.swift
//  smack
//
//  Created by Brian  Crowley on 16/11/2017.
//  Copyright © 2017 Brian Crowley. All rights reserved.
//

import UIKit

class LoginVC: UIViewController {

    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func closeButtonWasPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func createAccountButtonPressed(_ sender: Any) {
        performSegue(withIdentifier: TO_CREATE_ACCOUNT, sender: nil)
    }
    @IBAction func loginButtonWasPressed(_ sender: Any) {
    }
    
}
