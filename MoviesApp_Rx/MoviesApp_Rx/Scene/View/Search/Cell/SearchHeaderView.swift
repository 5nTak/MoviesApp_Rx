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
        label.font = .systemFont(ofSize: 20, weight: .bold)
        label.textColor = .darkGray
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
            $0.edges.equalToSuperview().inset(5)
        }
    }
    
    func configure(title: String) {
        headerLabel.text = title
    }
}
