//
//  UIViewController+extension.swift
//  MoviesApp_Rx
//
//  Created by Tak on 7/2/24.
//

import UIKit

extension UIViewController {
    func showAlert(message: String, completion: (() -> Void)? = nil) {
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        let successAction = UIAlertAction(title: "ok", style: .default) { _ in
            completion?()
        }
        alert.addAction(successAction)
        present(alert, animated: true)
    }
}
