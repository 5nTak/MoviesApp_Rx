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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigatonBar()
        setupLayout()
        configureDataSource()
        viewModel?.setSections()
        bind()
    }
    
    private func setupNavigatonBar() {
        navigationItem.title = AccountViewString.account.rawValue
    }
    
    private func setupLayout() {
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
    
    // 나중에 ViewModel로 분리
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
            heightDimension: .fractionalHeight(1/6)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 30, leading: 0, bottom: 0, trailing: 0)
        
        return section
    }
    
    private func createStarSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .fractionalHeight(1)
        )
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1/2),
            heightDimension: .fractionalHeight(0.35)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 0, bottom: 0, trailing: 0)
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
            heightDimension: .fractionalHeight(1/18)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 30, leading: 0, bottom: 20, trailing: 0)
        
        return section
    }
    
    private func createSectionHeader() -> NSCollectionLayoutBoundarySupplementaryItem {
        let layoutSectionHeaderSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .estimated(70)
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
                switch item {
                case .profile(let email):
                    guard let profileCell = collectionView.dequeueReusableCell(
                        withReuseIdentifier: ProfileCell.identifier,
                        for: indexPath
                    ) as? ProfileCell else { return UICollectionViewCell() }
                    profileCell.setup(email: email)
                    return profileCell
                case .star(let movie):
                    guard let starCell = collectionView.dequeueReusableCell(
                        withReuseIdentifier: StarCell.identifier,
                        for: indexPath
                    ) as? StarCell else { return UICollectionViewCell() }
                    starCell.setup(title: movie.title)
                    if movie.posterPath == nil {
                        starCell.setFailedLoadImage()
                    } else {
                        starCell.loadImage(url: movie.posterPath ?? "")
                    }
                    return starCell
                case .setting(let option):
                    guard let settingCell = collectionView.dequeueReusableCell(
                        withReuseIdentifier: SettingCell.identifier,
                        for: indexPath
                    ) as? SettingCell else { return UICollectionViewCell() }
                    settingCell.setLogoutButton()
                    settingCell.logoutButton.addTarget(self, action: #selector(self.executeLogout), for: .touchUpInside)
                    return settingCell
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
