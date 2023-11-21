//
//  MainViewCell.swift
//  MoviesApp_Rx
//
//  Created by Tak on 2023/11/20.
//

import UIKit
import SnapKit

class MainViewCell: UICollectionViewCell {
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "person")
        imageView.tintColor = .darkGray
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "영화 제목"
        label.textColor = .black
        label.font = .systemFont(ofSize: 15, weight: .bold)
        label.sizeToFit()
        label.numberOfLines = 1
        return label
    }()
    
    private let starButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "star.fill"), for: .normal)
        button.tintColor = .systemYellow
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    private func setupLayout() {
        [
            imageView,
            titleLabel,
            starButton
        ].forEach { contentView.addSubview($0) }
        
        imageView.snp.makeConstraints {
            $0.top.horizontalEdges.equalToSuperview()
            $0.bottom.equalTo(titleLabel.snp.top)
        }
        
        titleLabel.snp.makeConstraints {
            $0.bottom.equalToSuperview()
        }
        
        starButton.snp.makeConstraints {
            $0.top.trailing.equalToSuperview().inset(10)
        }
    }
    
    func setup(index: Int) {
        titleLabel.text = "영화제목 \(index + 1)번째 셀"
    }
}
