//
//  MainCoordinator.swift
//  queuer
//
//  Created by Денис on 20/03/2019.
//  Copyright © 2019 Денис. All rights reserved.
//

import Foundation
import UIKit

protocol Coordinator {
    func start()
    var childCoordinators: [Coordinator]? { get set }
    var completenceCallback: (() -> Void)? { get set }
    init(_ navigationController: UINavigationController)
}

class MainCoordinator: Coordinator {
    private weak var navigationController: UINavigationController?

    var completenceCallback: (() -> Void)?

    var childCoordinators: [Coordinator]?

    required init(_ navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func start() {
        showNext()
    }

    func showNext() {
        var childCoordinator = childCoordinators?.popLast()
        childCoordinator?.completenceCallback = showNext
        childCoordinator?.start() 
    }
}
