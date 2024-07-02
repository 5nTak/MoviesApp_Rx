//
//  MyInfoViewController.swift
//  MoviesApp_Rx
//
//  Created by Tak on 7/2/24.
//

import UIKit
import FirebaseAuth

final class MyInfoViewController: UIViewController {
//    private let collectionView: UICollectionView = {
//        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: <#T##UICollectionViewLayout#>)
//        return collectionView
//    }()
    
    var viewModel: MyInfoViewModel?
    
    private let logoutButton: UIButton = {
        let button = UIButton()
        button.setTitle(AccountViewString.logout.rawValue, for: .normal)
        button.setTitleColor(.systemBackground, for: .normal)
        button.backgroundColor = .systemBlue
        button.layer.cornerRadius = 8
        button.addTarget(self, action: #selector(executeLogout), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupLayout()
    }
    
    private func setupLayout() {
        view.backgroundColor = .systemBackground
        view.addSubview(logoutButton)
        
        let spacing: CGFloat = 20
        logoutButton.snp.makeConstraints {
            $0.center.equalTo(view)
            $0.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(8)
            $0.height.equalTo(50)
        }
    }
    
    @objc private func executeLogout() {
        do {
            try Auth.auth().signOut()
            showAlert(message: "Successfully logged out") {
                self.viewModel?.showLogin()
            }
        } catch let error {
            showAlert(message: "Logout failed: \(error.localizedDescription)")
        }
    }
}
