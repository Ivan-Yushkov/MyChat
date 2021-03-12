//
//  MChat.swift
//  MyChat
//
//  Created by Иван Юшков on 25.01.2021.
//

import Foundation
import FirebaseFirestore

struct MChat: Hashable, Decodable {
    var friendUsername: String
    var friendImageUrlString: String
    var lastMessageContent: String
    var friendId: String
    
    var representation: [String: Any] {
        var rep: [String: Any] = ["friendUsername": friendUsername]
        rep["friendImageUrlString"] = friendImageUrlString
        rep["lastMessage"] = lastMessageContent
        rep["friendId"] = friendId
        return rep
    }
    
    init?(document: QueryDocumentSnapshot) {
        let data = document.data()
        guard let friendUsername = data["friendUsername"] as? String,
              let friendImageUrlString = data["friendImageUrlString"] as? String,
              let lastMessage = data["lastMessage"] as? String,
              let friendId = data["friendId"] as? String
        else { return nil }
        self.friendUsername = friendUsername
        self.friendImageUrlString = friendImageUrlString
        lastMessageContent = lastMessage
        self.friendId = friendId
    }
    
    init(friendUsername: String, friendImageUrlString: String, lastMessageContent: String, friendId: String) {
        self.friendUsername = friendUsername
        self.friendImageUrlString = friendImageUrlString
        self.lastMessageContent = lastMessageContent
        self.friendId = friendId
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(friendId)
    }
    
    static func == (lhs: MChat, rhs: MChat) -> Bool {
        return lhs.friendId == rhs.friendId
    }
}
