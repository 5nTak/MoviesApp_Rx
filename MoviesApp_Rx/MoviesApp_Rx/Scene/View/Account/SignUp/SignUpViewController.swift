//
//  SignUpViewController.swift
//  MoviesApp_Rx
//
//  Created by Tak on 6/28/24.
//

import UIKit
import SnapKit

final class SignUpViewController: UIViewController {
    var viewModel: SignUpViewModel?
    private let emailTextField: LoginTextFiled = {
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
        textField.textContentType = .oneTimeCode
        return textField
    }()
    private lazy var signUpButton: UIButton = {
        let button = UIButton()
        button.setTitle(AccountViewString.signUp.rawValue, for: .normal)
        button.setTitleColor(.systemBackground, for: .normal)
        button.backgroundColor = .systemBlue
        button.layer.cornerRadius = 8
        button.addTarget(self, action: #selector(executeSignUp), for: .touchUpInside)
        return button
    }()
    
    init(viewModel: SignUpViewModel) {
        self.viewModel = viewModel
        emailTextField.setupPlaceholder(placeholder: AccountViewString.email.rawValue, placeColor: .systemGray)
        passwordTextField.setupPlaceholder(placeholder: AccountViewString.password.rawValue, placeColor: .systemGray)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
    }
    
    private func setupLayout() {
        view.backgroundColor = .systemBackground
        
        [emailTextField, passwordTextField, signUpButton].forEach {
            view.addSubview($0)
        }
        
        let spacing: CGFloat = 20
        emailTextField.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(spacing)
            $0.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(8)
            $0.height.equalTo(40)
        }
        passwordTextField.snp.makeConstraints {
            $0.top.equalTo(emailTextField.snp.bottom).offset(spacing)
            $0.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(8)
            $0.height.equalTo(40)
        }

        signUpButton.snp.makeConstraints {
            $0.top.equalTo(passwordTextField.snp.bottom).offset(spacing * 2)
            $0.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(8)
            $0.height.equalTo(50)
        }
    }
    
    @objc private func executeSignUp() {
        guard let email = emailTextField.text, !email.isEmpty,
              let password = passwordTextField.text, !password.isEmpty else {
            emailTextField.setError()
            passwordTextField.setError()
            showAlert(message: AccountViewString.inputError.rawValue)
            return
        }
        
        viewModel?.signUp(email: email, password: password) { [weak self] result in
            switch result {
            case .success(let userId):
                self?.showAlert(message: "Successfully signed up!") {
                    self?.navigationController?.popViewController(animated: true)
                }
            case .failure(let error):
                if error.localizedDescription == "The email address is badly formatted." || error.localizedDescription == "The email address is already in use by another account." {
                    self?.emailTextField.setError()
                } else if error.localizedDescription == "The password must be 6 characters long or more." {
                    self?.passwordTextField.setError()
                }
                self?.showAlert(message: "Failed to sign up: \(error.localizedDescription)")
            }
        }
    }
}
