//
//  ListViewController.swift
//  MyChat
//
//  Created by Иван Юшков on 24.01.2021.
//

import UIKit
import FirebaseFirestore





class ListViewController: UIViewController {

    enum Section: Int, CaseIterable {
        case waitingChats
        case activeChats
        
        func description() -> String {
            switch self {
            case .waitingChats:
                return "Waiting chats"
            case .activeChats:
                return "Active chats"
            }
        }
    }
    
    let activeChats = [MChat]()
    var waitingChats = [MChat]()
    
    var waitingChatsListener: ListenerRegistration?
    
    var collectionView: UICollectionView!
    var dataSource: UICollectionViewDiffableDataSource<Section, MChat>?
    
    private let currentUser: MUser
    
    init(currentUser: MUser) {
        self.currentUser = currentUser
        super.init(nibName: nil, bundle: nil)
        title = currentUser.username
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        waitingChatsListener?.remove()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
        setupSearchBar()
        createDataSource()
        waitingChatsListener = ListenerService.shared.waitingChatsObserve(chats: waitingChats, completion: { (result) in
            switch result {
            case .success(let chats):
                if !self.waitingChats.isEmpty, self.waitingChats.count <= chats.count {
                    let chatRequestVC = ChatRequestViewController(chat: chats.last!)
                    chatRequestVC.delegate = self
                    self.present(chatRequestVC, animated: true, completion: nil)
                }
                
                self.waitingChats = chats
                self.reloadData(searchText: nil)
            case .failure(let error):
                self.presentAlert(title: "Error", message: error.localizedDescription)
            }
        })
        
    }
    
    //MARK: - method for setup collection view
    private func setupCollectionView() {
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: createCompositionalLayout())
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(collectionView)
        collectionView.backgroundColor = .mainWhite
        collectionView.register(ActiveClassCell.self, forCellWithReuseIdentifier: ActiveClassCell.reuseID)
        collectionView.register(WaitingChatCell.self, forCellWithReuseIdentifier: WaitingChatCell.reuseID)
        collectionView.register(SectionHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: SectionHeader.reuseId)
        collectionView.delegate = self
    }
    
    //MARK: - method for setup search bar
    private func setupSearchBar() {
        navigationController?.navigationBar.barTintColor = .mainWhite
        navigationController?.navigationBar.shadowImage = UIImage()
        let searchController = UISearchController(searchResultsController: nil)
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.delegate = self
    }
    
    //MARK: - composition layout methods
    private func createCompositionalLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { [weak self] (sectionIndex, _) -> NSCollectionLayoutSection? in
            guard let self = self else { fatalError() }
            guard let section = Section(rawValue: sectionIndex) else { fatalError() }
            
            switch section {
            
            case .activeChats:
                return self.createActiveChats()
            case .waitingChats:
                return self.createWaitingsChats()
            }
        }
        let config = UICollectionViewCompositionalLayoutConfiguration()
        config.interSectionSpacing = 20
        layout.configuration = config 
        return layout
    }
    
    private func createActiveChats() -> NSCollectionLayoutSection? {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                              heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(78))
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize,
                                                     subitems: [item])
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 8
        section.contentInsets = NSDirectionalEdgeInsets.init(top: 16, leading: 20, bottom: 0, trailing: 20)
        section.boundarySupplementaryItems = [createSectionHeder()]
        return section
    }
    
    private func createWaitingsChats() -> NSCollectionLayoutSection? {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .absolute(88), heightDimension: .absolute(88))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 16
        section.contentInsets = NSDirectionalEdgeInsets.init(top: 16, leading: 20, bottom: 0, trailing: 20)
        section.orthogonalScrollingBehavior = .continuous
        
        section.boundarySupplementaryItems = [createSectionHeder()]
        
        return section
    }
    
    //MARK: - DiffableDataSource methods
    
    
    
    private func createDataSource( ){
        dataSource = UICollectionViewDiffableDataSource<Section, MChat>(collectionView: collectionView, cellProvider: { (collectionView, indexPath, chat) -> UICollectionViewCell? in
            guard let section = Section(rawValue: indexPath.section) else { fatalError() }
            
            switch section {
            case .activeChats:
                return self.configure(collectionView: collectionView, cellType: ActiveClassCell.self, value: chat, for: indexPath)
            case .waitingChats:
                return self.configure(collectionView: collectionView, cellType: WaitingChatCell.self, value: chat, for: indexPath)
            }
        })
        
        dataSource?.supplementaryViewProvider = { collectionView, kind, indexPath in
            guard let sectionHeader = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: SectionHeader.reuseId, for: indexPath) as? SectionHeader else { fatalError("canno't create hedaer section")}
            guard let section = Section(rawValue: indexPath.item) else { fatalError("canno't find section") }
            
            sectionHeader.configurate(text: section.description(), font: .laoSangamMN20(), textColor: #colorLiteral(red: 0.5725490196, green: 0.5725490196, blue: 0.5725490196, alpha: 1))
            return sectionHeader
        }
    }
    
    private func reloadData(searchText: String?) {
        
        var snapshot = NSDiffableDataSourceSnapshot<Section, MChat>()
        snapshot.appendSections([.waitingChats, .activeChats])
        snapshot.appendItems(waitingChats, toSection: .waitingChats)
        snapshot.appendItems(activeChats, toSection: .activeChats)
        dataSource?.apply(snapshot)
    }
    
    
    private func createSectionHeder() -> NSCollectionLayoutBoundarySupplementaryItem {
        let sectionHeaderSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(1))
        return NSCollectionLayoutBoundarySupplementaryItem(layoutSize: sectionHeaderSize, elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
    }
}



//MARK: - Search bar delegate
extension ListViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        reloadData(searchText: searchText)
    }
}


//MARK: - Collection view Delegate
extension ListViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let chat = dataSource?.itemIdentifier(for: indexPath),
              let section = Section(rawValue: indexPath.section) else { return }
        
        switch section {
        case .waitingChats:
            let vc = ChatRequestViewController(chat: chat)
            vc.delegate = self
            present(vc, animated: true, completion: nil)
        case .activeChats:
            print(indexPath)
        }
    }
}


//MARK: - Waiting Chats navigation delegate
extension ListViewController: WaitingChatsNavigation {
    func removeWaitingChat(chat: MChat) {
        FirestoreService.shared.deleteWaitingChat(friendId: chat.friendId) { (result) in
            switch result {
            case .success():
                self.presentAlert(title: "Success", message: "Chat with user \(chat.friendUsername) has denied")
            case .failure(let error):
                self.presentAlert(title: "Error", message: error.localizedDescription)
            }
        }
    }
    
    func changeToActive(chat: MChat) {
        print(#function)
    }
    
    
}

//MARK: - SwiftUI
import SwiftUI

struct ListVCProvider: PreviewProvider {
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
