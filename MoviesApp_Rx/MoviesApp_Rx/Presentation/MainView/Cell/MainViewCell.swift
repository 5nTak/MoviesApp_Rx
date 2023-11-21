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
        imageView.image = UIImage(systemName: "star")
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
    
    private let directorLabel: UILabel = {
        let label = UILabel()
        label.text = "감독"
        label.textColor = .black
        label.font = .systemFont(ofSize: 13)
        label.sizeToFit()
        label.numberOfLines = 1
        return label
    }()
    
    private let starringLabel: UILabel = {
        let label = UILabel()
        label.text = "출연"
        label.textColor = .black
        label.font = .systemFont(ofSize: 13)
        label.sizeToFit()
        label.numberOfLines = 1
        return label
    }()
    
    private let ratingLabel: UILabel = {
        let label = UILabel()
        label.text = "평점"
        label.textColor = .black
        label.font = .systemFont(ofSize: 13)
        label.sizeToFit()
        label.numberOfLines = 1
        return label
    }()
    
    private let starButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "star.fill"), for: .normal)
        return button
    }()
    
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .equalSpacing
        return stackView
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
            stackView,
            starButton
        ].forEach { contentView.addSubview($0) }
        
        imageView.snp.makeConstraints {
            $0.verticalEdges.equalTo(contentView)
            $0.leading.equalToSuperview()
            $0.width.equalTo(100)
        }
        
        [
            titleLabel,
            directorLabel,
            starringLabel,
            ratingLabel
        ].forEach { stackView.addArrangedSubview($0) }
        
        stackView.snp.makeConstraints {
            $0.leading.equalTo(imageView.snp.trailing)
            $0.top.bottom.trailing.equalToSuperview().inset(10)
        }
        
        starButton.snp.makeConstraints {
            $0.top.trailing.equalToSuperview().inset(10)
        }
    }
    
    func setup(index: Int) {
        titleLabel.text = "영화제목 \(index + 1)번째 셀"
    }
}
