//
//  UserCell.swift
//  MyChat
//
//  Created by Иван Юшков on 26.01.2021.
//

import UIKit

class UserCell: UICollectionViewCell, SelfConfiguringCell {
    

    let userImageView = UIImageView()
    let userNameLabel = UILabel(text: "text", font: .laoSangamMN20())
    let conteinerView = UIView()
    
    static var reuseID = "UserCellId"
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .mainWhite
        setupConstraints()
        layer.cornerRadius = 4
        layer.shadowColor = #colorLiteral(red: 0.7411764706, green: 0.7411764706, blue: 0.7411764706, alpha: 1)
        layer.shadowRadius = 3
        layer.shadowOpacity = 0.5
        layer.shadowOffset = CGSize(width: 0, height: 4)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.layer.cornerRadius = 4
        contentView.clipsToBounds = true
    }
    
    func configure<U>(value: U) {
        guard let user = value as? MUser
              else { fatalError() }
        userNameLabel.text = user.username
        userImageView.image = UIImage(named: user.avatarStringURL)

    }
    
    private func setupConstraints() {
        userImageView.translatesAutoresizingMaskIntoConstraints = false
        userNameLabel.translatesAutoresizingMaskIntoConstraints = false
        conteinerView.translatesAutoresizingMaskIntoConstraints = false
        
        userImageView.backgroundColor = .red
        addSubview(conteinerView)
        conteinerView.addSubview(userImageView)
        conteinerView.addSubview(userNameLabel)
        
        NSLayoutConstraint.activate([
            conteinerView.topAnchor.constraint(equalTo: topAnchor),
            conteinerView.bottomAnchor.constraint(equalTo: bottomAnchor),
            conteinerView.leadingAnchor.constraint(equalTo: leadingAnchor),
            conteinerView.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
        
        NSLayoutConstraint.activate([
            userImageView.topAnchor.constraint(equalTo: conteinerView.topAnchor),
            userImageView.heightAnchor.constraint(equalTo: conteinerView.widthAnchor),
            userImageView.leadingAnchor.constraint(equalTo: conteinerView.leadingAnchor),
            userImageView.trailingAnchor.constraint(equalTo: conteinerView.trailingAnchor)
        ])
        
        NSLayoutConstraint.activate([
            userNameLabel.topAnchor.constraint(equalTo: userImageView.bottomAnchor),
            userNameLabel.bottomAnchor.constraint(equalTo: conteinerView.bottomAnchor),
            userNameLabel.leadingAnchor.constraint(equalTo: conteinerView.leadingAnchor, constant: 8),
            userNameLabel.trailingAnchor.constraint(equalTo: conteinerView.trailingAnchor, constant: -8)
        ])

    }
    
}


//MARK: - SwiftUI
import SwiftUI

struct UserCellProvider: PreviewProvider {
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
