//
//  UIView+nib.swift
//  queuer
//
//  Created by Денис on 18/03/2019.
//  Copyright © 2019 Денис. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
    func setupFromNib() {
        
        let nib = UINib(nibName: nibName, bundle: nil)
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        view.frame = bounds
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        addSubview(view)
    }
    
    var nibName: String {
        let describingString = String(describing: self)
        let nibName = describingString.split(separator: ".")[1].prefix { $0 != ":" }
        return String(nibName)
    }
}

