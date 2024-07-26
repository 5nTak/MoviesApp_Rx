//
//  SearchHeaderView.swift
//  MoviesApp_Rx
//
//  Created by Tak on 2024/02/22.
//

import UIKit
import SnapKit

final class SearchHeaderView: UICollectionReusableView {
    static let identifier = "SearchHeaderView"
    
    private let headerLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: .headline)
        label.textColor = .systemGray
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(headerLabel)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        headerLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(15)
            $0.leading.equalToSuperview().inset(30)
            $0.bottom.equalToSuperview()
        }
    }
    
    func configure(title: String) {
        headerLabel.text = title
    }
}
