//
//  AccountViewController.swift
//  MoviesApp_Rx
//
//  Created by Tak on 2024/02/07.
//

import UIKit

final class AccountViewController: UIViewController {
    var viewModel: AccountViewModel?
    
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
    
    private lazy var loginButton: UIButton = {
        let button = UIButton()
        button.setTitle(AccountViewString.login.rawValue, for: .normal)
        button.setTitleColor(.systemBackground, for: .normal)
        button.backgroundColor = .systemBlue
        button.layer.cornerRadius = 8
        button.addTarget(self, action: #selector(executeLogin), for: .touchUpInside)
        return button
    }()
    
    private lazy var forgetPasswordButton: UIButton = {
        let button = UIButton()
        button.setTitle(AccountViewString.findPassword.rawValue, for: .normal)
        button.setTitleColor(.systemBackground, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 15)
        button.backgroundColor = .systemGreen
        button.layer.cornerRadius = 10
//        button.addTarget(self, action: #selector(showResetPasswordVC), for: .touchUpInside)
        return button
    }()
    
    private lazy var joinButton: UIButton = {
        let button = UIButton()
        button.setTitle(AccountViewString.join.rawValue, for: .normal)
        button.setTitleColor(.systemBackground, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 15)
        button.titleLabel?.lineBreakMode = .byWordWrapping
        button.titleLabel?.textAlignment = .center
        button.backgroundColor = .systemGreen
        button.layer.cornerRadius = 10
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
            showAlert(message: AccountViewString.inputError.rawValue)
            return
        }
        
        viewModel?.login(email: email, password: password) { [weak self] result in
            switch result {
            case .success:
                self?.showAlert(message: AccountViewString.successLogin.rawValue) {
                    self?.viewModel?.coordinator?.showMyInfo()
                }
            case .failure(let error):
                self?.showAlert(message: "로그인 실패: \(error.localizedDescription)")
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigatonBar()
        setupLayout()
    }
    
    private func setupNavigatonBar() {
        navigationItem.title = AccountViewString.login.rawValue
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.reversedBackgroundColorAsset]
    }
    
    private func setupLayout() {
        view.backgroundColor = .systemBackground
        
        [
            idTextField,
            passwordTextField,
            loginButton,
            forgetPasswordButton,
            joinButton
        ].forEach {
            view.addSubview($0)
        }
        
        let spacing: CGFloat = 20
        idTextField.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(spacing)
            $0.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(8)
            $0.height.equalTo(40)
        }
        passwordTextField.snp.makeConstraints {
            $0.top.equalTo(idTextField.snp.bottom).offset(spacing)
            $0.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(8)
            $0.height.equalTo(40)
        }
        loginButton.snp.makeConstraints {
            $0.top.equalTo(passwordTextField.snp.bottom).offset(spacing * 2)
            $0.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(8)
            $0.height.equalTo(50)
        }
        forgetPasswordButton.snp.makeConstraints {
            $0.top.equalTo(loginButton.snp.bottom).offset(spacing * 2)
            $0.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(8)
            $0.height.equalTo(40)
        }
        joinButton.snp.makeConstraints {
            $0.top.equalTo(forgetPasswordButton.snp.bottom).offset(spacing)
            $0.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(8)
            $0.height.equalTo(40)
        }
    }
    
    @objc private func joinButtonTapped(_ sender: UIButton) {
        viewModel?.join()
    }
}
