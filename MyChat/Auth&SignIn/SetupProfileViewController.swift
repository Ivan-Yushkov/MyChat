//
//  SetupProfileViewController.swift
//  MyChat
//
//  Created by Иван Юшков on 23.01.2021.
//

import UIKit
import Firebase
import SDWebImage

class SetupProfileViewController: UIViewController {

    let fillImageView = AddPhotoView()
    
    let welcomeLabel = UILabel(text: "Set up profile!", font: .avenir26())
   
    let fullNamelLabel = UILabel(text: "Full name")
    let aboutMeLabel = UILabel(text: "About me")
    let sexLabel = UILabel(text: "Sex")
    
    let fullNameTextField = OneLineTextField(font: .avenir20())
    let aboutMeTextField = OneLineTextField(font: .avenir20())
    
    var currentUser: User
    
    let sexSegmentedControl = UISegmentedControl(first: "Male", second: "Female")
    
    let goToChatsButton = UIButton(title: "Go to chats!", titleColor: .white, backgroundColor: .blackForButton)
  
    init(currentUser: User) {
        self.currentUser = currentUser
        super.init(nibName: nil, bundle: nil)
        if let username = currentUser.displayName {
            fullNameTextField.text = username
        }
        if let imageUrl = currentUser.photoURL {
            fillImageView.circleImageView.sd_setImage(with: imageUrl, completed: nil)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupConstraints()
        goToChatsButton.addTarget(self, action: #selector(goToChatsButtonTapped), for: .touchUpInside)
        fillImageView.plusButton.addTarget(self, action: #selector(addPhoto), for: .touchUpInside)
    }
    
    @objc func goToChatsButtonTapped() {
        
        guard let email = currentUser.email else { return }
        
        FirestoreService.shared.saveProfileWith(id: currentUser.uid,
                                                email: email,
                                                userName: fullNameTextField.text,
                                                avatarImage: fillImageView.circleImageView.image,
                                                description: aboutMeTextField.text,
                                                sex: sexSegmentedControl.titleForSegment(at: sexSegmentedControl.selectedSegmentIndex)) { (result) in
            switch result {
            
            case .success(let muser):
                self.presentAlert(title: "Hello", message: "Приятного общения") {
                    let mainTBVC = MainTabBarController(currentUser: muser)
                    mainTBVC.modalPresentationStyle = .fullScreen
                    self.present(mainTBVC, animated: true)
                }
            case .failure(let error):
                self.presentAlert(title: "Error", message: error.localizedDescription)
            }
        }
    }

    @objc private func addPhoto() {
         let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.sourceType = .photoLibrary
        present(imagePickerController, animated: true, completion: nil)
    }
}


extension SetupProfileViewController {
    
    private func setupConstraints() {
        
        let fullNameStackView = UIStackView(arrangedSubviews: [
            fullNamelLabel, fullNameTextField],
                                            axis: .vertical,
                                            spacing: 0)
        let aboutMeStackView = UIStackView(arrangedSubviews: [
            aboutMeLabel, aboutMeTextField],
                                           axis: .vertical,
                                           spacing: 0)
        
        let sexStackView = UIStackView(arrangedSubviews: [
            sexLabel, sexSegmentedControl],
                                       axis: .vertical,
                                       spacing: 12)
        let stackView = UIStackView(arrangedSubviews: [
        fullNameStackView, aboutMeStackView, sexStackView, goToChatsButton],
                                    axis: .vertical,
                                    spacing: 40)
        welcomeLabel.translatesAutoresizingMaskIntoConstraints = false
        fillImageView.translatesAutoresizingMaskIntoConstraints = false
        stackView.translatesAutoresizingMaskIntoConstraints = false
        goToChatsButton.translatesAutoresizingMaskIntoConstraints = false
        
        goToChatsButton.heightAnchor.constraint(equalToConstant: 60).isActive = true
        view.addSubview(fillImageView)
        view.addSubview(stackView)
        view.addSubview(welcomeLabel)
        fillImageView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            welcomeLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 160),
            welcomeLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
            ])
        
        NSLayoutConstraint.activate([
            fillImageView.topAnchor.constraint(equalTo: welcomeLabel.topAnchor, constant: 40),
            fillImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: fillImageView.bottomAnchor, constant: 40),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40)
        ])
        
    }
}


extension SetupProfileViewController: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else { return }
        fillImageView.circleImageView.image = image
        
        picker.dismiss(animated: true, completion: nil)
    }
}

//MARK: - SwiftUI
import SwiftUI

struct SetupProfileVCProvider: PreviewProvider {
    static var previews: some View {
        ConteinerView().edgesIgnoringSafeArea(.all)
    }
    
    struct ConteinerView: UIViewControllerRepresentable {
        
        let viewController = SetupProfileViewController(currentUser: Auth.auth().currentUser!)
        
        func makeUIViewController(context: Context) -> some UIViewController {
            return viewController
        }
        
        func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
            
        }
    }
}
