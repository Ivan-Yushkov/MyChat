//
//  FirestoreService.swift
//  MyChat
//
//  Created by Иван Юшков on 25.02.2021.
//

import Firebase
import FirebaseFirestore

class FirestoreService {
    
    static let shared = FirestoreService()
    
    let db = Firestore.firestore()
    
    private var usersRef: CollectionReference {
        return db.collection("users")
    }
    
    private var currentUser: MUser!
    
    private var waitingChatsReference: CollectionReference {
       return db.collection(["users", currentUser.id, "waitingChats"].joined(separator: "/"))
    }
    
    public func getUserData(user: User, completion: @escaping (Result<MUser, Error>) -> Void) {
        let docRef = usersRef.document(user.uid)
        docRef.getDocument { (document, error) in
            if let document = document, document.exists {
                guard let muser = MUser(document: document) else {
                    completion(.failure(UserError.cannotUnwrapMuser))
                    return
                }
                self.currentUser = muser
                completion(.success(muser))
            } else {
                completion(.failure(UserError.cannotGetUserInfo))
            }
        }
    }
     
    public func saveProfileWith(id: String,
                                email: String,
                                userName: String?,
                                avatarImage: UIImage?,
                                description: String?,
                                sex: String?,
                                completion: @escaping (Result<MUser, Error>) -> Void) {
        guard Validators.isFilled(userName: userName, description: description, sex: sex) else {
            completion(.failure(UserError.notFilled))
            return
        }
        
        guard avatarImage != #imageLiteral(resourceName: "avatar") else {
            completion(.failure(UserError.photoNotExist))
            return
        }
        
        var muser = MUser(username: userName!, email: email, description: description, sex: sex, avatarStringURL: "not exist", id: id)
        
        StorageService.shared.upload(photo: avatarImage!) { (result) in
            switch result {
            case .success(let url):
                muser.avatarStringURL = url.absoluteString
                self.usersRef.document(muser.id).setData(muser.representation) { (error) in
                    if let error = error {
                        completion(.failure(error))
                    } else {
                        completion(.success(muser))
                    }
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func createWaitigChat(message: String, reciever: MUser, completion: @escaping (Result<Void, Error>) -> Void) {
        let reference = db.collection(["users", reciever.id, "waitingChats"].joined(separator: "/"))
        let messagesRef = reference.document(currentUser.id).collection("messages")
        
        let mmessage = MMessage(user: currentUser, content: message)
        let chat = MChat(friendUsername: currentUser.username,
                          friendImageUrlString: currentUser.avatarStringURL ?? "",
                          lastMessageContent: mmessage.content,
                          friendId: currentUser.id)
        reference.document(currentUser.id).setData(chat.representation) { (error) in
            if let error = error {
                completion(.failure(error))
                return
            }
            messagesRef.addDocument(data: mmessage.representation) { error in
                if let error = error {
                    completion(.failure(error))
                    return
                }
                completion(.success(Void()))
            }
        }
    }
    
    func deleteWaitingChat(friendId: String, completion: @escaping (Result<Void, Error>) -> Void) {
        waitingChatsReference.document(friendId).delete { (error) in
            if let error = error {
                completion(.failure(error))
                return
            }
            completion(.success(Void()))
            self.deleteMessages(friendId: friendId, completion: completion)
        }
    }
    
    private func deleteMessages(friendId: String, completion: @escaping (Result<Void, Error>) -> Void) {
        let reference = waitingChatsReference.document(friendId).collection("messages")
        getWaitingChatMessages(friendId: friendId) { (result) in
            switch result {
            case .success(let messages):
                for message in messages {
                    guard let documentId = message.id else { return }
                    let messageRef = reference.document(documentId)
                    messageRef.delete { (error) in
                        if let error = error {
                            completion(.failure(error))
                            return
                        }
                        completion(.success(Void()))
                    }
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    private func getWaitingChatMessages(friendId: String, completion: @escaping (Result<[MMessage], Error>) -> Void) {
        let reference = waitingChatsReference.document(friendId).collection("messages")
        reference.getDocuments { (querySnapshot, error) in
            var messages = [MMessage]()
            if let error = error {
                completion(.failure(error))
                return
            }
            guard let snapshot = querySnapshot else { return }
            for document in snapshot.documents {
                guard let message = MMessage(document: document) else { return }
                messages.append(message)
            }
            completion(.success(messages))
        }
    }
}
