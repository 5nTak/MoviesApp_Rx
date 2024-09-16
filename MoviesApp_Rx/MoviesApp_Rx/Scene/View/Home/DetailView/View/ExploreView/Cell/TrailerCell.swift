//
//  TrailerCell.swift
//  MoviesApp_Rx
//
//  Created by Tak on 9/17/24.
//

import UIKit
import SnapKit
import Kingfisher
import youtube_ios_player_helper

final class TrailerCell: UITableViewCell {
    static let identifier = "TrailerCell"
    
    private let playerView: YTPlayerView = {
        let playerView = YTPlayerView()
        return playerView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: .subheadline)
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    private let loadingIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .medium)
        indicator.hidesWhenStopped = true
        return indicator
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
        titleLabel.text = nil
        playerView.pauseVideo()
    }
    
    private func setupLayout() {
        [
            playerView,
            titleLabel,
            loadingIndicator
        ].forEach { contentView.addSubview($0) }
        
        playerView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(10)
            $0.leading.trailing.equalToSuperview().inset(5)
            $0.height.equalTo(250)
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(playerView.snp.bottom).offset(8)
            $0.leading.trailing.equalToSuperview().inset(5)
            $0.bottom.equalToSuperview().inset(20)
        }
        
        loadingIndicator.snp.makeConstraints {
            $0.center.equalTo(playerView)
        }
    }
    
    func setup(title: String, videoUrl: String) {
        titleLabel.text = title
        loadingIndicator.startAnimating()

        playerView.delegate = self
        playerView.load(withVideoId: videoUrl)
    }
}

// MARK: - YTPlayerViewDelegate
extension TrailerCell: YTPlayerViewDelegate {
    func playerViewDidBecomeReady(_ playerView: YTPlayerView) {
        loadingIndicator.stopAnimating()
    }
}
