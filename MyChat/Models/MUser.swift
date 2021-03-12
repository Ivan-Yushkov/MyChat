//
//  User.swift
//  MyChat
//
//  Created by Иван Юшков on 25.01.2021.
//

import Foundation
import FirebaseFirestore

struct MUser: Hashable, Decodable {
    var username: String
    var email: String?
    var description: String?
    var sex: String?
    var avatarStringURL: String?
    var id: String
    
    init(username: String, email: String, description: String?, sex: String?, avatarStringURL: String?, id: String) {
        self.username = username
        self.email = email
        self.description = description
        self.sex = sex
        self.avatarStringURL = avatarStringURL
        self.id = id
    }
    
    init?(document: DocumentSnapshot) {
        guard let data = document.data() else { return nil }
        guard let username = data["username"] as? String,
              let email = data["email"] as? String,
              let avatarStringURL = data["avatarStringURL"] as? String,
              let description = data["description"] as? String,
              let sex = data["sex"] as? String,
              let id = data["uid"] as? String else { return nil }
        self.username = username
        self.email = email
        self.avatarStringURL = avatarStringURL
        self.description = description
        self.sex = sex
        self.id = id
    }
    
    init?(document: QueryDocumentSnapshot) {
        let data = document.data() 
        guard let username = data["username"] as? String,
              let email = data["email"] as? String,
              let avatarStringURL = data["avatarStringURL"] as? String,
              let description = data["description"] as? String,
              let sex = data["sex"] as? String,
              let id = data["uid"] as? String else { return nil }
        self.username = username
        self.email = email
        self.avatarStringURL = avatarStringURL
        self.description = description
        self.sex = sex
        self.id = id
    }
    
    var representation: [String: Any] {
        var rep = ["username": username]
        rep["description"] = description
        rep["sex"] = sex
        rep["avatarStringURL"] = avatarStringURL
        rep["email"] = email
        rep["uid"] = id
        return rep
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func == (lhs: MUser, rhs: MUser) -> Bool {
        return lhs.id == rhs.id
    }
    
    func isContains(text: String?) -> Bool {
        guard let text = text else { return true }
        if text.isEmpty {
            return true
        }
        let lowercasedText = text.lowercased()
        return username.lowercased().contains(lowercasedText)
    }
    
    
}

