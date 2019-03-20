//
//  Colors.swift
//  queuer
//
//  Created by Денис on 18/03/2019.
//  Copyright © 2019 Денис. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
    func layerGradient() {
        let layer = CAGradientLayer()
        layer.frame.size = frame.size
        layer.frame.origin = CGPoint(x: 0.0, y: 0.0)

        let color0 = UIColor(red: 48.0 / 255, green: 106.0 / 255, blue: 255.0 / 255, alpha: 1).cgColor
        let color1 = UIColor(red: 0.0 / 255, green: 141.0 / 255, blue: 228.0 / 255, alpha: 1).cgColor

        layer.colors = [color0, color1]
        self.layer.insertSublayer(layer, at: 0)
    }
}
