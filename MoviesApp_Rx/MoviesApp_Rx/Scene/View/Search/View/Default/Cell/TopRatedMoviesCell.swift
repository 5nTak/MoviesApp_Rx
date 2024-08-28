//
//  TopRatedMoviesCell.swift
//  MoviesApp_Rx
//
//  Created by Tak on 8/11/24.
//

import UIKit
import SnapKit
import Kingfisher

final class TopRatedMoviesCell: UITableViewCell {
    static let identifier = "TopRatedMoviesCell"
    
    private let moviesPosterView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "ellipsis")
        imageView.contentMode = .scaleAspectFit
        imageView.kf.indicatorType = .activity
        return imageView
    }()
    
    private let labelStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        return stackView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: .title3)
        label.numberOfLines = 2
        return label
    }()
    
    private let genreLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: .subheadline)
        label.numberOfLines = 2
        return label
    }()
    
    private let releasedDateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: .footnote)
        label.numberOfLines = 1
        return label
    }()
    
    private let voteIconView: VoteAverageView = {
        let iconView = VoteAverageView()
        
        return iconView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        moviesPosterView.image = nil
        titleLabel.text = nil
        genreLabel.text = nil
        releasedDateLabel.text = nil
        voteIconView.voteValue = nil
    }
    
    private func setupLayout() {
        [
            titleLabel,
            genreLabel,
            releasedDateLabel
        ].forEach { labelStackView.addArrangedSubview($0) }
        
        [
            moviesPosterView,
            labelStackView,
            voteIconView
        ].forEach { contentView.addSubview($0) }
        
        moviesPosterView.snp.makeConstraints {
            $0.top.leading.bottom.equalToSuperview().inset(10)
            $0.width.equalToSuperview().dividedBy(4)
            $0.height.equalTo(moviesPosterView.snp.width).multipliedBy(1.5)
        }
        
        labelStackView.snp.makeConstraints {
            $0.top.bottom.equalToSuperview()
            $0.leading.equalTo(moviesPosterView.snp.trailing).offset(10)
        }
        
        voteIconView.snp.makeConstraints {
            $0.top.bottom.trailing.equalToSuperview()
            $0.width.height.equalTo(50)
            $0.leading.equalTo(labelStackView.snp.trailing).offset(10)
        }
    }
    
    func setup(title: String, genres: [String], releasedDate: String, voteAverage: Double) {
        titleLabel.text = title
        if genres.isEmpty {
            genreLabel.text = "Genres: Unknown"
        } else {
            genreLabel.text = "Genre: \(genres.joined(separator: " "))"
        }
        releasedDateLabel.text = releasedDate
        voteIconView.voteValue = voteAverage
    }
    
    func loadImage(url: String) {
        let urlString = moviesPosterView.imageBaseUrl + moviesPosterView.imageSize + url
     
        moviesPosterView.setImageCache(with: urlString)
    }
    
    func setFailedLoadImage() {
        moviesPosterView.image = UIImage(named: "noImageProvided")
        moviesPosterView.contentMode = .scaleAspectFill
        moviesPosterView.clipsToBounds = true
    }
}

