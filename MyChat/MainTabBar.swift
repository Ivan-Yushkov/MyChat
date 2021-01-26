//
//  MainTabBar.swift
//  MyChat
//
//  Created by Иван Юшков on 24.01.2021.
//

import UIKit

class MainTabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let listVC = ListViewController()
        let peopleVC = PeopleViewController()
        tabBar.tintColor = #colorLiteral(red: 0.5568627451, green: 0.3529411765, blue: 0.968627451, alpha: 1)
        
        let boldConfig = UIImage.SymbolConfiguration(weight: .medium)
        guard let peopleImage = UIImage(systemName: "person.2", withConfiguration: boldConfig),
              let convImage = UIImage(systemName: "bubble.left.and.bubble.right", withConfiguration: boldConfig) else { return }
        
        viewControllers = [
            generateNavigationController(rootViewController: peopleVC, title: "People", image: peopleImage),
            generateNavigationController(rootViewController: listVC, title: "Conversation", image: convImage)
            
        ]
    }
    
    private func generateNavigationController(rootViewController: UIViewController, title: String, image: UIImage) -> UINavigationController {
        let navigatinVC = UINavigationController(rootViewController: rootViewController)
        navigatinVC.tabBarItem.title = title
        navigatinVC.tabBarItem.image = image
        return navigatinVC
    }
}
