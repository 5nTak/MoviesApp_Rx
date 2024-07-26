//
//  MyInfoCollectionHeader.swift
//  MoviesApp_Rx
//
//  Created by Tak on 7/2/24.
//

import UIKit
import SnapKit

final class MyInfoCollectionHeaderView: UICollectionReusableView {
    static let identifier = "MyInfoCollectionHeaderView"
    
    private let headerLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: .headline)
        label.textColor = .reversedBackgroundColorAsset
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .secondarySystemBackground
        addSubview(headerLabel)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        headerLabel.snp.makeConstraints {
            $0.top.leading.equalToSuperview().inset(30)
            $0.bottom.equalToSuperview()
        }
    }
    
    func setTitle(title: String) {
        headerLabel.text = title
    }
}
