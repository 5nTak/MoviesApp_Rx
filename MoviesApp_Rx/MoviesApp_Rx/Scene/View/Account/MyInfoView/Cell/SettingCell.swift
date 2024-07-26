//
//  SettingCell.swift
//  MoviesApp_Rx
//
//  Created by Tak on 7/2/24.
//

import UIKit
import SnapKit

final class SettingCell: UICollectionViewCell {
    static let identifier = "SettingCell"
    
    let logoutButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .white
        button.setTitleColor(.systemRed, for: .normal)
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
        contentView.backgroundColor = .white
        contentView.layer.borderColor = UIColor.systemGray5.cgColor
        contentView.layer.borderWidth = 1
        
        [
            logoutButton
        ].forEach { contentView.addSubview($0) }
        
        logoutButton.snp.makeConstraints {
            $0.top.leading.trailing.bottom.equalToSuperview()
        }
    }
    
    func setLogoutButton() {
        logoutButton.setTitle("Sign out", for: .normal)
    }
}
