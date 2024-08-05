//
//  SearchBarView.swift
//  MoviesApp_Rx
//
//  Created by Tak on 2024/02/22.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class SearchBarView: UIView {
    var searchTextField = UITextField()
    private let containerView = UIView()
    private let searchStackView = UIStackView()
    private let searchIconView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "magnifyingglass.circle")
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureSubviews()
        configureHierarchy()
        configureLayout()
        setSearchTextFieldPlaceholder()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setSearchTextFieldPlaceholder() {
        let placeholder = "Search Movies, Collections"
        searchTextField.attributedPlaceholder = NSMutableAttributedString(string: placeholder)
    }
    
    private func stackViewLayout() {
        searchStackView.insertArrangedSubview(searchTextField, at: 1)
        searchTextField.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
    }
    
    private func configureSubviews() {
        configureContainerView()
        configureSearchStackView()
        configureSearchTextField()
    }
    
    private func configureContainerView() {
        containerView.layer.masksToBounds = true
        containerView.layer.cornerRadius = 10
        containerView.backgroundColor = .systemGray6
    }
    
    private func configureSearchStackView() {
        searchStackView.axis = .horizontal
        searchStackView.alignment = .fill
        searchStackView.spacing = 10
    }
    
    private func configureSearchTextField() {
        searchTextField.isUserInteractionEnabled = true
        searchTextField.autocorrectionType = .no
        searchTextField.spellCheckingType = .no
        searchTextField.autocapitalizationType = .none
        searchTextField.clearButtonMode = .whileEditing
        searchTextField.clearsOnBeginEditing = false
        searchTextField.returnKeyType = .search
        searchTextField.keyboardType = .default
    }
    
    private func configureHierarchy() {
        addSubview(containerView)
        containerView.addSubview(searchStackView)
        [searchIconView, searchTextField].forEach { searchStackView.addArrangedSubview($0) }
    }
    
    private func configureLayout() {
        containerView.snp.makeConstraints {
            $0.top.bottom.equalToSuperview().inset(5)
            $0.leading.trailing.equalToSuperview().inset(18)
        }
        
        searchStackView.snp.makeConstraints {
            $0.top.bottom.equalToSuperview().inset(5)
            $0.leading.trailing.equalToSuperview().inset(12)
        }
        
        searchIconView.snp.makeConstraints {
            $0.width.equalTo(searchIconView.snp.height)
        }
    }
}

extension Reactive where Base: SearchBarView {
    var textDidChange: Observable<String> {
        return base.searchTextField.rx.text
            .changed
            .compactMap { $0 }
            .debounce(.milliseconds(300), scheduler: MainScheduler.asyncInstance)
    }
}
