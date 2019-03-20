//
//  LoginButton.swift
//  queuer
//
//  Created by Денис on 18/03/2019.
//  Copyright © 2019 Денис. All rights reserved.
//

import UIKit

@IBDesignable
class LoginButton: UIView {

    @IBOutlet weak var button: UIButton!
    
    var action: (() -> ())?
    
    
    @IBInspectable
    var title: String {
        get {
            return button.title(for: .normal) ?? ""
        }
        set {
            button.setTitle(newValue, for: .normal)
        }
    }
    
    @IBAction func didTap(_ sender: Any) {
        action?()
    }
    
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
    
    convenience init(){
        self.init(frame: .zero)
    }
    
    func setup(){
        button.layer.cornerRadius = 20
    }

}
