//
//  MovieTitleCell.swift
//  MoviesApp_Rx
//
//  Created by Tak on 8/22/24.
//

import UIKit
import SnapKit

final class MovieTitleCell: UICollectionViewCell {
    static let identifier = "MovieTitleCell"
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: .title2)
        label.numberOfLines = 0
        
        return label
    }()
    
    private let voteIconView: VoteAverageView = {
        let iconView = VoteAverageView()
        
        return iconView
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
        titleLabel.text = nil
//        voteIconView.voteValue = nil
    }
    
    private func setupLayout() {
        [
            titleLabel,
            voteIconView
        ].forEach { contentView.addSubview($0)}
        
        titleLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().inset(20)
            $0.trailing.lessThanOrEqualTo(voteIconView.snp.leading).offset(-10)
        }
        
        voteIconView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().inset(20)
            $0.width.height.equalTo(50)
        }
    }
    
    func setup(title: String, voteAverage: Double) {
        titleLabel.text = title
        voteIconView.voteValue = voteAverage
    }
}
