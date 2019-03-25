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
    weak var controller: EventViewController!
    var dateCell: DateTableViewCell?
}

// MARK: - TableView datasource

extension EventTableViewHelper: UITableViewDataSource {
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        let subview = UIView(frame: view.bounds)
        subview.backgroundColor = UIColor(named: "accent-color")
        view.insertSubview(subview, at: 1)
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return controller.groupmates != nil ? 2 : 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch EventSections(rawValue: section)! {
        case .info:
            let count = controller.cells!.count
            return count + (controller.datePickerIndexPath != nil ? 1 : 0)
        case .groupmates:
            return controller.groupmates?.count ?? 0
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
        if controller.datePickerIndexPath == indexPath {
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
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let cell = tableView.cellForRow(at: indexPath)
        guard cell is BigTextTableViewCell || indexPath == controller.datePickerIndexPath else { return tableView.rowHeight }
        return 320
    }
    
    // MARK: cellForRowAt methods

    func getInfoCell(_ tableView: UITableView, _ indexPath: IndexPath) -> UITableViewCell {
        switch controller.cells![indexPath.row] {
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
        let groupmate = controller.groupmates![indexPath.row]
        cell?.textLabel?.text = groupmate.name
        cell?.detailTextLabel?.text = String(groupmate.position)
        cell?.isUserInteractionEnabled = false
        if controller.username == groupmate.name {
            controller.usernameIndexPath = indexPath
            cell?.textLabel?.textColor = UIColor(named: "accent-color")
        }
        return cell!
    }

    func getBigTextCell(_ tableView: UITableView, _ indexPath: IndexPath, _ date: Date) -> UITableViewCell {
        let bigTextCell = tableView.dequeueReusableCell(of: BigTextTableViewCell.self, for: indexPath)
        bigTextCell.dateCounter = DateCounter(date: date)
        controller.bigCellIndexPath = indexPath
        return bigTextCell
    }

    func getDateCell(_ tableView: UITableView, _ indexPath: IndexPath, _ date: Date?, _ isEditable: Bool) -> UITableViewCell {
        let dateCell = tableView.dequeueReusableCell(of: DateTableViewCell.self, for: indexPath)
        controller.dateIndexPath = indexPath
        dateCell.titleLabel.text = "Начало"
        dateCell.date = date ?? Date(timeIntervalSinceNow: 60 * 5)
        dateCell.isUserInteractionEnabled = isEditable
        self.dateCell = dateCell
        return dateCell
    }

    func getNameCell(_ tableView: UITableView, _ indexPath: IndexPath, _ text: String, _ isEditable: Bool) -> UITableViewCell {
        let editableCell = tableView.dequeueReusableCell(of: EditableTableViewCell.self, for: indexPath)
        controller.nameIndexPath = indexPath
        editableCell.textField.text = text
        editableCell.isUserInteractionEnabled = isEditable
        return editableCell
    }
}

// MARK: - TableView delegate

extension EventTableViewHelper: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard tableView.cellForRow(at: indexPath) is DateTableViewCell else { return }
        tableView.beginUpdates()
        if let datePickerIndexPath = controller.datePickerIndexPath, datePickerIndexPath.row - 1 == indexPath.row {
            tableView.deleteRows(at: [datePickerIndexPath], with: .fade)
            controller.datePickerIndexPath = nil
        } else {
            if let datePickerIndexPath = controller.datePickerIndexPath {
                tableView.deleteRows(at: [datePickerIndexPath], with: .fade)
            }
            controller.datePickerIndexPath = indexPathToInsertDatePicker(indexPath: indexPath)
            tableView.insertRows(at: [controller.datePickerIndexPath!], with: .fade)
            tableView.deselectRow(at: indexPath, animated: true)
        }
        tableView.endUpdates()
    }

    func indexPathToInsertDatePicker(indexPath: IndexPath) -> IndexPath {
        if let datePickerIndexPath = controller.datePickerIndexPath, datePickerIndexPath.row < indexPath.row {
            return indexPath
        } else {
            return IndexPath(row: indexPath.row + 1, section: indexPath.section)
        }
    }
}

// MARK: - DatePickerDalegate

extension EventTableViewHelper: DatePickerDelegate {
    func didValueChange(_ newValue: Date) {
        dateCell?.date = newValue
    }
}


