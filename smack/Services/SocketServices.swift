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
    
}
