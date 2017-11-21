//
//  AvatarCell.swift
//  smack
//
//  Created by Brian  Crowley on 20/11/2017.
//  Copyright © 2017 Brian Crowley. All rights reserved.
//

import UIKit

enum AvatarType {
    case dark, light
}

class AvatarCell: UICollectionViewCell {
    
    @IBOutlet weak var cellImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setUpView()
    }
    
    func configureCell (index: Int, type: AvatarType) {
        cellImage.image = UIImage(named: type == .dark ? "dark\(index)" : "light\(index)")
        layer.backgroundColor = type == .dark ? UIColor.lightGray.cgColor : UIColor.darkGray.cgColor
    }
    
    func setUpView() {
        layer.backgroundColor = UIColor.lightGray.cgColor
        layer.cornerRadius = 10
        cellImage.clipsToBounds = true
    }
}
