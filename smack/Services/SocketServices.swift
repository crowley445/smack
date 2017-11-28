//
//  SocketServices.swift
//  smack
//
//  Created by Brian  Crowley on 25/11/2017.
//  Copyright © 2017 Brian Crowley. All rights reserved.
//

import UIKit
import SocketIO

class SocketServices: NSObject {

    static let instance = SocketServices()
    var manager : SocketManager?
    var socket : SocketIOClient?
    
    override init() {
        super.init()
        manager = SocketManager(socketURL: URL(string: BASE_URL)!, config: [.log(false), .compress])
        socket = manager?.defaultSocket
    }
    
    func establishConnection () {
        socket?.connect()
    }
    
    func closeConnection () {
        socket?.disconnect()
    }
    
    func addChannel (name: String, description: String, completion: @escaping CompletionHandler) {
        socket?.emit("newChannel", name, description)
        getChannel { (success) in
            debugPrint(MessageServices.instance.channels)
        }
        completion(true)
    }
    
    func getChannel (completion: @escaping CompletionHandler) {
        
        socket?.on("channelCreated") { (dataArray, ack) in
            guard let name = dataArray[0] as? String else { return }
            guard let description = dataArray[1] as? String else { return }
            guard let id = dataArray[2] as? String else { return }
            
            let newChannel = Channel(name: name, description: description, id: id)
            MessageServices.instance.channels.append(newChannel)
            completion(true)
        }
    }

    func addMessage (messageBody: String, userId: String, channelId: String, completion: @escaping CompletionHandler) {
        let user = UserDataServices.instance
        socket?.emit("newMessage", messageBody, userId, channelId, user.name, user.avatarName, user.avatarColor)
        completion(true)
    }
    
    func getChatMessage(completion: @escaping (_ completion: Message) -> Void) {
        socket?.on("messageCreated", callback: { (dataArray, ack) in
            guard let messageBody = dataArray[0] as? String else { return }
            guard let channelId = dataArray[2] as? String else { return }
            guard let username = dataArray[3] as? String else { return }
            guard let avatarName = dataArray[4] as? String else { return }
            guard let avatarColor = dataArray[5] as? String else { return }
            guard let id = dataArray[6] as? String else { return }
            guard let timeStamp = dataArray[7] as? String else { return }

            let newMessage = Message(message: messageBody, userName: username, channelId: channelId, avatarName: avatarName, avatarColor: avatarColor, id: id, timeStamp: timeStamp)
            completion(newMessage)
        })
    }
    
    func getTypingUsers( completion: @escaping (_ typingUsers: [String : String]) -> Void ) {
        socket?.on("userTypingUpdate", callback: { (dataArray, ack) in
            guard let typingUsers = dataArray[0] as? [String : String] else { return }
            completion( typingUsers )
        })
    }
}
