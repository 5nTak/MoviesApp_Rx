//
//  RecentlyMoviesCell.swift
//  MoviesApp_Rx
//
//  Created by Tak on 9/18/24.
//

import UIKit
import SnapKit
import RxSwift

final class RecentlyMoviesCell: UICollectionViewCell {
    static let identifier = "RecentlyMoviesCell"
    private var disposeBag = DisposeBag()
    
    private let checkBoxButton: UIButton = {
        let button = UIButton(type: .custom)
        button.backgroundColor = .white
        button.setImage(UIImage(systemName: "square"), for: .normal)
        button.setImage(UIImage(systemName: "checkmark.square"), for: .selected)
        button.isHidden = true
        button.isUserInteractionEnabled = true
        return button
    }()
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.tintColor = .systemGray
        imageView.contentMode = .scaleAspectFit
        imageView.kf.indicatorType = .activity
        return imageView
    }()
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .reversedBackgroundColorAsset
        label.font = .systemFont(ofSize: 15, weight: .bold)
        label.sizeToFit()
        label.textAlignment = .center
        label.numberOfLines = 1
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.kf.cancelDownloadTask()
        imageView.image = nil
        titleLabel.text = nil
        checkBoxButton.isHidden = true
        checkBoxButton.isSelected = false
        disposeBag = DisposeBag()
    }
    
    private func configureLayout() {
        contentView.backgroundColor = .tertiarySystemBackground
        contentView.layer.cornerRadius = 10
        contentView.layer.masksToBounds = true
        
        [
            imageView,
            titleLabel,
            checkBoxButton
        ].forEach { contentView.addSubview($0) }
        
        imageView.snp.makeConstraints {
            $0.top.horizontalEdges.equalToSuperview()
            $0.centerX.equalToSuperview()
            $0.height.equalToSuperview().multipliedBy(0.9)
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(imageView.snp.bottom)
            $0.horizontalEdges.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
        
        checkBoxButton.snp.makeConstraints {
            $0.top.trailing.equalToSuperview().inset(12)
            $0.width.height.equalTo(24)
        }
        checkBoxButton.layer.cornerRadius = 10
        
        imageView.layer.cornerRadius = 50
    }
    
    func configure(title: String) {
        titleLabel.text = title
    }
    
    func loadImage(url: String) {
        let urlString = imageView.imageBaseUrl + imageView.imageSize + url
        
        imageView.setImageCache(with: urlString)
    }
    
    func setFailedLoadImage() {
        imageView.image = UIImage(named: "noImageProvided")
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
    }
    
    func showCheckBox(isVisible: Bool) {
        checkBoxButton.isHidden = !isVisible
    }
    
    func updateCheckBox(isSelected: Bool) {
        checkBoxButton.isSelected = isSelected
    }
    
    func bindCheckBoxTap(movieId: Int, viewModel: SearchViewModel) {
        checkBoxButton.rx.tap
            .subscribe(onNext: { [weak self] in
                viewModel.toggleSelection(movieId: movieId)
            })
            .disposed(by: disposeBag)
    }
}
