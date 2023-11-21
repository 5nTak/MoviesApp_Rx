//
//  MainView.swift
//  MoviesApp_Rx
//
//  Created by Tak on 2023/11/20.
//

import UIKit
import SnapKit

class MainView: UIViewController {
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.black
        label.font = .systemFont(ofSize: 20, weight: .bold)
        label.text = "네이버 영화 검색"
        return label
    }()
    
    // 즐겨찾기 text 앞에 switching 가능한 starbutton
    private let starButton: UIButton = {
        let button = UIButton()
        button.setTitle("즐겨찾기", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 14)
        
        button.layer.borderColor = UIColor.systemGray2.cgColor
        button.layer.borderWidth = 0.5
        button.layer.cornerRadius = 10
        
        // 좀 더 깔끔한 방법 고민해보기
        let margin: CGFloat = 10.0
        
        button.snp.makeConstraints {
            $0.width.equalTo(button.titleLabel!.intrinsicContentSize.width + margin * 2.0)
            $0.height.equalTo(button.titleLabel!.intrinsicContentSize.height + margin * 1.2)
        }
        return button
    }()
    
    private let searchBar: UIView = {
        let view = UIView()
        
        return view
    }()
    
    private let searchBarTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "검색어를 입력하세요."
        return textField
    }()
    
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 1
        layout.minimumInteritemSpacing = 0
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(MainViewCell.self, forCellWithReuseIdentifier: "MainViewCell")
        return collectionView
    }()
    
    private var dataSource = MainCollectionViewDataSource()

    override func viewDidLoad() {
        super.viewDidLoad()
        setNavigationBar()
        setSearchBarLayout()
        setCollectionViewLayout()
    }
    
    func setNavigationBar() {
        self.navigationItem.leftBarButtonItem = UIBarButtonItem.init(customView: titleLabel)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(customView: starButton)
    }
    
    func setSearchBarLayout() {
        view.addSubview(searchBar)
        searchBar.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(50)
        }
        searchBar.addSubview(searchBarTextField)
        searchBarTextField.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview().inset(10)
            $0.verticalEdges.equalToSuperview().inset(7)
        }
    }
    
    func setCollectionViewLayout() {
        view.addSubview(collectionView)
        collectionView.dataSource = dataSource
        collectionView.delegate = self
        collectionView.snp.makeConstraints {
            $0.top.equalTo(searchBar.snp.bottom)
            $0.leading.trailing.equalToSuperview().inset(15)
            $0.bottom.equalToSuperview()
        }
    }
}

// CollectionView FlowLayout
extension MainView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.width
        let height: CGFloat = 100
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 10, left: 5, bottom: 10, right: 10)
    }
}
