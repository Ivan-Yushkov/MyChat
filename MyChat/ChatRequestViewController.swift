//
//  ChatRequestViewController.swift
//  MyChat
//
//  Created by Иван Юшков on 28.01.2021.
//

import UIKit

class ChatRequestViewController: UIViewController {
    
    let containerView = UIView()
    let imageView = UIImageView(image: #imageLiteral(resourceName: "human4"), contentMode: .scaleAspectFill)
    let nameLabel = UILabel(text: "Ivan Yushkov", font: .systemFont(ofSize: 20, weight: .light))
    let descriptionLabel = UILabel(text: "HYou have great opportunity to start a new chat", font: .systemFont(ofSize: 16, weight: .light))
    let acceptButton = UIButton(title: "ACCEPT", titleColor: .white, font: .laoSangamMN20(), backgroundColor: .black, isShadow: false, cornerRadius: 10)
    let denytButton = UIButton(title: "Deny", titleColor: #colorLiteral(red: 0.8365439773, green: 0.19984743, blue: 0.1978578269, alpha: 1), font: .laoSangamMN20(), backgroundColor: .mainWhite, isShadow: false, cornerRadius: 10)
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        customizeViews()
        setupConstraints()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        acceptButton.applyGradients(cornerRadius: 10)
    }
    
    private func customizeViews() {
        containerView.translatesAutoresizingMaskIntoConstraints = false
        imageView.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        containerView.backgroundColor = .mainWhite
        descriptionLabel.numberOfLines = 0
        containerView.layer.cornerRadius = 30
        denytButton.layer.borderWidth = 1.2
        denytButton.layer.borderColor = #colorLiteral(red: 0.8352941176, green: 0.19984743, blue: 0.1978578269, alpha: 1)
    }
}

extension ChatRequestViewController {
    
    private func setupConstraints() {
        let stackView = UIStackView(arrangedSubviews: [acceptButton, denytButton], axis: .horizontal, spacing: 7)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.distribution = .fillEqually
        
        view.addSubview(imageView)
        view.addSubview(containerView)
        containerView.addSubview(nameLabel)
        containerView.addSubview(descriptionLabel)
        containerView.addSubview(stackView)

        
        
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: view.topAnchor),
            imageView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: 30),
            imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        
        NSLayoutConstraint.activate([
            containerView.heightAnchor.constraint(equalToConstant: 206),
            containerView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            containerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        
        NSLayoutConstraint.activate([
            nameLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 35),
            nameLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 24),
            nameLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -24)
        ])
        
        NSLayoutConstraint.activate([
            descriptionLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 8),
            descriptionLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 24),
            descriptionLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -24)
        ])
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 24),
            stackView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 24),
            stackView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -24),
            stackView.heightAnchor.constraint(equalToConstant: 56)
        ])
    }
}

//MARK: - SwiftUI
import SwiftUI

struct ChatRequestVCProvider: PreviewProvider {
    static var previews: some View {
        ConteinerView().edgesIgnoringSafeArea(.all)
    }
    
    struct ConteinerView: UIViewControllerRepresentable {
        
        let viewController = ChatRequestViewController()
        
        func makeUIViewController(context: Context) -> some UIViewController {
            return viewController
        }
        
        func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
            
        }
    }
}
