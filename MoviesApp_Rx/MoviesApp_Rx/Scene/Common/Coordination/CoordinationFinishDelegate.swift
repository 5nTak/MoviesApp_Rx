//
//  CoordinationFinishDelegate.swift
//  MoviesApp_Rx
//
//  Created by Tak on 2024/01/09.
//

import Foundation

protocol CoordinationFinishDelegate: AnyObject {
    var childCoordinator: [Coordinator] { get set }
    
    func coordinationDidFinish(child: Coordinator)
}

extension CoordinationFinishDelegate {
    func coordinationDidFinish(child: Coordinator) {
        self.childCoordinator = self.childCoordinator.filter { $0.identifier != child.identifier}
    }
}
