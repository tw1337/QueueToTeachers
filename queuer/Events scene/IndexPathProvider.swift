//
//  IndexPathProvider.swift
//  queuer
//
//  Created by Денис on 26/03/2019.
//  Copyright © 2019 Денис. All rights reserved.
//

import Foundation
import UIKit

struct IndexPathProvider {
    var tableView: UITableView
    var datePickerIndexPath: IndexPath?

    init(tableView: UITableView) {
        self.tableView = tableView
    }

    var nameIndexPath: IndexPath? {
        return tableView.indexPath(of: EditableTableViewCell.self)
    }

    var dateIndexPath: IndexPath? {
        return tableView.indexPath(of: DateTableViewCell.self)
    }

    var bigCellIndexPath: IndexPath? {
        return tableView.indexPath(of: BigTextTableViewCell.self)
    }

    var buttonIndexPath: IndexPath? {
        return tableView.indexPath(of: ButtonTableViewCell.self)
    }

    var usernameIndexPath: IndexPath? {
        let username = UserDefaults.standard.string(forKey: "username")
        guard username != nil else { return nil }
        let condition: ((UITableViewCell) -> Bool) = { $0.textLabel?.text == username }
        return tableView.indexPath(of: UITableViewCell.self, condition)
    }
}

fileprivate extension UITableView {
    func indexPath<T>(of type: T.Type, _ condition: ((UITableViewCell) -> Bool)? = nil) -> IndexPath? {
        for section in 0 ..< numberOfSections {
            for row in 0 ..< numberOfRows(inSection: section) {
                let indexPath = IndexPath(row: row, section: section)
                let cell = cellForRow(at: indexPath)
                if cell is T, condition?(cell!) ?? true {
                    return indexPath
                }
            }
        }
        return nil
    }
}
