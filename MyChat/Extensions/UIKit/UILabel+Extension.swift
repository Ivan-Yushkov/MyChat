//
//  UILabel+Extension.swift
//  MyChat
//
//  Created by Иван Юшков on 23.01.2021.
//

import Foundation
import UIKit

extension UILabel {
    
    convenience init(text: String, font: UIFont? = .avenir20()) {
        self.init()
        
        self.text = text
        self.font = font
    }
}
