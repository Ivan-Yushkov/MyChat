//
//  WaitingChatCell.swift
//  MyChat
//
//  Created by Иван Юшков on 24.01.2021.
//

import UIKit
import SDWebImage

class WaitingChatCell: UICollectionViewCell, SelfConfiguringCell {
    
    
    static var reuseID = "WaitingChatCell"
   
    let friendImageView = UIImageView()
    
    func configure<U>(value: U) {
        guard let value = value as? MChat else {
            return
        }
        friendImageView.sd_setImage(with: URL(string: value.friendImageUrlString), completed: nil)
    }
    
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        layer.cornerRadius = 4
        clipsToBounds = true
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupConstraints() {
        addSubview(friendImageView)
        friendImageView.frame = bounds
    }
}


//MARK: - SwiftUI
import SwiftUI

struct WaitingChatCellProvider: PreviewProvider {
    static var previews: some View {
        ConteinerView().edgesIgnoringSafeArea(.all)
    }
    
    struct ConteinerView: UIViewControllerRepresentable {
        
        let viewController = MainTabBarController()
        
        func makeUIViewController(context: Context) -> some UIViewController {
            return viewController
        }
        
        func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
            
        }
    }
}
