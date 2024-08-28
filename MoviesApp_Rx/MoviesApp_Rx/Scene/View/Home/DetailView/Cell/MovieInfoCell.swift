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
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
}