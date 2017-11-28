//
//  AddChannelVC.swift
//  smack
//
//  Created by Brian  Crowley on 25/11/2017.
//  Copyright © 2017 Brian Crowley. All rights reserved.
//

import UIKit

class AddChannelVC: UIViewController {

    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var descriptionTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
    }
    
    func setUpView () {
        nameTextField.attributedPlaceholder = NSAttributedString(string: "name", attributes: [NSAttributedStringKey.foregroundColor: COLOR_PURPLE])
        descriptionTextField.attributedPlaceholder = NSAttributedString(string: "description", attributes: [NSAttributedStringKey.foregroundColor: COLOR_PURPLE])
        
        let tapClose = UITapGestureRecognizer(target: self, action: #selector(AddChannelVC.closeOnTap(_:)) )
        backgroundView.addGestureRecognizer(tapClose)
    }
    
    @objc func closeOnTap (_ recognizer: UITapGestureRecognizer) {
        dismiss(animated: true, completion: nil)
    }

    @IBAction func closeButtonPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func createChannelPressed(_ sender: Any) {
        guard let name = nameTextField.text, nameTextField.text != "" else { return }
        guard let descrption = descriptionTextField.text else { return }
        
        SocketServices.instance.addChannel(name: name, description: descrption) { (success) in
            if success {
                self.dismiss(animated: true, completion: nil)
            } else {
                debugPrint("failed to add channel on press in AddChannelVC")
            }
        }
    }
}
