//
//  UIView+Extension.swift
//  MyChat
//
//  Created by Иван Юшков on 26.01.2021.
//

import UIKit

extension UIView {
    
    func applyGradients(cornerRadius: CGFloat) {
        backgroundColor = nil
        layoutIfNeeded()
        let gradientView = GradientView(from: .top, to: .bottom, startColor: #colorLiteral(red: 0.7882352941, green: 0.631372549, blue: 1, alpha: 1), endColor: #colorLiteral(red: 0.6745098039, green: 0.6980392157, blue: 0.9215686275, alpha: 1))
        if let gradientLayer = gradientView.layer.sublayers?.first as? CAGradientLayer {
            gradientLayer.frame = bounds
            gradientLayer.cornerRadius = cornerRadius
            layer.insertSublayer(gradientLayer, at: 0)
        }
    }
}
