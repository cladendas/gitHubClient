//
//  User.swift
//  gitHubClient
//
//  Created by cladendas on 14.06.2021.
//

import Foundation

struct User: Codable {
    
    var userName: String
    var avatarURL: String

    init? (json:  Dictionary<String, String>) {
        guard
            let userName = json["login"],
            let avatarURL = json["avatar_url"]
        else { return nil }
        
        self.userName = userName
        self.avatarURL = avatarURL
    }

}
