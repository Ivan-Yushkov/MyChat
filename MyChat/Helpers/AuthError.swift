//
//  AuthError.swift
//  MyChat
//
//  Created by Иван Юшков on 25.02.2021.
//

import Foundation

enum AuthError {
    case notFilled
    case invalidEmail
    case passwordsNotMatched
    case unknownError
    case serverError
}

extension AuthError: LocalizedError {
    var errorDescription: String? {
        switch self {
        
        case .notFilled:
            return NSLocalizedString("Fill all fields", comment: "")
        case .invalidEmail:
            return NSLocalizedString("Email's format does not confirm", comment: "")
        case .passwordsNotMatched:
            return NSLocalizedString("Passwords does not match", comment: "")
        case .unknownError:
            return NSLocalizedString("Uknown error", comment: "")
        case .serverError:
            return NSLocalizedString("Server error", comment: "")
        }
    }
}
