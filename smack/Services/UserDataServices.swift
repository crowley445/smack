//
//  UserDataServices.swift
//  smack
//
//  Created by Brian  Crowley on 20/11/2017.
//  Copyright © 2017 Brian Crowley. All rights reserved.
//

import Foundation

class UserDataServices {
    
    static let instance = UserDataServices()
    
    public private(set) var id = ""
    public private(set) var avatarName = ""
    public private(set) var avatarColor = ""
    public private(set) var name = ""
    public private(set) var email = ""

    func setUserData(id: String, avatarName: String, avatarColor: String, name: String, email: String) {
        
        self.id = id
        self.avatarName = avatarName
        self.avatarColor = avatarColor
        self.name = name
        self.email = email
        
    }
    
    func setAvatarName(avatarName: String) {
        self.avatarName = avatarName
    }
}
