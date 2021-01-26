//
//  SetupProfileViewController.swift
//  MyChat
//
//  Created by Иван Юшков on 23.01.2021.
//

import UIKit

class SetupProfileViewController: UIViewController {

    let fillImageView = AddPhotoView()
    
    let welcomeLabel = UILabel(text: "Set up profile!", font: .avenir26())
   
    let fullNamelLabel = UILabel(text: "Full name")
    let aboutMeLabel = UILabel(text: "About me")
    let sexLabel = UILabel(text: "Sex")
    
    let fullNameTextField = OneLineTextField(font: .avenir20())
    let aboutMeTextField = OneLineTextField(font: .avenir20())
    
    let sexSegmentedControl = UISegmentedControl(first: "Male", second: "Female")
    
    let goToChatsButton = UIButton(title: "Go to chats!", titleColor: .white, backgroundColor: .blackForButton)
  
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupConstraints()
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


//MARK: - SwiftUI
import SwiftUI

struct SetupProfileVCProvider: PreviewProvider {
    static var previews: some View {
        ConteinerView().edgesIgnoringSafeArea(.all)
    }
    
    struct ConteinerView: UIViewControllerRepresentable {
        
        let viewController = SetupProfileViewController()
        
        func makeUIViewController(context: Context) -> some UIViewController {
            return viewController
        }
        
        func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
            
        }
    }
}
