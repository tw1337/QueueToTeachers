//
//  LoginViewGenerator.swift
//  queuer
//
//  Created by Денис on 19/03/2019.
//  Copyright © 2019 Денис. All rights reserved.
//

import Foundation

enum LoginViewGenerator {
    static func instance(_ type: LoginType, _ handler: @escaping ([String: String]) -> Void, _ registerHandler: (() -> Void)? = nil) -> LoginViewController {
        let viewController = LoginViewController.storyboardInstance()!
        viewController.type = type
        viewController.buttonHandler = handler
        viewController.registerHandler = registerHandler
        return viewController
    }
}
