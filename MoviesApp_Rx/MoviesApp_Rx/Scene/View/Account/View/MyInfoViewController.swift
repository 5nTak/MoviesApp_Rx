//
//  MyInfoViewController.swift
//  MoviesApp_Rx
//
//  Created by Tak on 7/2/24.
//

import UIKit

final class MyInfoViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupLayout()
    }
    
    private func setupLayout() {
        let label = UILabel()
        label.text = "My Info"
        label.textAlignment = .center
        label.textColor = .label
        label.font = .systemFont(ofSize: 24, weight: .bold)
        
        view.addSubview(label)
        
        label.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }
}
