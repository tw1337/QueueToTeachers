//
//  LoginField.swift
//  queuer
//
//  Created by Денис on 18/03/2019.
//  Copyright © 2019 Денис. All rights reserved.
//

import UIKit

@IBDesignable
class LoginField: UIView, UITextFieldDelegate {
    @IBOutlet var descriptionLabel: UILabel!
    @IBOutlet var textField: DesignableView!

    @IBInspectable var descriptionText: String? {
        get {
            return descriptionLabel.text
        }
        set {
            descriptionLabel.text = newValue
        }
    }

    var returnAction: (() -> Bool)?

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupFromNib()
        setup()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupFromNib()
        setup()
    }

    convenience init() {
        self.init(frame: .zero)
    }

    func setup() {
        textField.layer.cornerRadius = 20
        textField.layer.borderWidth = 3
        textField.layer.borderColor = UIColor.white.cgColor
        let leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: textField.frame.size.height))
        textField.leftView = leftView
        textField.leftViewMode = .always
        textField.delegate = self
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return returnAction?() ?? true
    }
}
