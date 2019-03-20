//
//  UIViewController+Storyboard.swift
//  queuer
//
//  Created by Денис on 18/03/2019.
//  Copyright © 2019 Денис. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    private class func storyboardInstancePrivate<T: UIViewController>() -> T? {
        let storyboard = UIStoryboard(name: String(describing: self), bundle: nil)
        return storyboard.instantiateInitialViewController() as? T
    }
    
    class func storyboardInstance() -> Self? {
        return storyboardInstancePrivate()
    }
}
