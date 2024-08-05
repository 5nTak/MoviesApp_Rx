//
//  AccountViewController.swift
//  MoviesApp_Rx
//
//  Created by Tak on 2024/02/07.
//

import UIKit
import SnapKit

final class AccountViewController: UIViewController {
    var viewModel: AccountViewModel?
    
    private let tmdbImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "tmdb_icon")
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    private let idTextField: LoginTextFiled = {
        let textField = LoginTextFiled()
        textField.borderStyle = .none
        textField.textColor = .reversedBackgroundColorAsset
        textField.keyboardType = .emailAddress
        return textField
    }()
    private let passwordTextField: LoginTextFiled = {
        let textField = LoginTextFiled()
        textField.borderStyle = .none
        textField.textColor = .reversedBackgroundColorAsset
        textField.isSecureTextEntry = true
        return textField
    }()
    private lazy var signInButton: UIButton = {
        let button = UIButton()
        button.setTitle(AccountViewString.signIn.rawValue, for: .normal)
        button.setTitleColor(.systemBlue, for: .normal)
        button.backgroundColor = .white
        button.addTarget(self, action: #selector(executeLogin), for: .touchUpInside)
        return button
    }()
    private lazy var signUpButton: UIButton = {
        let button = UIButton()
        button.setTitle(AccountViewString.signUp.rawValue, for: .normal)
        button.setTitleColor(.systemBlue, for: .normal)
        button.backgroundColor = .white
        button.addTarget(self, action: #selector(joinButtonTapped(_:)), for: .touchUpInside)
        return button
    }()
    
    init() {
        idTextField.setupPlaceholder(placeholder: AccountViewString.id.rawValue, placeColor: .systemGray)
        passwordTextField.setupPlaceholder(placeholder: AccountViewString.password.rawValue, placeColor: .systemGray)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc private func executeLogin() {
        view.endEditing(true)
        
        guard let email = idTextField.text, !email.isEmpty,
              let password = passwordTextField.text, !password.isEmpty else {
            idTextField.setError()
            passwordTextField.setError()
            showAlert(message: AccountViewString.inputError.rawValue)
            return
        }
        
        viewModel?.signIn(email: email, password: password) { [weak self] result in
            switch result {
            case .success:
                self?.showAlert(message: AccountViewString.successLogin.rawValue) {
                    self?.viewModel?.coordinator?.showMyInfo(email: email)
                }
            case .failure(let error):
                self?.idTextField.setError()
                self?.passwordTextField.setError()
                self?.showAlert(message: "Login failed: \(error.localizedDescription)")
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupLayout()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setupNavigationBar()
    }
    
    private func setupNavigationBar() {
        self.title = AccountViewString.account.rawValue
        
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .white
        appearance.shadowColor = .lightGray
        
        UINavigationBar.appearance().standardAppearance = appearance
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
    }
    
//    private func setupNavigatonBar() {
//        navigationItem.title = AccountViewString.account.rawValue
//    }
    
    private func setupLayout() {
        view.backgroundColor = .systemGray6
        
        [
            tmdbImageView,
            idTextField,
            passwordTextField,
            signInButton,
            signUpButton
        ].forEach {
            view.addSubview($0)
        }
        
        let buttonHeight: CGFloat = 45
        
        tmdbImageView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(50)
            $0.centerX.equalToSuperview()
        }
        idTextField.snp.makeConstraints {
            $0.top.equalTo(tmdbImageView.snp.bottom).offset(50)
            $0.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(10)
            $0.height.equalTo(40)
        }
        passwordTextField.snp.makeConstraints {
            $0.top.equalTo(idTextField.snp.bottom).offset(30)
            $0.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(10)
            $0.height.equalTo(40)
        }
        signInButton.snp.makeConstraints {
            $0.top.equalTo(passwordTextField.snp.bottom).offset(50)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(buttonHeight)
        }
        signUpButton.snp.makeConstraints {
            $0.top.equalTo(signInButton.snp.bottom).offset(20)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(buttonHeight)
        }
    }
    
    @objc private func joinButtonTapped(_ sender: UIButton) {
        viewModel?.signUp()
    }
}
