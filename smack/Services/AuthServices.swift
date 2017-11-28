//
//  AuthServices.swift
//  smack
//
//  Created by Brian  Crowley on 19/11/2017.
//  Copyright © 2017 Brian Crowley. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class AuthServices {
    
    static let instance = AuthServices()
    
    let defaults = UserDefaults.standard
    
    var loggedIn : Bool {
        get {
            return defaults.bool(forKey: LOGGED_IN_KEY)
        }
        set {
            defaults.set(newValue, forKey: LOGGED_IN_KEY)
        }
    }
    
    var authToken : String {
        get {
            return defaults.value(forKey: TOKEN_KEY) as! String
        }
        set{
            defaults.set(newValue, forKey: TOKEN_KEY)
        }
    }
    
    var userEmail : String {
        get {
            return defaults.value(forKey: USER_EMAIL) as! String
        }
        set {
            defaults.set(newValue, forKey: USER_EMAIL)
        }
    }
    
    func registerUser(email : String, password: String, completion: @escaping CompletionHandler) {

        let lowercaseEmail = email.lowercased()
        
        let body = [
            "email": lowercaseEmail,
            "password": password
        ]
        
        Alamofire.request(URL_REGISTER, method: .post, parameters: body, encoding: JSONEncoding.default, headers: HEADER).responseString { (response) in
            if response.result.error == nil {
                completion(true)
            } else {
                completion(false)
                debugPrint(response.result.error as Any)
            }
        }
    }
    
    func loginUser(email: String, password: String, completion: @escaping CompletionHandler) {
        
        let lowercaseEmail = email.lowercased()
        
        let body = [
            "email" : lowercaseEmail,
            "password": password
        ]
        
        Alamofire.request(URL_LOGIN, method: .post, parameters: body, encoding: JSONEncoding.default, headers: HEADER).response { (response) in
            
            if response.error == nil {

                guard let data = response.data else {return}
                
                do {
                    let json = try JSON(data: data)
                    self.userEmail = json["user"].stringValue
                    self.authToken = json["token"].stringValue
                    self.loggedIn = true
                } catch {
                    debugPrint("failed to parse login response")
                }

                completion(true)
                
            } else {
                completion(false)
                debugPrint(response.error as Any)
            }
        }
    }
    
    func createUser(name: String, email: String, avatarName: String, avatarColor: String, completion: @escaping CompletionHandler) {
        
        let lowercaseEmail = email.lowercased()
        
        let body = [
            "name": name,
            "email": lowercaseEmail,
            "avatarName": avatarName,
            "avatarColor": avatarColor
        ]
        
        Alamofire.request(URL_USER_ADD, method: .post, parameters: body, encoding: JSONEncoding.default, headers: BEARER_HEADER).responseJSON { (response) in
            
            if response.error == nil {
                
                guard let data = response.data else { return }
                self.setUserInfo(withJSONData: data)
                completion(true)
                                
            } else {
                completion(false)
                debugPrint(response.error as Any)
            }
        }
    }
    
    func findUserByEmail(completion: @escaping CompletionHandler) {
        
        Alamofire.request("\(URL_USER_BY_EMAIL)\(self.userEmail)", method: .get, parameters: nil, encoding: JSONEncoding.default, headers: BEARER_HEADER).responseJSON { (response) in
            
            if(response.error == nil) {
                
                guard let data = response.data else { return }
                self.setUserInfo(withJSONData: data)
                completion(true)
                
            } else {
                debugPrint(response.error as Any)
                completion(false)
            }
        }
    }
    
    func setUserInfo(withJSONData data: Data) {
        
        do {
            let json = try JSON(data: data)
            
            let id = json["_id"].stringValue
            let avatarName = json["avatarName"].stringValue
            let avatarColor = json["avatarColor"].stringValue
            let name = json["name"].stringValue
            let email = json["email"].stringValue
            
            UserDataServices.instance.setUserData(id: id, avatarName: avatarName, avatarColor: avatarColor, name: name, email: email)
        } catch {
            print("failed to parse add user response in AuthServices")
        }
    }
}