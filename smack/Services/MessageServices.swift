//
//  MessageServices.swift
//  smack
//
//  Created by Brian  Crowley on 25/11/2017.
//  Copyright © 2017 Brian Crowley. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class MessageServices {
    
    static let instance = MessageServices()
    var channels = [Channel]()
    var messages = [Message()]
    var selectedChannel : Channel?
    
    func findAllChannels (completion: @escaping CompletionHandler) {
        
        Alamofire.request(URL_GET_CHANNELS, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: BEARER_HEADER).responseJSON { (response) in
            if response.error == nil {
                guard let data = response.data else { return }
                
                do {
                    let json = try JSON(data: data).array
                    for item in json! {
                        let name = item["name"].stringValue
                        let description = item["description"].stringValue
                        let id = item["_id"].stringValue
                        let channel = Channel(name: name, description: description, id: id)
                        self.channels.append(channel)
                        NotificationCenter.default.post(name: NOTIF_CHANNELS_LOADED, object: nil)
                        completion(true)
                    }
                } catch let error {
                    print(error)
                    completion(false)
                }
                
            }
        }
    }
    
    func findAllMessagesByChannel( id : String, completion: @escaping CompletionHandler ) {
        
        Alamofire.request("\(URL_GET_MESSAGES)\(id)", method: .get, parameters: nil, encoding: JSONEncoding.default, headers: BEARER_HEADER).responseJSON { (response) in
            
            
            if response.result.error == nil {
                self.clearMessages()
                guard let data = response.data else { return }

                do {
                    guard let json = try JSON(data: data).array else { return }
                    
                    for item in json {
                        
                        let messageBody = item["messageBody"].stringValue
                        let channelId = item["channelId"].stringValue
                        let id = item["_id"].stringValue
                        let userName = item["userName"].stringValue
                        let avatarName = item["userAvatar"].stringValue
                        let avatarColor = item["userAvatarColor"].stringValue
                        let timeStamp = item["timeStamp"].stringValue
                        
                        let message = Message(message: messageBody, userName: userName, channelId: channelId, avatarName: avatarName , avatarColor: avatarColor, id: id, timeStamp: timeStamp)
                        self.messages.append(message)
                    }
                    
                    completion(true)
                    
                } catch let error {
                    print("Failed to parse out messages in MessageServices")
                    debugPrint(error)
                }
                
            } else {
                debugPrint(response.result.error as Any)
                completion(false)
            }
        }
    }
    
    func clearMessages() {
        messages.removeAll()
    }
    
    func clearChannels() {
        channels.removeAll()
    }
    
}
