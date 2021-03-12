//
//  ListenerService.swift
//  MyChat
//
//  Created by Иван Юшков on 11.03.2021.
//

import Firebase
import FirebaseAuth
import FirebaseFirestore

class ListenerService {
    
    static let shared = ListenerService()
    
    private let db = Firestore.firestore()
    
    private var userRef: CollectionReference {
        return db.collection("users")
    }
    
    private var waitingChatsRef: CollectionReference {
        return db.collection(["users", currentUserId, "waitingChats"].joined(separator: "/"))
    }
    
    private var currentUserId: String {
        return Auth.auth().currentUser!.uid
    }
    
    public func userObserve(users: [MUser], completion: @escaping (Result<[MUser], Error>) -> Void) -> ListenerRegistration {
        var users = users
        let userListener = userRef.addSnapshotListener { (querySnapshot, error) in
            if let error = error {
                completion(.failure(error))
                
            }
            if let snapshot = querySnapshot {
                snapshot.documentChanges.forEach { (diff) in
                    guard let muser = MUser(document: diff.document) else { return }
                    switch diff.type {
                     
                    case .added:
                        guard !users.contains(muser),
                              muser.id != self.currentUserId  else { return }
                        users.append(muser)
                    case .modified:
                        guard let index = users.firstIndex(of: muser) else { return }
                        users[index] = muser
                    case .removed:
                        guard let index = users.firstIndex(of: muser) else { return }
                        users.remove(at: index)
                    }
                }
                completion(.success(users))
            }
        }
        return userListener
    }
    
    public func waitingChatsObserve(chats: [MChat], completion: @escaping (Result<[MChat], Error>) -> Void) -> ListenerRegistration {
        var chats = chats
        let chatListener = waitingChatsRef.addSnapshotListener { (querySnapshot, error) in
            if let error = error {
                completion(.failure(error))
            }
            
            if let snapshot = querySnapshot {
                snapshot.documentChanges.forEach { (diff) in
                    guard let chat = MChat(document: diff.document) else { return }
                    switch diff.type {
                    
                    case .added:
                        chats.append(chat)
                    case .modified:
                        guard let index = chats.firstIndex(of: chat) else { return }
                        chats[index] = chat
                    case .removed:
                        guard let index = chats.firstIndex(of: chat) else { return }
                        chats.remove(at: index)
                    }
                }
                completion(.success(chats))
            }
        }
        return chatListener
    }
}
