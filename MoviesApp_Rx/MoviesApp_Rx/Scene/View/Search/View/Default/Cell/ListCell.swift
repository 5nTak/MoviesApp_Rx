//
//  ListCell.swift
//  MoviesApp_Rx
//
//  Created by Tak on 8/5/24.
//

import UIKit
import SnapKit

final class ListCell: UICollectionViewCell {
    static let identifier = "ListCell"
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: .body)
        label.textColor = .systemBlue
        return label
    }()
    private let arrowButton: UIButton = {
        let button = UIButton()
        button.setBackgroundImage(UIImage(systemName: "chevron.right"), for: .normal)
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        titleLabel.text = nil
        configureArrowButton()
    }
    
    private func configureLayout() {
        [
            titleLabel,
            arrowButton
        ].forEach { contentView.addSubview($0) }
        
        titleLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().inset(30)
        }
        
        configureArrowButton()
        
        contentView.backgroundColor = .white
        contentView.layer.borderWidth = 1
        contentView.layer.borderColor = UIColor.systemGray6.cgColor
    }
    
    private func configureArrowButton() {
        arrowButton.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalTo(titleLabel.snp.trailing).offset(10)
            $0.trailing.equalToSuperview().inset(15)
        }
    }
    
    func setup(title: String) {
        self.titleLabel.text = title
    }
    
    func changeTextColor(color: UIColor) {
        titleLabel.textColor = color
    }
}
