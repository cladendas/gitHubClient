//
//  Repository.swift
//  networking
//
//  Created by cladendas on 03.03.2021.
//

import Foundation


struct Repository {
    private(set) var name: String
    private(set) var description: String
    private(set) var login: String
    private(set) var avatar_url: String
    private(set) var html_url: String
    
    
    
    init? (json:  Dictionary<String, Any>) {
        guard
            let name = json["name"] as? String,
            let owner = json["owner"] as? Dictionary<String, Any>,
            let login = owner["login"] as? String,
            let avatar_url = owner["avatar_url"] as? String,
            let html_url = json["html_url"] as? String
            
        else { return nil }
        
        self.name = name
        //по JSON данный ключ может иметь значение nil (в JSON null)
        self.description = json["description"] as? String ?? ""
        self.login = login
        self.avatar_url = avatar_url
        self.html_url = html_url
    }
}
