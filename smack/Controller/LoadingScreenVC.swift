//
//  ActivityIndicatorVC.swift
//  smack
//
//  Created by Brian  Crowley on 24/11/2017.
//  Copyright © 2017 Brian Crowley. All rights reserved.
//

import UIKit

class LoadingScreenVC: UIViewController {

    @IBOutlet weak var spinner : UIActivityIndicatorView!
    
    private let fadeTime : Double = 0.2
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        fadeInView()
    }
    
    private func fadeInView () {
        view.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0)
        UIView.animate(withDuration: fadeTime, animations: {
            self.view.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.8)
        }) { (finisded) in
            self.spinner.startAnimating()
        }
    }
    
    public func hide(completion: @escaping (_ success: Bool) -> Void ) {
        
        UIView.animate(withDuration: fadeTime, animations: {
            self.view.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0)
        }) { (finished) in
            self.spinner.stopAnimating()
            self.dismiss(animated: false, completion: nil)
            return completion(finished)
        }
    }
}
