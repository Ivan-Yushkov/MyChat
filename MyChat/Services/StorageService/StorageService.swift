//
//  StorageService.swift
//  MyChat
//
//  Created by Иван Юшков on 03.03.2021.
//

import UIKit
import FirebaseStorage
import FirebaseAuth

class StorageService {
    
    static let shared = StorageService()
     
    let storageRef = Storage.storage().reference()
    
    private var avatarsRef: StorageReference {
        return storageRef.child("avatars")
    }
    
    private var currentUserId: String {
        return Auth.auth().currentUser!.uid
    }
    
    func upload(photo: UIImage, completion: @escaping (Result<URL, Error>) -> Void) {
        
        guard let scaledImage = photo.scaledToSafeUploadSize,
              let imageData = scaledImage.jpegData(compressionQuality: 0.4) else { return }
        
        let metadata = StorageMetadata()
        metadata.contentType = "image/jpeg"
        
        avatarsRef.child(currentUserId).putData(imageData, metadata: metadata) { (metadata, error) in
            if let error = error {
                completion(.failure(error))
            }
            
            self.avatarsRef.child(self.currentUserId).downloadURL { (url, error) in
                if let error = error {
                    completion(.failure(error))
                }
                if let url = url {
                    completion(.success(url))
                }
            }
        }
    }
}
