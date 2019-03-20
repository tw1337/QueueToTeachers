//
//  UITextField+IBDesignable.swift
//  queuer
//
//  Created by Денис on 18/03/2019.
//  Copyright © 2019 Денис. All rights reserved.
//

import Foundation
import UIKit

@IBDesignable
class DesignableView: UITextField {
    
    @IBInspectable var cornerRadius: CGFloat = 0 {
        didSet {
            self.layer.cornerRadius = cornerRadius
            self.layer.masksToBounds = true
        }
    }
    
    @IBInspectable var borderWidth: CGFloat = 0 {
        didSet {
            self.layer.borderWidth = borderWidth
        }
    }
    
    @IBInspectable var borderColor: UIColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1) {
        didSet {
            self.layer.borderColor = borderColor.cgColor
        }
    }
    
}
