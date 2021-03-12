//
//  AuthService.swift
//  MyChat
//
//  Created by Иван Юшков on 02.02.2021.
//

import UIKit
import Firebase
import FirebaseAuth
import GoogleSignIn

class AuthService {
    
    static let shared = AuthService()
    private let auth = Auth.auth()
    
    
    public func login(email: String?,
                      password: String?,
                      completion: @escaping (Result<User, Error>) -> Void) {
        guard let email = email,
              let password = password else {
            completion(.failure(AuthError.notFilled))
            return }
        auth.signIn(withEmail: email, password: password) { (result, error) in
            if let error = error {
                completion(.failure(error))
            }
            if let result = result {
                completion(.success(result.user))
            }
        }
    }
    
    public func googleLogin(user: GIDGoogleUser!,
                            error: Error!,
                            completion: @escaping (Result<User, Error>) -> Void) {
        if let error = error {
            completion(.failure(error))
            return
        }
        
        guard let user = user,
              let auth = user.authentication
              else { return }
        
        let credential = GoogleAuthProvider.credential(withIDToken: auth.idToken, accessToken: auth.accessToken)
        Auth.auth().signIn(with: credential) { (result, error) in
            if let error = error {
                completion(.failure(error))
                return
            }
            guard let result = result else { return }
            completion(.success(result.user))
        }
    }
    
    public func register(email: String?,
                         password: String?,
                         confirmPassword: String?,
                         completion: @escaping (Result<User, Error>) -> ()) {
        
        guard Validators.isFilled(email: email, password: password, confirmPassword: confirmPassword) else {
            completion(.failure(AuthError.notFilled))
            return
        }
        guard password?.lowercased() == confirmPassword?.lowercased() else {
            completion(.failure(AuthError.passwordsNotMatched))
            return
        }
        
        guard Validators.isSimpleEmail(email!) else {
            completion(.failure(AuthError.invalidEmail))
            return
        }
        guard let password = password,
              let email = email,
              let confirmPassword = confirmPassword else { return }
        auth.createUser(withEmail: email, password: password) { (result, error ) in
            if let error = error {
                completion(.failure(error))
            }
            if let result = result {
                completion(.success(result.user))
            }
        }
    }
    
}
