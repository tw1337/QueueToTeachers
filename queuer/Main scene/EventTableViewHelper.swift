//
//  EventTableViewDelegate.swift
//  queuer
//
//  Created by Денис on 25/03/2019.
//  Copyright © 2019 Денис. All rights reserved.
//

import Foundation
import UIKit

class EventTableContext {
    var context: (IndexPath?, IndexPath?, IndexPath?, IndexPath?, IndexPath?, [EventCellType]?, [Groupmate]?)
}

class EventTableViewHelper: NSObject {
    var nameIndexPath: IndexPath?
    var dateIndexPath: IndexPath?
    var datePickerIndexPath: IndexPath?
    var bigCellIndexPath: IndexPath?
    var usernameIndexPath: IndexPath?
    let username = UserDefaults.standard.string(forKey: "username")
    var cells: [EventCellType]?
    var groupmates: [Groupmate]?

    var dateCell: DateTableViewCell?

    init(context: EventTableContext) {
        super.init()
        (nameIndexPath, usernameIndexPath, dateIndexPath, bigCellIndexPath, datePickerIndexPath, cells, groupmates) = context.context
    }
}

extension EventTableViewHelper: UITableViewDataSource {
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        let subview = UIView(frame: view.bounds)
        subview.backgroundColor = UIColor(named: "accent-color")
        view.insertSubview(subview, at: 1)
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return groupmates != nil ? 2 : 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch EventSections(rawValue: section)! {
        case .info:
            let count = cells!.count
            return count + (datePickerIndexPath != nil ? 1 : 0)
        case .groupmates:
            return groupmates?.count ?? 0
        }
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch EventSections(rawValue: section)! {
        case .info:
            return "Инфо"
        case .groupmates:
            return "Очередь"
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if datePickerIndexPath == indexPath {
            let pickerCell = tableView.dequeueReusableCell(of: DatePickerTableViewCell.self, for: indexPath)
            return setupPickerCell(tableView, pickerCell)
        } else {
            switch EventSections(rawValue: indexPath.section)! {
            case .info:
                return getInfoCell(tableView, indexPath)
            case .groupmates:
                return getGroupmateCell(tableView, indexPath)
            }
        }
    }

    func getInfoCell(_ tableView: UITableView, _ indexPath: IndexPath) -> UITableViewCell {
        switch cells![indexPath.row] {
        case let .bigText(date):
            return getBigTextCell(tableView, indexPath, date)
        case let .date(date, isEditable):
            return getDateCell(tableView, indexPath, date, isEditable)
        case let .name(text, isEditable):
            return getNameCell(tableView, indexPath, text, isEditable)
        }
    }

    func setupPickerCell(_ tableView: UITableView, _ pickerCell: DatePickerTableViewCell) -> UITableViewCell {
        pickerCell.datePicker.date = dateCell?.date ?? Date(timeIntervalSinceNow: 3600)
        pickerCell.delegate = self
        return pickerCell
    }

    func getGroupmateCell(_ tableView: UITableView, _ indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "1")
        if cell == nil {
            cell = UITableViewCell(style: .value1, reuseIdentifier: "1")
        }
        let groupmate = groupmates![indexPath.row]
        cell?.textLabel?.text = groupmate.name
        cell?.detailTextLabel?.text = String(groupmate.position)
        cell?.isUserInteractionEnabled = false
        if username == groupmate.name {
            usernameIndexPath = indexPath
            cell?.textLabel?.textColor = UIColor(named: "accent-color")
        }
        return cell!
    }

    func getBigTextCell(_ tableView: UITableView, _ indexPath: IndexPath, _ date: Date) -> UITableViewCell {
        let bigTextCell = tableView.dequeueReusableCell(of: BigTextTableViewCell.self, for: indexPath)
        bigTextCell.dateCounter = DateCounter(date: date)
        bigCellIndexPath = indexPath
        return bigTextCell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let cell = tableView.cellForRow(at: indexPath)
        guard cell is BigTextTableViewCell || indexPath == datePickerIndexPath else { return tableView.rowHeight }
        return 320
    }

    func getDateCell(_ tableView: UITableView, _ indexPath: IndexPath, _ date: Date?, _ isEditable: Bool) -> UITableViewCell {
        let dateCell = tableView.dequeueReusableCell(of: DateTableViewCell.self, for: indexPath)
        dateIndexPath = indexPath
        dateCell.titleLabel.text = "Начало"
        dateCell.date = date ?? Date(timeIntervalSinceNow: 60 * 5)
        dateCell.isUserInteractionEnabled = isEditable
        self.dateCell = dateCell
        return dateCell
    }

    func getNameCell(_ tableView: UITableView, _ indexPath: IndexPath, _ text: String, _ isEditable: Bool) -> UITableViewCell {
        let editableCell = tableView.dequeueReusableCell(of: EditableTableViewCell.self, for: indexPath)
        nameIndexPath = indexPath
        editableCell.textField.text = text
        editableCell.isUserInteractionEnabled = isEditable
        return editableCell
    }
}

extension EventTableViewHelper: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard tableView.cellForRow(at: indexPath) is DateTableViewCell else { return }
        tableView.beginUpdates()
        if let datePickerIndexPath = datePickerIndexPath, datePickerIndexPath.row - 1 == indexPath.row {
            tableView.deleteRows(at: [datePickerIndexPath], with: .fade)
            self.datePickerIndexPath = nil
        } else {
            if let datePickerIndexPath = datePickerIndexPath {
                tableView.deleteRows(at: [datePickerIndexPath], with: .fade)
            }
            datePickerIndexPath = indexPathToInsertDatePicker(indexPath: indexPath)
            tableView.insertRows(at: [datePickerIndexPath!], with: .fade)
            tableView.deselectRow(at: indexPath, animated: true)
        }
        tableView.endUpdates()
    }

    func indexPathToInsertDatePicker(indexPath: IndexPath) -> IndexPath {
        if let datePickerIndexPath = datePickerIndexPath, datePickerIndexPath.row < indexPath.row {
            return indexPath
        } else {
            return IndexPath(row: indexPath.row + 1, section: indexPath.section)
        }
    }
}

extension EventTableViewHelper: DatePickerDelegate {
    func didValueChange(_ newValue: Date) {
        dateCell?.date = newValue
    }
}

extension UITableView {
    func dequeueReusableCell<T: UITableViewCell>(of type: T.Type, for indexPath: IndexPath) -> T {
        let cell = dequeueReusableCell(withIdentifier: String(describing: type), for: indexPath)
        return cell as! T
    }
}
