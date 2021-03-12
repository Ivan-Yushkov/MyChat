//
//  UserError.swift
//  MyChat
//
//  Created by Иван Юшков on 25.02.2021.
//

import Foundation

enum UserError {
    case notFilled
    case photoNotExist
    case cannotUnwrapMuser
    case cannotGetUserInfo
}

extension UserError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .notFilled:
            return NSLocalizedString("Please fill all fields", comment: "")
        case .photoNotExist:
            return NSLocalizedString("Photo don't exist", comment: "")
        case .cannotUnwrapMuser:
            return NSLocalizedString("Cannot get unwraped data to Muser", comment: "")
        case .cannotGetUserInfo:
            return NSLocalizedString("User data not exist or not fill at all", comment: "")
        }
    }
}
