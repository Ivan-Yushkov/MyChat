//
//  AuthNavigationDelegate.swift
//  MyChat
//
//  Created by Иван Юшков on 25.02.2021.
//

import Foundation

protocol AuthNavigationDelegate: class {
    func toLoginVC()
    func toSignUpVC()
}
