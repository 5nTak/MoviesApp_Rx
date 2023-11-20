//
//  ViewController.swift
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
        
        return textField
    }()
    
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .brown
        return collectionView
    }()

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
        searchBar.backgroundColor = .red
        searchBar.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(50)
        }
        searchBar.addSubview(searchBarTextField)
        searchBarTextField.backgroundColor = .green
        searchBarTextField.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview().inset(10)
            $0.verticalEdges.equalToSuperview().inset(7)
        }
    }
    
    func setCollectionViewLayout() {
        view.addSubview(collectionView)
        
        collectionView.snp.makeConstraints {
            // searchBar 생성 후 레이아웃 다시 맞추기
            $0.top.equalTo(searchBar.snp.bottom)
            $0.leading.trailing.bottom.equalToSuperview()
//            $0.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }
}
