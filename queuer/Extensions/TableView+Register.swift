//
//  TableView+Register.swift
//  queuer
//
//  Created by Денис on 20/03/2019.
//  Copyright © 2019 Денис. All rights reserved.
//

import Foundation
import UIKit

extension UITableView {
    func register(_ cell: UITableViewCell.Type) {
        let describingString = String(describing: cell.self)
        let nib = UINib(nibName: describingString, bundle: nil)
        register(nib, forCellReuseIdentifier: describingString)
    }
}
