//
//  CircleImage.swift
//  smack
//
//  Created by Brian  Crowley on 21/11/2017.
//  Copyright © 2017 Brian Crowley. All rights reserved.
//

import UIKit

class CircleImage: UIImageView {

    override func awakeFromNib() {
        super.awakeFromNib()
        setUpView()
    }

    override func prepareForInterfaceBuilder() {
        setUpView()
    }
    
    
    func setUpView() {
        layer.cornerRadius = frame.width / 2
        clipsToBounds = true
    }
}
