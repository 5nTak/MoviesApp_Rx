//
//  LoginTextField.swift
//  MoviesApp_Rx
//
//  Created by Tak on 2024/02/07.
//

import UIKit

final class LoginTextFiled: UITextField {
    lazy var placeholderColor: UIColor = self.tintColor
    var placeholderString = ""
    
    private lazy var underLineView: UIView = {
        let lineView: UIView = UIView()
        lineView.backgroundColor = .systemBackground
        
        return lineView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(underLineView)
        
        underLineView.snp.makeConstraints {
            $0.top.equalTo(self.snp.bottom)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(1)
        }
        
        self.addTarget(self, action: #selector(beganEditing), for: .editingDidBegin)
        self.addTarget(self, action: #selector(endedEditing), for: .editingDidEnd)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupPlaceholder(placeholder: String, placeColor: UIColor) {
        placeholderString = placeholder
        placeholderColor = placeColor
        
        setupPlaceholder()
        underLineView.backgroundColor = placeholderColor
    }
    
    private func setupPlaceholder() {
        self.attributedPlaceholder = NSAttributedString(
            string: placeholderString,
            attributes: [NSAttributedString.Key.foregroundColor: placeholderColor]
        )
    }
    
    func setError() {
        self.attributedPlaceholder = NSAttributedString(
            string: placeholderString,
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.systemRed]
        )
        
        self.textColor = .systemRed
        underLineView.backgroundColor = .systemRed
        
        shakeTextField(textField: self)
    }
    
    private func shakeTextField(textField: UITextField) -> Void{
        UIView.animate(withDuration: 0.2, animations: {
            textField.frame.origin.x -= 10
        }, completion: { _ in
            UIView.animate(withDuration: 0.2, animations: {
                textField.frame.origin.x += 20
            }, completion: { _ in
                UIView.animate(withDuration: 0.2, animations: {
                    textField.frame.origin.x -= 10
                })
            })
        })
    }
}

extension LoginTextFiled {
    @objc func beganEditing() {
        self.textColor = .systemGray
        underLineView.backgroundColor = self.tintColor
    }
    
    @objc func endedEditing() {
        underLineView.backgroundColor = placeholderColor
    }
}
