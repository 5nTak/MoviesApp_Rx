//
//  MovieOverviewCell.swift
//  MoviesApp_Rx
//
//  Created by Tak on 8/22/24.
//

import UIKit
import SnapKit

final class MovieOverviewCell: UICollectionViewCell {
    static let identifier = "MovieOverviewCell"
    
    private let overviewLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: .body)
        label.textColor = .label
        label.numberOfLines = 0
        label.textAlignment = .left
        return label
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
        overviewLabel.text = nil
    }
    
    private func setupLayout() {
        contentView.addSubview(overviewLabel)
        
        overviewLabel.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(10)
        }
    }
    
    func configure(overview: String) {
        overviewLabel.text = overview
    }
}
