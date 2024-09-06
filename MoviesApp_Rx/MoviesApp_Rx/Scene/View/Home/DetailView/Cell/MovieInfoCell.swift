//
//  MovieInfoCell.swift
//  MoviesApp_Rx
//
//  Created by Tak on 8/22/24.
//

import UIKit
import SnapKit

final class MovieInfoCell: UICollectionViewCell {
    static let identifier = "MovieInfoCell"
    
    private let genreTitleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: .headline)
        label.textAlignment = .center
        label.text = "Genres"
        return label
    }()
    
    private let genresLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: .body)
        label.textAlignment = .center
        label.numberOfLines = 2
        label.lineBreakMode = .byWordWrapping
        label.text = "Genres name"
        return label
    }()
    
    private let genreStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        return stackView
    }()
    
    private let releaseTitleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: .headline)
        label.textAlignment = .center
        label.text = "Release"
        return label
    }()
    
    private let releaseDateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: .body)
        label.textAlignment = .center
        label.text = "20xx-xx-xx"
        return label
    }()
    
    private let releaseStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        return stackView
    }()
    
    private let underLineView: UIView = {
        let underLineView = UIView()
        underLineView.backgroundColor = .lightGray
        return underLineView
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
        genreTitleLabel.text = nil
        genresLabel.text = nil
        releaseTitleLabel.text = nil
        releaseDateLabel.text = nil
    }
    
    private func setupLayout() {
        [
            genreTitleLabel,
            genresLabel
        ].forEach { genreStackView.addArrangedSubview($0) }
        
        [
            releaseTitleLabel,
            releaseDateLabel
        ].forEach { releaseStackView.addArrangedSubview($0) }
        
        [
            genreStackView,
            releaseStackView,
            underLineView
        ].forEach { contentView.addSubview($0) }
        
        genreStackView.snp.makeConstraints {
            $0.top.leading.bottom.height.equalToSuperview()
            $0.width.equalToSuperview().dividedBy(2)
        }
        
        releaseStackView.snp.makeConstraints {
            $0.top.trailing.bottom.height.equalToSuperview()
            $0.width.equalToSuperview().dividedBy(2)
        }
        
        underLineView.snp.makeConstraints {
            $0.top.equalTo(self.snp.bottom)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(1)
        }
    }
    
    func configure(genres: [String], releaseDate: String) {
        if genres.isEmpty {
            genresLabel.text = "Unknown"
        } else {
            genresLabel.text = "\(genres.joined(separator: " "))"
        }
        releaseDateLabel.text = releaseDate
    }
}
