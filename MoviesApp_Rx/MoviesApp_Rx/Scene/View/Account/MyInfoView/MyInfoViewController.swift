//
//  MyInfoViewController.swift
//  MoviesApp_Rx
//
//  Created by Tak on 7/2/24.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa
import RxDataSources
import FirebaseAuth

final class MyInfoViewController: UIViewController {
    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: createLayout())
        collectionView.register(ProfileCell.self, forCellWithReuseIdentifier: ProfileCell.identifier)
        collectionView.register(StarCell.self, forCellWithReuseIdentifier: StarCell.identifier)
        collectionView.register(SettingCell.self, forCellWithReuseIdentifier: SettingCell.identifier)
        collectionView.register(MyInfoCollectionHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: MyInfoCollectionHeaderView.identifier)
        return collectionView
    }()
    
    var viewModel: MyInfoViewModel?
    private var rxDataSources: RxCollectionViewSectionedReloadDataSource<AccountSectionModel>?
    private let disposeBag = DisposeBag()
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupLayout()
        configureDataSource()
        viewModel?.setSections()
        bind()
    }
    
    private func setupLayout() {
        view.backgroundColor = .systemBackground
        view.addSubview(collectionView)
        
        collectionView.backgroundColor = .secondarySystemBackground
    }
    
    private func bind() {
        if let dataSource = rxDataSources {
            viewModel?.sections
                .bind(to: collectionView.rx.items(dataSource: dataSource))
                .disposed(by: disposeBag)
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


extension MyInfoViewController {
    private func createLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { (sectionIndex, layoutEnvironment) -> NSCollectionLayoutSection? in
            guard let section = MyInfoSection(rawValue: sectionIndex) else { return nil }
            switch section {
            case .profile:
                return self.createProfileSection()
            case .star:
                return self.createStarSection()
            case .setting:
                return self.createSettingSection()
            }
        }
        return layout
    }
    
    private func createProfileSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .fractionalHeight(1)
        )
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .fractionalHeight(1/10)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 0, bottom: 10, trailing: 0)
        let sectionHeader = self.createSectionHeader()
        section.boundarySupplementaryItems = [sectionHeader]
        
        return section
    }
    
    private func createStarSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .fractionalHeight(1)
        )
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .fractionalHeight(1/2)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 0, bottom: 10, trailing: 0)
        section.orthogonalScrollingBehavior = .continuous
        let sectionHeader = self.createSectionHeader()
        section.boundarySupplementaryItems = [sectionHeader]
        
        return section
    }
    
    private func createSettingSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .fractionalHeight(1)
        )
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .fractionalWidth(1/6)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 0, bottom: 30, trailing: 0)
        let sectionHeader = self.createSectionHeader()
        section.boundarySupplementaryItems = [sectionHeader]
        
        return section
    }
    
    private func createSectionHeader() -> NSCollectionLayoutBoundarySupplementaryItem {
        let layoutSectionHeaderSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .estimated(100)
        )
        let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: layoutSectionHeaderSize,
            elementKind: UICollectionView.elementKindSectionHeader,
            alignment: .top
        )
        return sectionHeader
    }
}

extension MyInfoViewController {
    private func configureDataSource() {
        rxDataSources = RxCollectionViewSectionedReloadDataSource<AccountSectionModel>(
            configureCell: { rxDataSources, collectionView, indexPath, item in
                switch indexPath.section {
                case 0:
                    guard let profileCell = collectionView.dequeueReusableCell(
                        withReuseIdentifier: ProfileCell.identifier,
                        for: indexPath
                    ) as? ProfileCell else { return UICollectionViewCell() }
                    profileCell.setup(email: self.viewModel?.email ?? "Email")
                    
                    return profileCell
                case 1:
                    guard let starCell = collectionView.dequeueReusableCell(
                        withReuseIdentifier: StarCell.identifier,
                        for: indexPath
                    ) as? StarCell else { return UICollectionViewCell() }
                    starCell.setFailedLoadImage()
                    return starCell
                case 2:
                    guard let settingCell = collectionView.dequeueReusableCell(
                        withReuseIdentifier: SettingCell.identifier,
                        for: indexPath
                    ) as? SettingCell else { return UICollectionViewCell() }
                    
                    settingCell.setLogoutButton()
                    settingCell.logoutButton.addTarget(self, action: #selector(self.executeLogout), for: .touchUpInside)
                    return settingCell
                default:
                    return UICollectionViewCell()
                }
        },
            configureSupplementaryView: { rxDataSources, collectionView, kind, indexPath in
                let sectionModel = rxDataSources.sectionModels[indexPath.section]
                guard let section = collectionView.dequeueReusableSupplementaryView(
                    ofKind: kind,
                    withReuseIdentifier: MyInfoCollectionHeaderView.identifier,
                    for: indexPath
                ) as? MyInfoCollectionHeaderView else { return UICollectionReusableView() }
                section.setTitle(title: sectionModel.title)
                
                return section
            }
        )
    }
}

enum MyInfoSection: Int, CaseIterable {
    case profile, star, setting
    
    var description: String {
        switch self {
        case .profile:
            return "Profile"
        case .star:
            return "Star"
        case .setting:
            return "Setting"
        }
    }
}
