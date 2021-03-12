//
//  LoginViewController.swift
//  MyChat
//
//  Created by Иван Юшков on 23.01.2021.
//

import UIKit
import GoogleSignIn

class LoginViewController: UIViewController {

    let welcomeLabel = UILabel(text: "Welcome back!", font: .avenir26())
   
    let loginWithlLabel = UILabel(text: "Login with")
    let orLabel = UILabel(text: "or")
    let emailLabel = UILabel(text: "Email")
    let passwordLabel = UILabel(text: "Password")
    let needAnAccountLabel = UILabel(text: "Need an account?")
    
    var delegate: AuthNavigationDelegate?
    
    let googleButton = UIButton(title: "Google", titleColor: .black, backgroundColor: .white, isShadow: true)
    let emailTextField = OneLineTextField(font: .avenir20())
    let passwordTextField = OneLineTextField(font: .avenir20())
    
    let loginButton = UIButton(title: "Login", titleColor: .white, backgroundColor: .blackForButton, isShadow: true)
    let signUpButton: UIButton = {
        let button = UIButton()
        button.setTitle("Sign Up", for: .normal)
        button.setTitleColor(.redForButton, for: .normal)
        button.titleLabel?.font = .avenir20()
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        googleButton.customizedGoogleButton()
        setupConstraints()
        loginButton.addTarget(self, action: #selector(loginButtonTapped), for: .touchUpInside)
        signUpButton.addTarget(self, action: #selector(signUpButtonTapped), for: .touchUpInside)
        googleButton.addTarget(self, action: #selector(googleLoginButtonTapped), for: .touchUpInside)
    }
    
    @objc private func loginButtonTapped() {
        AuthService.shared.login(email: emailTextField.text, password: passwordTextField.text) { (result) in
            switch result {
            
            case .success(let user):
                self.presentAlert(title: "Success", message: "You logined") {
                    FirestoreService.shared.getUserData(user: user) { (result) in
                        switch result {
                        
                        case .success(let muser):
                            let mainTBVC = MainTabBarController(currentUser: muser)
                            mainTBVC.modalPresentationStyle = .fullScreen
                            self.present(mainTBVC, animated: true)
                        case .failure(let error):
                            self.present(SetupProfileViewController(currentUser: user), animated: true)
                        }
                    }
                }
            case .failure(let error):
                self.presentAlert(title: "Error", message: error.localizedDescription)
            }
            
        }
    }
    
    @objc func signUpButtonTapped() {
        dismiss(animated: true) {
            self.delegate?.toSignUpVC()
            print("hello")
        }
        
    }
    
    @objc private func googleLoginButtonTapped() {
        print(#function)
        GIDSignIn.sharedInstance()?.presentingViewController = self
        GIDSignIn.sharedInstance()?.signIn()
    }
    
}
//MARK: - setup constraints
extension LoginViewController {
    
    private func setupConstraints() {
        let loginView = ButtonFromView(label: loginWithlLabel, button: googleButton)
        let emailStackView = UIStackView(arrangedSubviews: [
                                            emailLabel,
                                            emailTextField],
                                         axis: .vertical,
                                         spacing: 0)
        let passwordStackView = UIStackView(arrangedSubviews: [
                                                passwordLabel,
                                                passwordTextField],
                                            axis: .vertical,
                                            spacing: 0)
        
        loginButton.heightAnchor.constraint(equalToConstant: 60).isActive = true
        
        let stackView = UIStackView(arrangedSubviews: [
                                        loginView,
                                        orLabel,
                                        emailStackView,
                                        passwordStackView,
                                        loginButton],
                                    axis: .vertical,
                                    spacing: 40)
        signUpButton.contentHorizontalAlignment = .leading
        
        let bottomStackView = UIStackView(arrangedSubviews: [
                                            needAnAccountLabel,
                                            signUpButton],
                                          axis: .horizontal,
                                          spacing: 10)
        
        bottomStackView.alignment = .firstBaseline
        
        welcomeLabel.translatesAutoresizingMaskIntoConstraints = false
        stackView.translatesAutoresizingMaskIntoConstraints = false
        bottomStackView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(welcomeLabel)
        view.addSubview(stackView)
        view.addSubview(bottomStackView)
        
        NSLayoutConstraint.activate([
            welcomeLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 60),
            welcomeLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: welcomeLabel.bottomAnchor, constant: 100),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40)
        ])
        
        NSLayoutConstraint.activate([
            bottomStackView.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 40),
            bottomStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            bottomStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40)
        ])
        
    }
}

//MARK: - SwiftUI
import SwiftUI

struct LoginVCProvider: PreviewProvider {
    static var previews: some View {
        ConteinerView().edgesIgnoringSafeArea(.all)
    }
    
    struct ConteinerView: UIViewControllerRepresentable {
        
        let viewController = LoginViewController()
        
        func makeUIViewController(context: Context) -> some UIViewController {
            return viewController
        }
        
        func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
            
        }
    }
}
