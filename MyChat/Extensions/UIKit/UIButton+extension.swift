//
//  File.swift
//  MyChat
//
//  Created by Иван Юшков on 23.01.2021.
//

import Foundation
import UIKit

extension UIButton {
    
    convenience init(title: String,
                     titleColor: UIColor,
                     font: UIFont? = .avenir20(),
                     backgroundColor: UIColor,
                     isShadow: Bool = false,
                     cornerRadius: CGFloat = 4) {
        self.init(type: .system)
        
        setTitle(title, for: .normal)
        setTitleColor(titleColor, for: .normal)
        self.backgroundColor = backgroundColor
        titleLabel?.font = font
        layer.cornerRadius = cornerRadius
        
        if isShadow {
            layer.shadowColor = UIColor.black.cgColor
            layer.shadowRadius = 4
            layer.shadowOpacity = 0.2
            layer.shadowOffset = CGSize(width: 0, height: 4)
        }
    }
    
    func customizedGoogleButton() {
        let iv = UIImageView(image: #imageLiteral(resourceName: "googleLogo"), contentMode: .scaleAspectFit)
        iv.translatesAutoresizingMaskIntoConstraints = false
        addSubview(iv)
        
        NSLayoutConstraint.activate([
            iv.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 24),
            iv.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
}
