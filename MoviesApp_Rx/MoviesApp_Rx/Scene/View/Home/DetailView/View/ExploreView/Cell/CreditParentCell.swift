//
//  CreditParentCell.swift
//  MoviesApp_Rx
//
//  Created by Tak on 8/25/24.
//

import UIKit
import SnapKit
import RxSwift

final class CreditParentCell: UICollectionViewCell {
    static let identifier = "CreditParentCell"
    
    private var isExpanded: Bool = false
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: .headline)
        label.textColor = .black
        return label
    }()
    
    private let toggleView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "chevron.right")
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupLayout() {
        [
            titleLabel,
            toggleView
        ].forEach { contentView.addSubview($0) }
        
        contentView.snp.makeConstraints {
            $0.width.equalToSuperview()
            $0.height.equalTo(50)
        }
        
        toggleView.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(16)
            $0.centerY.equalToSuperview()
            $0.width.height.equalTo(20)
        }
        
        titleLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(16)
            $0.trailing.lessThanOrEqualTo(toggleView.snp.leading).offset(-8)
            $0.centerY.equalToSuperview()
        }
    }
    
    func configure(with title: String, expanded: Bool) {
        titleLabel.text = title
        updateToggleButton(expanded: expanded)
    }
    
    private func updateToggleButton(expanded: Bool) {
        let imageName = expanded ? "chevron.down" : "chevron.right"
        toggleView.image = UIImage(systemName: imageName)
    }
}
