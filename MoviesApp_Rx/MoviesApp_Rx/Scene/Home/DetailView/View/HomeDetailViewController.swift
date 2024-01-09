//
//  HomeDetailViewController.swift
//  MoviesApp_Rx
//
//  Created by Tak on 2024/01/09.
//

import UIKit

final class DetailViewController: UIViewController {
    var viewModel: DetailViewModel?
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        
        return label
    }()
    private let posterView: UIImageView = {
        let imageView = UIImageView()
        
        return imageView
    }()
    private let overViewLabel: UILabel = {
        let label = UILabel()
        
        return label
    }()
    private let releaseDateLabel: UILabel = {
        let label = UILabel()
        
        return label
    }()
    private let voteAverageLabel: UILabel = {
        let label = UILabel()
        
        return label
    }()
    private let voteCountLabel: UILabel = {
        let label = UILabel()
        
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    private func setupUI() {
        
    }
    
    private func bindViewModel() {
        
    }
}
