//
//  ActiveChatCell.swift
//  MyChat
//
//  Created by Иван Юшков on 24.01.2021.
//

import UIKit




class ActiveClassCell: UICollectionViewCell, SelfConfiguringCell {
    static var reuseID = "ActiveChatCell"
    
    let friendImageView = UIImageView()
    let friendNameLabel = UILabel(text: "User name", font: .laoSangamMN20())
    let lastMessageLabel = UILabel(text: "How are you", font: .laoSangamMN18())
    let gradientView = GradientView(from: .topTrailing, to: .bottomLeading, startColor: #colorLiteral(red: 0.7882352941, green: 0.631372549, blue: 1, alpha: 1), endColor: #colorLiteral(red: 0.6745098039, green: 0.6980392157, blue: 0.9215686275, alpha: 1))
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .mainWhite
        layer.cornerRadius = 4
        clipsToBounds = true
        setupConstraints()
    }
    
    func configure<U>(value: U) {
        guard let value = value as? MChact,
        let image = UIImage(named: value.userImageString) else { return }
        friendImageView.image = image
        friendNameLabel.text = value.username
        lastMessageLabel.text = value.lastMessage
    }
    
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}


//MARK: - methods for setup view
extension ActiveClassCell {
    
    private func setupConstraints() {
        addSubview(friendImageView)
        addSubview(friendNameLabel)
        addSubview(lastMessageLabel)
        addSubview(gradientView)
        
        friendImageView.translatesAutoresizingMaskIntoConstraints = false
        friendImageView.backgroundColor = .red
        gradientView.translatesAutoresizingMaskIntoConstraints = false
        lastMessageLabel.translatesAutoresizingMaskIntoConstraints = false
        friendNameLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            friendImageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            friendImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            friendImageView.widthAnchor.constraint(equalToConstant: 78),
            friendImageView.heightAnchor.constraint(equalToConstant: 78)
        ])
        
        NSLayoutConstraint.activate([
            gradientView.trailingAnchor.constraint(equalTo: trailingAnchor),
            gradientView.centerYAnchor.constraint(equalTo: centerYAnchor),
            gradientView.widthAnchor.constraint(equalToConstant: 8),
            gradientView.heightAnchor.constraint(equalToConstant: 78)
        ])
        
        NSLayoutConstraint.activate([
            friendNameLabel.topAnchor.constraint(equalTo: topAnchor, constant: 12),
            friendNameLabel.leadingAnchor.constraint(equalTo: friendImageView.trailingAnchor, constant: 16),
            friendNameLabel.trailingAnchor.constraint(equalTo: gradientView.leadingAnchor, constant: 16)
        ])
        
        NSLayoutConstraint.activate([
            lastMessageLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -14),
            lastMessageLabel.leadingAnchor.constraint(equalTo: friendImageView.trailingAnchor, constant: 16),
            lastMessageLabel.trailingAnchor.constraint(equalTo: gradientView.leadingAnchor, constant: 16)
        ])
    }
}

//MARK: - SwiftUI
import SwiftUI

struct ActiveChatCellProvider: PreviewProvider {
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
