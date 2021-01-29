//
//  User.swift
//  MyChat
//
//  Created by Иван Юшков on 25.01.2021.
//

import Foundation

struct MUser: Hashable, Decodable {
    var username: String
    var avatarStringURL: String
    var id: Int
    
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

