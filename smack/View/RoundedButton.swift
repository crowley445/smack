//
//  RoundedButton.swift
//  smack
//
//  Created by Brian  Crowley on 19/11/2017.
//  Copyright © 2017 Brian Crowley. All rights reserved.
//

import UIKit

@IBDesignable
class RoundedButton: UIButton {
    
    @IBInspectable var cornerRadius: CGFloat = 3.0 {
        didSet {
            layer.cornerRadius = cornerRadius
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setUpView()
    }
    
    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        setUpView()
    }
    
    func setUpView () {
        layer.cornerRadius = cornerRadius
    }
}
