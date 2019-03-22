//
//  LoginViewControllerGenerator.swift
//  queuer
//
//  Created by Денис on 18/03/2019.
//  Copyright © 2019 Денис. All rights reserved.
//

import Foundation
import UIKit

enum LoginType {
    case main, register, university
}

enum LoginViewBuilder {
    static func setup(_ viewController: LoginViewController, _ type: LoginType) {
        commonSetup(type, viewController)
        setupTextFields(type, viewController)
        setupStack(viewController)
        setupConnectionsInTextFields(viewController)
        viewController.view.layoutIfNeeded()
    }

    private static func setupStack(_ viewController: LoginViewController) {
        let fieldCount = viewController.fieldStack.arrangedSubviews.count
        let fieldHeight = 100
        viewController.stackHeight.constant = CGFloat(fieldCount * fieldHeight)
    }

    private static func commonSetup(_ type: LoginType, _ viewController: LoginViewController) {
        let addView = viewController.fieldStack.addArrangedSubview
        if type != .university {
            addView(generateField("Имя пользователя"))
            addView(generateField("Пароль", true))
        }
        if type != .main {
            viewController.registerInfoStack.isHidden = true
            viewController.imageWidth.isActive = false
            NSLayoutConstraint(item: viewController.imageView, attribute: .width, relatedBy: .equal, toItem: viewController.imageView?.superview, attribute: .width, multiplier: 0.4, constant: 0).isActive = true
        }
    }

    private static func setupTextFields(_ type: LoginType, _ viewController: LoginViewController) {
        let addView = viewController.fieldStack.addArrangedSubview
        switch type {
        case .main:
            viewController.titleLabel.text = "Вход".uppercased()
            viewController.actionButton.title = "Войти".uppercased()
            viewController.backButton.isHidden = true
        case .register:
            viewController.titleLabel.text = "Регистрация".uppercased()
            addView(generateField("Почта"))
            viewController.actionButton.title = "Далее".uppercased()
        case .university:
            viewController.titleLabel.text = "Выбор группы".uppercased()
            addView(generateField("Группа"))
            viewController.actionButton.title = "Создать".uppercased()
        }
    }

    private static func setupConnectionsInTextFields(_ viewController: LoginViewController) {
        let fields = viewController.fieldStack.arrangedSubviews.compactMap { $0 as? LoginField }
        for (index, field) in fields.enumerated() {
            if index < fields.count - 1 {
                field.returnAction = {
                    fields[index + 1].textField.becomeFirstResponder()
                    return false
                }
            } else {
                field.returnAction = {
                    viewController.didButtonTap()
                    return true
                }
            }
        }
    }

    private static func generateField(_ description: String, _ isSecure: Bool = false) -> LoginField {
        let field = LoginField()
        field.descriptionText = description.uppercased()
        field.textField.isSecureTextEntry = isSecure
        return field
    }
}
