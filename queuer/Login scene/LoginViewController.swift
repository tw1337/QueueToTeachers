//
//  ViewController.swift
//  queuer
//
//  Created by Денис on 18/03/2019.
//  Copyright © 2019 Денис. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    @IBOutlet var stackHeight: NSLayoutConstraint!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var imageWidth: NSLayoutConstraint!
    @IBOutlet var fieldStack: UIStackView!
    @IBOutlet var registerInfoStack: UIStackView!
    @IBOutlet var actionButton: LoginButton!

    @IBOutlet weak var backButton: UIButton!
    @IBAction func didRegisterTap(_ sender: Any) {
        registerHandler?()
    }

    @IBAction func didBackTap(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    @IBAction func didTap(_ sender: Any) {
        view.endEditing(true)
    }

    var type: LoginType!
    var registerHandler: (() -> Void)?
    var buttonHandler: (([String: String]) -> Void)?
    var shouldMoveViewOnKeyboard: Bool?

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return UIStatusBarStyle.lightContent
    }

    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.layerGradient()
        actionButton.action = didButtonTap
        LoginViewBuilder.setup(self, type)

        shouldMoveViewOnKeyboard = (view.frame.size.height / 3) < 250

        if shouldMoveViewOnKeyboard! {
            NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
            NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        }
    }

    func didButtonTap() {
        var strings: [String: String] = [:]
        fieldStack.arrangedSubviews.compactMap { $0 as? LoginField }.forEach {
            strings[$0.descriptionText!] = $0.textField.text ?? ""
        }

        buttonHandler?(strings)
    }

    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if view.frame.origin.y == 0 {
                view.frame.origin.y -= 180
            }
        }
    }

    @objc func keyboardWillHide(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if view.frame.origin.y != 0 {
                view.frame.origin.y += 180
            }
        }
    }
}
