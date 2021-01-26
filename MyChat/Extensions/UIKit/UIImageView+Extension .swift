//
//  UIImageView+Extension .swift
//  MyChat
//
//  Created by Иван Юшков on 23.01.2021.
//

import Foundation
import UIKit

extension UIImageView {
    convenience init(image: UIImage?, contentMode: UIView.ContentMode) {
        self.init()
        
        self.image = image
        self.contentMode = contentMode
    }
}
