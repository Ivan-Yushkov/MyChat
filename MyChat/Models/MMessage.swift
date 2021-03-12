//
//  MMessage.swift
//  MyChat
//
//  Created by Иван Юшков on 11.03.2021.
//

import UIKit
import FirebaseFirestore

struct MMessage: Hashable {
    let content: String
    let senderId: String
    let senderUsername: String
    let sentDate: Date
    let id: String?
    
    var representation: [String: Any] {
        var rep: [String: Any] = [
            "created": sentDate,
            "senderId": senderId,
            "senderName": senderUsername,
            "content": content
        ]
        return rep
    }
    
    init?(document: QueryDocumentSnapshot) {
        let data = document.data()
        guard let sendDate = data["created"] as? Timestamp,
              let content = data["content"] as? String,
              let senderId = data["senderId"] as? String,
              let senderName = data["senderName"] as? String
        else { return nil }
        self.content = content
        self.senderId = senderId
        senderUsername = senderName
        sentDate = sendDate.dateValue()
        id = document.documentID
    }
    
    init(user: MUser, content: String) {
        self.content = content
        senderUsername = user.username
        senderId = user.id
        sentDate = Date()
        id = nil
    }
}
