//
//  HomeViewController.swift
//  MoviesApp_Rx
//
//  Created by Tak on 2023/11/20.
//

import UIKit
import SnapKit

class HomeViewController: UIViewController {
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.black
        label.font = .systemFont(ofSize: 25, weight: .bold)
        label.text = "맞춤 영화"
        return label
    }()
    
    // 즐겨찾기 text 앞에 switching 가능한 starbutton
//    private let starButton: UIButton = {
//        let button = UIButton()
//        button.setTitle("즐겨찾기", for: .normal)
//        button.setTitleColor(.black, for: .normal)
//        button.titleLabel?.font = .systemFont(ofSize: 14)
//
//        button.layer.borderColor = UIColor.systemGray2.cgColor
//        button.layer.borderWidth = 0.5
//        button.layer.cornerRadius = 10
//
//        // 좀 더 깔끔한 방법 고민해보기
//        let margin: CGFloat = 10.0
//
//        button.snp.makeConstraints {
//            $0.width.equalTo(button.titleLabel!.intrinsicContentSize.width + margin * 2.0)
//            $0.height.equalTo(button.titleLabel!.intrinsicContentSize.height + margin * 1.2)
//        }
//        return button
//    }()
    
//    private let searchBar: UIView = {
//        let view = UIView()
//
//        return view
//    }()
//
//    private let searchBarTextField: UITextField = {
//        let textField = UITextField()
//        textField.placeholder = "검색어를 입력하세요."
//        return textField
//    }()
    
    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: self.setCollectionViewLayout())
        collectionView.register(
            HomeCollectionViewCell.self,
            forCellWithReuseIdentifier: HomeCollectionViewCell.identifier
        )
        collectionView.register(
            HomeCollectionHeaderView.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: HomeCollectionHeaderView.identifier
        )
        return collectionView
    }()
    
    private var dataSource = HomeCollectionViewDataSource()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setNavigationBar()
//        setSearchBarLayout()
        setCollectionViewConstraints()
    }
    
    func setNavigationBar() {
        self.navigationItem.leftBarButtonItem = UIBarButtonItem.init(customView: titleLabel)
//        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(customView: starButton)
    }
    
//    func setSearchBarLayout() {
//        view.addSubview(searchBar)
//        searchBar.snp.makeConstraints {
//            $0.top.equalTo(view.safeAreaLayoutGuide)
//            $0.leading.trailing.equalToSuperview()
//            $0.height.equalTo(50)
//        }
//        searchBar.addSubview(searchBarTextField)
//        searchBarTextField.snp.makeConstraints {
//            $0.horizontalEdges.equalToSuperview().inset(10)
//            $0.verticalEdges.equalToSuperview().inset(7)
//        }
//    }
    
    func setCollectionViewConstraints() {
        view.addSubview(collectionView)
        collectionView.dataSource = dataSource
        collectionView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.horizontalEdges.bottom.equalToSuperview()
        }
    }
}

// MARK: - CompositionalLayout
extension HomeViewController {
    private func setCollectionViewLayout() -> UICollectionViewLayout {
        // UICollectionViewCompositionalLayout.sectionProvider 공부
        return UICollectionViewCompositionalLayout(section: self.createSection())
    }
    
    private func createSection() -> NSCollectionLayoutSection {
        let itemInset: CGFloat = 2.5
        let itemWidth: CGFloat = (UIScreen.main.bounds.width) / 3
        let ratio: CGFloat = 7 / 9
        let itemHeight: CGFloat = itemWidth / ratio
        
        // MARK: - CompositionalLayout Item
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .absolute(itemWidth),
            heightDimension: .fractionalHeight(1)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(
            top: itemInset,
            leading: itemInset,
            bottom: itemInset,
            trailing: itemInset
        )
        
        // MARK: - CompositionalLayout Group
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .absolute(itemHeight)
        )
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: groupSize,
            subitems: [item]
        )
        
        // Section
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(
            top: itemInset,
            leading: itemInset,
            bottom: itemInset,
            trailing: itemInset
        )
        section.orthogonalScrollingBehavior = .continuous
        
        let sectionHeader = createSectionHeader()
        section.boundarySupplementaryItems = [sectionHeader]
        
        return section
    }

    private func createSectionHeader() -> NSCollectionLayoutBoundarySupplementaryItem {
        let layoutSectionHeaderSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .estimated(60)
        )
        
        let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: layoutSectionHeaderSize,
            elementKind: UICollectionView.elementKindSectionHeader,
            alignment: .top
        )
        
        return sectionHeader
    }
}

enum SectionLayoutKind: Int, CaseIterable {
    case popularList, trendingMovies, latest
    
    var description: String {
        switch self {
        case .popularList:
            return "인기 순위"
        case .trendingMovies:
            return "지금 뜨는"
        case .latest:
            return "최신 개봉"
        }
    }
}
