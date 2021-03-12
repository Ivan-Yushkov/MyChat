//
//  Validators.swift
//  MyChat
//
//  Created by Иван Юшков on 25.02.2021.
//

import Foundation

class Validators {
    
    static func isFilled(email: String?,
                         password: String?,
                         confirmPassword: String?) -> Bool {
        guard let email = email,
              let password = password,
              let confirmPassword = confirmPassword,
              password != "",
              email != "",
              confirmPassword != "" else { return false }
        return true
    }
    
    static func isFilled(userName: String?,
                         description: String?,
                         sex: String?) -> Bool {
        guard let userName = userName,
              let description = description,
              let sex = sex,
              sex != "",
              description != "",
              userName != ""
              else {
            return false
        }
        return true
    }
    
    static func isSimpleEmail(_ email: String) -> Bool {
        let emailRegEx = "^.+@.+\\..{2,}$"
        return check(text: email, regEx: emailRegEx)
    }
    
    private static func check(text: String, regEx: String) -> Bool {
        let predicate = NSPredicate(format: "SELF MATCHES %@", regEx)
        return predicate.evaluate(with: text)
    }
}
