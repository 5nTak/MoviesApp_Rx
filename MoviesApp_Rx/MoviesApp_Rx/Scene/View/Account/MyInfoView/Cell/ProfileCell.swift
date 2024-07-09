//
//  ProfileCell.swift
//  MoviesApp_Rx
//
//  Created by Tak on 7/2/24.
//

import UIKit
import SnapKit

final class ProfileCell: UICollectionViewCell {
    static let identifier = "ProfileCell"
    
    private let profileImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "person.fill")
        return imageView
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: .title1)
        return label
    }()
    
    private let emailLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: .title3)
        return label
    }()
    
    private let editButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "pencil"), for: .normal)
        return button
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
            profileImage,
            emailLabel,
            editButton
        ].forEach { contentView.addSubview($0) }
        
        profileImage.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(20)
            $0.top.bottom.equalToSuperview()
            $0.height.equalToSuperview()
            $0.width.equalTo(profileImage.snp.height)
        }
        
        emailLabel.snp.makeConstraints {
            $0.leading.equalTo(profileImage.snp.trailing).offset(20)
            $0.centerY.equalToSuperview()
        }
        
        editButton.snp.makeConstraints {
            $0.leading.equalTo(emailLabel.snp.trailing).offset(10)
            $0.trailing.equalToSuperview().inset(20)
            $0.centerY.equalToSuperview()
            $0.height.equalToSuperview().dividedBy(2)
            $0.width.equalTo(editButton.snp.height)
        }
        
        profileImage.layer.cornerRadius = 40
        profileImage.layer.masksToBounds = true
        profileImage.layer.borderWidth = 1
        profileImage.layer.borderColor = UIColor.white.cgColor
    }
    
    func setup(email: String) {
        emailLabel.text = email
    }
}
