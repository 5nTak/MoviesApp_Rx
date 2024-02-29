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
        textField.tintColor = .white
        textField.textColor = .white
        textField.keyboardType = .emailAddress
        return textField
    }()
    
    private let passwordTextField: LoginTextFiled = {
        let textField = LoginTextFiled()
        textField.borderStyle = .none
        textField.tintColor = .white
        textField.textColor = .white
        textField.isSecureTextEntry = true
        return textField
    }()
    
    private lazy var loginButton: UIButton = {
        let button = UIButton()
        button.setTitle(AccountViewString.login.rawValue, for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.backgroundColor = .white
        button.layer.cornerRadius = 8
        button.addTarget(self, action: #selector(executeLogin), for: .touchUpInside)
        
        return button
    }()
    
    private lazy var forgetPasswordButton: UIButton = {
        let button = UIButton()
        button.setTitle("find_password", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 15)
//        button.addTarget(self, action: #selector(showResetPasswordVC), for: .touchUpInside)
        
        return button
    }()
    
    private lazy var joinButton: UIButton = {
        let button = UIButton()
        button.setTitle("join", for: .normal)
        button.setTitleColor(.lightGray, for: .highlighted)
        button.titleLabel?.font = .systemFont(ofSize: 15)
        button.titleLabel?.lineBreakMode = .byWordWrapping
        button.titleLabel?.textAlignment = .center
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
        
        let title = "login_result"
        var message = "login_result_message"
        
        if idTextField.text?.isEmpty ?? true {
            idTextField.setError()
            message = "input_error_message"
        }
        
        if passwordTextField.text?.isEmpty ?? true {
            passwordTextField.setError()
            message = "input_error_message"
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
        navigationItem.title = "Login"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
    }
    
    private func setupLayout() {
        view.backgroundColor = .black
        
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
            $0.top.equalTo(passwordTextField.snp.bottom).offset(spacing)
            $0.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(8)
            $0.height.equalTo(50)
        }
        
        forgetPasswordButton.snp.makeConstraints {
            $0.top.equalTo(loginButton.snp.bottom).offset(spacing)
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

