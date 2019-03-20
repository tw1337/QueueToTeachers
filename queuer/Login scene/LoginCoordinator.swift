//
//  Coordinator.swift
//  queuer
//
//  Created by Денис on 18/03/2019.
//  Copyright © 2019 Денис. All rights reserved.
//

import Foundation
import UIKit

class LoginCoordinator: Coordinator {
    // MARK: - Properties

    var childCoordinators: [Coordinator]?

    private weak var navigationController: UINavigationController?

    var completenceCallback: (() -> Void)?

    // MARK: - Init

    required init(_ navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func start() {
        showMainLoginView()
    }

    private func showMainLoginView() {
        navigationController?.pushViewController(getLoginViewController(.main), animated: true)
    }

    private func showRegisterView() {
        navigationController?.pushViewController(getLoginViewController(.register), animated: true)
    }

    private func showUniView() {
        navigationController?.pushViewController(getLoginViewController(.university), animated: true)
    }

    private func didLogin() {
        completenceCallback?()
    }

    private func getLoginViewController(_ type: LoginType) -> LoginViewController {
        let handler = getHandler(type)
        let registrationHandler = type == LoginType.main ?
            { self.showRegisterView() } : nil
        return LoginViewGenerator.instance(type, handler, registrationHandler)
    }
    
    private func getHandler(_ type: LoginType) -> ([String: String]) -> Void {
        switch type {
        case .main:
            return {
                self.processLogin($0)
                self.didLogin()
            }
        case .register:
            return {
                self.processInfo($0)
                self.showUniView()
            }
        case .university:
            return {
                self.processInfo($0)
                self.didLogin()
            }
        }
    }

    private func processLogin(_ info: [String: String]) {
        dump(info)
    }

    private func processInfo(_ info: [String: String]) {
        dump(info)
    }

    // MARK: - Private implementation
}
