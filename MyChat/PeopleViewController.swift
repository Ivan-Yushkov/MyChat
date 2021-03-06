//
//  PeopleViewController.swift
//  MyChat
//
//  Created by Иван Юшков on 24.01.2021.
//

import UIKit
import Firebase
import FirebaseFirestore



class PeopleViewController: UIViewController {

    var users = [MUser]()
    var userListener: ListenerRegistration?
    
    enum Section: Int, CaseIterable {
        case users
        
        func description(itemsCount: Int) -> String {
            switch self {
            case .users:
                return "\(itemsCount) people nearby"
            }
        }
    }
    
    private let currentUser: MUser
    
    init(currentUser: MUser) {
        self.currentUser = currentUser
        super.init(nibName: nil, bundle: nil)
        title = currentUser.username
    }
    
    deinit {
        userListener?.remove()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var collectionView: UICollectionView!
    var dataSource: UICollectionViewDiffableDataSource<Section, MUser>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .orange
        setupSearchBar()
        setupCollectionView()
        createDataSourse()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Log Out", style: .plain, target: self, action: #selector(signOut))
        
        userListener = ListenerService.shared.userObserve(users: users, completion: { (result) in
            switch result {
            
            case .success(let users):
                self.users = users
                self.reloadData(searchText: nil)
            case .failure(let error):
                self.presentAlert(title: "Error", message: error.localizedDescription)
            }
        })
    }
    
    @objc private func signOut() {
        let ac = UIAlertController(title: nil, message: "Are you sure you want to sign out", preferredStyle: .alert)
        let action = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let signOutAction = UIAlertAction(title: "Sign Out", style: .destructive) { (_) in
            do {
                try Auth.auth().signOut()
                UIApplication.shared.keyWindow?.rootViewController = AuthViewController()
            } catch {
                print(error.localizedDescription)
            }
        }
        ac.addAction(action)
        ac.addAction(signOutAction)
        present(ac, animated: true)
    }
    
    private func setupCollectionView() {
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: createCompositionalLayout())
        collectionView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        collectionView.backgroundColor = .mainWhite
        view.addSubview(collectionView)
        collectionView.delegate = self
        collectionView.register(SectionHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: SectionHeader.reuseId)
        collectionView.register(UserCell.self, forCellWithReuseIdentifier: UserCell.reuseID)
    }
    
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

    
}

//MARK: - methods for compositional layout
extension PeopleViewController {
    private func createCompositionalLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { [weak self] (sectionIndex, _) -> NSCollectionLayoutSection? in
            guard let self = self,
                let section = Section(rawValue: sectionIndex) else { fatalError("cannot create section")}
            
            switch section {
            case .users:
                return self.createUsers()
            }
        }
        return layout
    }
    
    private func createUsers() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalWidth(0.6))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 2)
        group.interItemSpacing = .fixed(15)
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 15
        section.contentInsets = NSDirectionalEdgeInsets.init(top: 16, leading: 15, bottom: 0, trailing: 15)
        
        section.boundarySupplementaryItems = [createSectionHeder()]
        return section
    }
    
    private func createSectionHeder() -> NSCollectionLayoutBoundarySupplementaryItem {
        let sectionHeaderSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(1))
        return NSCollectionLayoutBoundarySupplementaryItem(layoutSize: sectionHeaderSize, elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
    }
}


//MARK: - methods for differable data source
extension PeopleViewController {
    private func configure(value: MUser, indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: UserCell.reuseID, for: indexPath) as? UserCell else { fatalError("cannot create cell") }
        return cell
    }
    
    private func createDataSourse() {
        dataSource = UICollectionViewDiffableDataSource<Section, MUser>(collectionView: collectionView, cellProvider: { (collectionView, indexPath, user) -> UICollectionViewCell? in
            guard let section = Section(rawValue: indexPath.section) else { fatalError("problems with section") }
            switch section {
            case .users:
                return self.configure(collectionView: collectionView, cellType: UserCell.self, value: user, for: indexPath)
            }
        })
        
        dataSource?.supplementaryViewProvider = { collectionView, kind, indexPath in
            guard let sectionHeader = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: SectionHeader.reuseId, for: indexPath) as? SectionHeader else {
                fatalError("cannot creare section header")
            }
            guard let section = Section(rawValue: indexPath.section),
                  let items = self.dataSource?.snapshot().itemIdentifiers(inSection: .users)
                  else { fatalError("cannot create section") }
            
            sectionHeader.configurate(text: section.description(itemsCount: items.count),
                                      font: .systemFont(ofSize: 36, weight: .light),
                                      textColor: .label)
            return sectionHeader
        }
    }
    
    private func reloadData(searchText: String?) {
        let filteredUsers = users.filter { (user) -> Bool in
            user.isContains(text: searchText)
        }
        
        var snapshot = NSDiffableDataSourceSnapshot<Section, MUser>()
        snapshot.appendSections([.users])
        snapshot.appendItems(filteredUsers, toSection: .users)
        dataSource?.apply(snapshot, animatingDifferences: true)
    }
}

//MARK: - Search bar delegate
extension PeopleViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        reloadData(searchText: searchText)
        print(searchText)
    }
}

extension PeopleViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let user = self.dataSource?.itemIdentifier(for: indexPath) else { return }
        let profileVC = ProfileViewController(user: user)
        present(profileVC, animated: true, completion: nil)
    }
}


//MARK: - SwiftUI
import SwiftUI

struct PeopleVCProvider: PreviewProvider {
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
