//
//  UIViewController+Extension.swift
//  MyChat
//
//  Created by Иван Юшков on 26.01.2021.
//

import UIKit

extension UIViewController {
    
    func configure<T: SelfConfiguringCell, U: Hashable>(collectionView: UICollectionView, cellType: T.Type, value: U, for indexPath: IndexPath) -> T {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellType.reuseID, for: indexPath) as? T else { fatalError("Unable to dequeue cell type") }
        cell.configure(value: value)
        return cell
    }
    
    func presentAlert(title: String, message: String, completion: @escaping () -> Void = { }) {
        let ac = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default) { (_) in
            completion()
        }
        ac.addAction(action)
        present(ac, animated: true, completion: nil)
    }
}
