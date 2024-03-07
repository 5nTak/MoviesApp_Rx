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
        textField.tintColor = .black
        textField.textColor = .black
        textField.keyboardType = .emailAddress
        return textField
    }()
    
    private let passwordTextField: LoginTextFiled = {
        let textField = LoginTextFiled()
        textField.borderStyle = .none
        textField.tintColor = .black
        textField.textColor = .black
        textField.isSecureTextEntry = true
        return textField
    }()
    
    private lazy var loginButton: UIButton = {
        let button = UIButton()
        button.setTitle(AccountViewString.login.rawValue, for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .systemBlue
        button.layer.cornerRadius = 8
        button.addTarget(self, action: #selector(executeLogin), for: .touchUpInside)
        
        return button
    }()
    
    private lazy var forgetPasswordButton: UIButton = {
        let button = UIButton()
        button.setTitle(AccountViewString.findPassword.rawValue, for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 15)
        button.backgroundColor = .systemGreen
        button.layer.cornerRadius = 10
//        button.addTarget(self, action: #selector(showResetPasswordVC), for: .touchUpInside)
        
        return button
    }()
    
    private lazy var joinButton: UIButton = {
        let button = UIButton()
        button.setTitle(AccountViewString.join.rawValue, for: .normal)
        button.setTitleColor(.black, for: .highlighted)
        button.titleLabel?.font = .systemFont(ofSize: 15)
        button.titleLabel?.lineBreakMode = .byWordWrapping
        button.titleLabel?.textAlignment = .center
        button.backgroundColor = .systemGreen
        button.layer.cornerRadius = 10
//        button.addTarget(self, action: #selector(showJoinVC), for: .touchUpInside)
        
        return button
    }()
    
    init() {
        idTextField.setupPlaceholder(placeholder: AccountViewString.id.rawValue, color: .lightGray)
        passwordTextField.setupPlaceholder(placeholder: AccountViewString.password.rawValue, color: .lightGray)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc private func executeLogin() {
        view.endEditing(true)
        
        let title = AccountViewString.loginResult.rawValue
        var message = AccountViewString.successLogin.rawValue
        
        if idTextField.text?.isEmpty ?? true {
            idTextField.setError()
            message = AccountViewString.inputError.rawValue
        }
        
        if passwordTextField.text?.isEmpty ?? true {
            passwordTextField.setError()
            message = AccountViewString.inputError.rawValue
        }
        
        let loginResultAlert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let successAction = UIAlertAction(title: "ok", style: .default)
        loginResultAlert.addAction(successAction)
        present(loginResultAlert, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigatonBar()
        setupLayout()
    }
    
    private func setupNavigatonBar() {
        navigationItem.title = AccountViewString.login.rawValue
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black]
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
}

