//
//  ViewController.swift
//  MyChat
//
//  Created by Иван Юшков on 23.01.2021.
//

import UIKit
import GoogleSignIn


class AuthViewController: UIViewController {

    let logoImageView = UIImageView(image: #imageLiteral(resourceName: "Logo"), contentMode: .scaleAspectFit)
    
    let googleLabel = UILabel(text: "Get started with")
    let emailLabel = UILabel(text: "Or sign up with")
    let alreadyOnBoardLabel = UILabel(text: "Already onboard?")
    
    let loginVC = LoginViewController()
    let signUpVC = SignUpViewController()
    
    let emailButton = UIButton(title: "Email", titleColor: .white, backgroundColor: .blackForButton)
    let loginButton = UIButton(title: "Login", titleColor: .redForButton, backgroundColor: .white, isShadow: true)
    let googleButton = UIButton(title: "Google", titleColor: .black, backgroundColor: .white, isShadow: true)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        googleButton.customizedGoogleButton()
        setupConstraints()
        emailButton.addTarget(self, action: #selector(emailButtonTapped), for: .touchUpInside)
        loginButton.addTarget(self , action: #selector(loginButtonTapped), for: .touchUpInside)
        googleButton.addTarget(self, action: #selector(googleLoginButtonTapped), for: .touchUpInside )
        
        loginVC.delegate = self
        signUpVC.delegate = self
        GIDSignIn.sharedInstance()?.delegate = self
    }
    
    //MARK: - Selector's methods
    @objc private func emailButtonTapped() {
        print(#function)
        present(SignUpViewController(), animated: true, completion: nil)
    }
    
    @objc private func loginButtonTapped() {
        print(#function)
        present(LoginViewController(), animated: true, completion: nil)
    }
    
    @objc private func googleLoginButtonTapped() {
        print(#function)
        GIDSignIn.sharedInstance()?.presentingViewController = self
        GIDSignIn.sharedInstance()?.signIn()
    }
}

//MARK: - Setup constraints
extension AuthViewController {
    
    private func setupConstraints() {
        view.addSubview(logoImageView)
        let googleView = ButtonFromView(label: googleLabel, button: googleButton)
        let emailView = ButtonFromView(label: emailLabel, button: emailButton)
        let loginView = ButtonFromView(label: alreadyOnBoardLabel, button: loginButton)
        
        let stackView = UIStackView(arrangedSubviews: [googleView, emailView, loginView], axis: .vertical, spacing: 40)
        view.addSubview(stackView)
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 40
        
        logoImageView.translatesAutoresizingMaskIntoConstraints = false
        logoImageView.topAnchor.constraint(equalTo: view.topAnchor, constant: 160).isActive = true
        logoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        stackView.topAnchor.constraint(equalTo: logoImageView.bottomAnchor, constant: 160).isActive = true
        stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40).isActive = true
        stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40).isActive = true
        
    }
    
}

extension AuthViewController: AuthNavigationDelegate {
    func toLoginVC() {
        present(loginVC, animated: true)
    }
    
    func toSignUpVC() {
        present(signUpVC, animated: true)
    }
    
    
}

//MARK: GID sign in delegate
extension AuthViewController: GIDSignInDelegate {
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        AuthService.shared.googleLogin(user: user, error: error) { (result) in
            switch result {
            
            case .success(let user):
                FirestoreService.shared.getUserData(user: user) { (result) in
                    switch result {
                     
                    case .success(let muser):
                        let mainTBVC = MainTabBarController(currentUser: muser)
                        mainTBVC.modalPresentationStyle = .fullScreen
                        UIApplication.getTopViewController()?.present(mainTBVC, animated: true)
                    case .failure(_):
                        UIApplication.getTopViewController()?.presentAlert(title: "Success", message: "You registered") {
                            self.present(SetupProfileViewController(currentUser: user), animated: true, completion: nil)
                        }
                    }
                }
            case .failure(let error):
                UIApplication.getTopViewController()? .presentAlert(title: "Erorr!", message: error.localizedDescription)
            }
        }
    }
    
    
}

//MARK: - SwiftUI
import SwiftUI

struct AuthVCProvider: PreviewProvider {
    static var previews: some View {
        ConteinerView().edgesIgnoringSafeArea(.all)
    }
    
    struct ConteinerView: UIViewControllerRepresentable {
        
        let viewController = AuthViewController()
        
        func makeUIViewController(context: Context) -> some UIViewController {
            return viewController
        }
        
        func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
            
        }
    }
}
