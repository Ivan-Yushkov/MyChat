//
//  WaitingChatsNavigation.swift
//  MyChat
//
//  Created by Иван Юшков on 12.03.2021.
//

import Foundation
 
protocol WaitingChatsNavigation: class {
    func removeWaitingChat(chat: MChat)
    func changeToActive(chat: MChat)
}
