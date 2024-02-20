//
//  Coordinator.swift
//  MoviesApp_Rx
//
//  Created by Tak on 2024/01/09.
//

import Foundation
import UIKit

protocol Coordinator: AnyObject {
    var childCoordinator: [Coordinator] { get set }
    var finishDelegate: CoordinationFinishDelegate? { get }
    var navigationController: UINavigationController? { get set }
    var identifier: UUID { get }
    
    func start()
    func finish()
}

extension Coordinator {
    func finish() {
        self.childCoordinator.removeAll()
        self.finishDelegate?.coordinationDidFinish(child: self)
    }
}
