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
                        completion(true)
                    }
                } catch let error {
                    print(error)
                    completion(false)
                }
                
            }
        }
    }
    
}
