//
//  MChat.swift
//  MyChat
//
//  Created by Иван Юшков on 25.01.2021.
//

import Foundation

struct MChact: Hashable, Decodable {
    var username: String
    var userImageString: String
    var lastMessage: String
    var id: Int
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func == (lhs: MChact, rhs: MChact) -> Bool {
        return lhs.id == rhs.id
    }
}
