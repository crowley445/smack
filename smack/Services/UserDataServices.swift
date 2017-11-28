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
    
    func logoutUser () {
        self.id = ""
        self.avatarName = ""
        self.avatarColor = ""
        self.name = ""
        self.email = ""
        AuthServices.instance.userEmail = ""
        AuthServices.instance.authToken = ""
        AuthServices.instance.loggedIn = false
        MessageServices.instance.clearChannels()
        MessageServices.instance.clearMessages()
    }
    
    func setAvatarName(avatarName: String) {
        self.avatarName = avatarName
    }
    
    func returnUIColor (components: String) -> UIColor {
        
        let scanner = Scanner(string: components)
        let skipped = CharacterSet(charactersIn: "[], ")
        let comma = CharacterSet(charactersIn: ",")
        scanner.charactersToBeSkipped = skipped
        
        var r, b, g, a : NSString?
        
        scanner.scanUpToCharacters(from: comma, into: &r)
        scanner.scanUpToCharacters(from: comma, into: &g)
        scanner.scanUpToCharacters(from: comma, into: &b)
        scanner.scanUpToCharacters(from: comma, into: &a)

        let defaultColor = UIColor.lightGray
        
        guard let rUnwrapped = r else {return defaultColor}
        guard let bUnwrapped = b else {return defaultColor}
        guard let gUnwrapped = g else {return defaultColor}
        guard let aUnwrapped = a else {return defaultColor}
        
        let rFloat = CGFloat(rUnwrapped.doubleValue)
        let bFloat = CGFloat(bUnwrapped.doubleValue)
        let gFloat = CGFloat(gUnwrapped.doubleValue)
        let aFloat = CGFloat(aUnwrapped.doubleValue)
        
        
        return UIColor(red: rFloat, green: gFloat, blue: bFloat, alpha: aFloat)
    }
}
