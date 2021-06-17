//
//  User.swift
//  gitHubClient
//
//  Created by cladendas on 14.06.2021.
//

import Foundation

struct User: Codable {
    
    private(set) var userName: String
    private(set) var avatarURL: String

    init? (json:  Dictionary<String, Any>) {
        guard
            let userName = json["login"] as? String,
            let avatarURL = json["avatar_url"] as? String
        else { return nil }
        
        self.userName = userName
        self.avatarURL = avatarURL
    }

}
