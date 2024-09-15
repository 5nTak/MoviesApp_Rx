//
//  NoFavoriteCell.swift
//  MoviesApp_Rx
//
//  Created by Tak on 9/9/24.
//

import UIKit
import SnapKit

final class NoFavoritesCell: UICollectionViewCell {
    static let identifier = "NoFavoritesCell"
    
    private let messageLabel: UILabel = {
        let label = UILabel()
        label.text = "There's no favorite movies"
        label.font = UIFont.preferredFont(forTextStyle: .title1)
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupLayout() {
        contentView.addSubview(messageLabel)
        messageLabel.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(20)
        }
    }
}
