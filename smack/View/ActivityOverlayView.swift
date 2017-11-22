//
//  ActivityOverlayView.swift
//  smack
//
//  Created by Brian  Crowley on 22/11/2017.
//  Copyright © 2017 Brian Crowley. All rights reserved.
//

import UIKit

class ActivityOverlayView: UIView {
    
    var spinner : UIActivityIndicatorView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setAppearanceAndInitializeSpinner()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setAppearanceAndInitializeSpinner () {
        self.isHidden = true
        self.backgroundColor = UIColor.black
        
        spinner = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.whiteLarge)
        spinner.center = self.center
        spinner.hidesWhenStopped = true
        self.addSubview(spinner)
    }
    
    func show () {
        spinner.alpha = 0
        alpha = 0
        
        self.isHidden = false
        spinner.startAnimating()
        
        UIView.animate(withDuration: 0.2) {
            self.spinner.alpha = 1
            self.alpha = 0.8
        }
    }
    
    func hide () {
        self.isHidden = true
        spinner.stopAnimating()
    }

}
