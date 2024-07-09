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
        button.backgroundColor = .systemBlue
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
            logoutButton
        ].forEach { contentView.addSubview($0) }
        
        logoutButton.snp.makeConstraints {
            $0.top.leading.trailing.bottom.equalToSuperview().inset(10)
        }
        
        logoutButton.layer.cornerRadius = 10
    }
    
    func setLogoutButton() {
        logoutButton.setTitle("로그아웃", for: .normal)
    }
}
