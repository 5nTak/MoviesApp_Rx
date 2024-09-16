//
//  TrailerCell.swift
//  MoviesApp_Rx
//
//  Created by Tak on 9/17/24.
//

import UIKit
import SnapKit
import Kingfisher
import RxSwift
import RxCocoa

final class TrailerCell: UITableViewCell {
    static let identifier = "TrailerCell"
    
//    private let videoPlayer
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: .subheadline)
        label.numberOfLines = 0
        return label
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
    }
    
    private func setupLayout() {
        [
//            videoPlayer,
            titleLabel
        ].forEach { contentView.addSubview($0) }
        
        titleLabel.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(5)
            $0.top.bottom.equalToSuperview().inset(20) // 임시
            $0.height.equalTo(200) // 임시
        }
    }
    
    func setup(title: String, videoUrl: String) {
        titleLabel.text = title
    }
}
