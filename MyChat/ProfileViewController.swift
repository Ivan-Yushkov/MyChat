//
//  ProfileViewController.swift
//  MyChat
//
//  Created by Иван Юшков on 26.01.2021.
//

import UIKit
import SDWebImage

class ProfileViewController: UIViewController {

    let containerView = UIView()
    let imageView = UIImageView(image: nil, contentMode: .scaleAspectFill)
    let nameLabel = UILabel(text: "Ivan", font: .systemFont(ofSize: 20, weight: .light))
    let descriptionLabel = UILabel(text: "Hello, please talk to me, my friend. I will be your best friend in the world", font: .systemFont(ofSize: 16, weight: .light))
    let myTextField = InsertableTextField()
    private let user: MUser
    
    init(user: MUser = MUser(username: "", email: "", description: "", sex: "", avatarStringURL: "", id: "")) {
        self.user = user
        nameLabel.text = user.username
        descriptionLabel.text = user.description
        if let avatarStringURL = user.avatarStringURL, let url = URL(string: avatarStringURL) {
            imageView.sd_setImage(with: url, completed: nil)
        }
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        customizeViews()
        setupConstraits()
    }
    
    private func customizeViews() {
        containerView.translatesAutoresizingMaskIntoConstraints = false
        imageView.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        myTextField.translatesAutoresizingMaskIntoConstraints = false
        
        containerView.backgroundColor = .mainWhite
        descriptionLabel.numberOfLines = 0
        containerView.layer.cornerRadius = 30
        myTextField.borderStyle = .roundedRect
        
        if let button = myTextField.rightView as? UIButton {
            button.addTarget(self, action: #selector(sendMessage), for: .touchUpInside)
        }
    }
    
    @objc func sendMessage() {
        guard let message = myTextField.text else { return }
        dismiss(animated: true) {
            FirestoreService.shared.createWaitigChat(message: message, reciever: self.user) { (result) in
                switch result {
                case .success():
                    UIApplication.getTopViewController()?.presentAlert(title: "Success!", message: "Your message to \(self.user.username) has been sent.")
                case .failure(let error):
                    UIApplication.getTopViewController()?.presentAlert(title: "Error!", message: error.localizedDescription)
                }
            }
        }
    }
    
    private func setupConstraits() {
        view.addSubview(imageView)
        view.addSubview(containerView)
        containerView.addSubview(nameLabel)
        containerView.addSubview(descriptionLabel)
        containerView.addSubview(myTextField)
        
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
            myTextField.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 8),
            myTextField.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 24),
            myTextField.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -24),
            myTextField.heightAnchor.constraint(equalToConstant: 48)
        ])
        
    }

}


//MARK: - SwiftUI
import SwiftUI

struct ProfileVCProvider: PreviewProvider {
    static var previews: some View {
        ConteinerView().edgesIgnoringSafeArea(.all)
    }
    
    struct ConteinerView: UIViewControllerRepresentable {
        
        let viewController = ProfileViewController()
        
        func makeUIViewController(context: Context) -> some UIViewController {
            return viewController
        }
        
        func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
            
        }
    }
}
