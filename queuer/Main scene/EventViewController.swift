//
//  EventViewController.swift
//  queuer
//
//  Created by Денис on 22/03/2019.
//  Copyright © 2019 Денис. All rights reserved.
//

import UIKit

enum EventCellType {
    case name(text: String, isEditable: Bool), date(date: Date, isEditable: Bool), bigText(date: Date)
}

class EventViewController: UITableViewController {
    var barButtonTitle: String! {
        didSet {
            navigationItem.rightBarButtonItem?.title = barButtonTitle
        }
    }
    var barButtonAction: ((inout Event) -> Void)?
    var didInvalidatedCallback: ((Event) -> Void)?
    var cells: [EventCellType]?
    var groupmates: [Groupmate]?
    var event: Event!
    var eventType: EventType!
    var username: String!
    var nameIndexPath: IndexPath?
    var dateIndexPath: IndexPath?
    var datePickerIndexPath: IndexPath?
    var bigCellIndexPath: IndexPath?
    var usernameIndexPath: IndexPath?

    var date: Date? {
        guard let dateIndex = dateCellRow else { return nil }
        guard case let .date(eventDate, _) = cells![dateIndex] else { return nil }
        return eventDate
    }

    var dateCellRow: Int? {
        return cells!.firstIndex(where: { item in
            if case .date = item {
                return true
            } else {
                return false
            }
        })
    }

    var dateCell: DateTableViewCell? {
        guard let row = dateCellRow else { return nil }
        let indexPath = IndexPath(row: row, section: EventSections.info.rawValue)
        let cell = tableView.cellForRow(at: indexPath)
        return cell as? DateTableViewCell
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: barButtonTitle, style: UIBarButtonItem.Style.done, target: self, action: #selector(didBarButtonPress))
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTap)))
        tableView.register(EditableTableViewCell.self)
        tableView.register(DatePickerTableViewCell.self)
        tableView.register(DateTableViewCell.self)
        tableView.register(BigTextTableViewCell.self)
        let timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(updateCells), userInfo: nil, repeats: true)
        RunLoop.main.add(timer, forMode: RunLoop.Mode.common)
        NotificationCenter.default.addObserver(self, selector: #selector(didInvalidated), name: .invalidated, object: nil)
        UserDefaults.standard.set("11", forKey: "username")
        username = UserDefaults.standard.string(forKey: "username")
    }

    @objc func updateCells() {
        guard let indexPath = bigCellIndexPath else { return }
        let cell = tableView.cellForRow(at: indexPath)
        guard let bigTextCell = cell as? BigTextTableViewCell else { return }
        bigTextCell.update()
    }

    @objc func didInvalidated() {
        NotificationCenter.default.removeObserver(self, name: .invalidated, object: nil)
        if event == nil {
            event = createEvent()
        }
        didInvalidatedCallback?(event!)
    }

    @objc func didTap() {
        view.endEditing(true)
    }

    @objc func didBarButtonPress() {
        if event == nil {
            event = createEvent()
        }
        barButtonAction?(&event!)
        guard eventType == .checkedIn || eventType == .available else { return }
        if let indexPath = usernameIndexPath {
            groupmates?.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            updateGroupmatePosition(indexPath)
            usernameIndexPath = nil
        } else {
            let row = groupmates!.count
            let indexPath = IndexPath(row: row, section: EventSections.groupmates.rawValue)
            groupmates!.append(Groupmate(name: username, position: row + 1))
            tableView.insertRows(at: [indexPath], with: .fade)
            usernameIndexPath = indexPath
        }
    }

    private func updateGroupmatePosition(_ indexPath: IndexPath) {
        let num = indexPath.row
        for index in 0 ..< groupmates!.count {
            let mate = groupmates![index]
            if mate.position > num {
                groupmates![index].position -= 1
            }
        }
        let indexPaths = (num ..< groupmates!.count)
            .map { IndexPath(row: $0, section: EventSections.groupmates.rawValue) }
        tableView.reloadRows(at: indexPaths, with: .fade)
    }

    var eventName: String {
        let cell = tableView.cellForRow(at: nameIndexPath!)
        guard let nameCell = cell as? EditableTableViewCell else { return "" }
        return nameCell.textField.text!
    }

    var eventDate: Date {
        let cell = tableView.cellForRow(at: dateIndexPath!)
        let fallbackDate = Date(timeIntervalSince1970: 0)
        guard let dateCell = cell as? DateTableViewCell else { return fallbackDate }
        return dateCell.date ?? fallbackDate
    }

    func createEvent() -> Event {
        return Event(name: eventName, date: eventDate)
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        let subview = UIView(frame: view.bounds)
        subview.backgroundColor = UIColor(named: "accent-color")
        view.insertSubview(subview, at: 1)
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return groupmates != nil ? 2 : 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch EventSections(rawValue: section)! {
        case .info:
            let count = cells!.count
            return count + (datePickerIndexPath != nil ? 1 : 0)
        case .groupmates:
            return groupmates?.count ?? 0
        }
    }

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch EventSections(rawValue: section)! {
        case .info:
            return "Инфо"
        case .groupmates:
            return "Одногруппники"
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if datePickerIndexPath == indexPath {
            let cell = tableView.dequeueReusableCell(withIdentifier: "DatePickerTableViewCell", for: indexPath)
            guard let pickerCell = cell as? DatePickerTableViewCell else { return cell }
            return setupPickerCell(pickerCell)
        } else {
            switch EventSections(rawValue: indexPath.section)! {
            case .info:
                return getInfoCell(indexPath)
            case .groupmates:
                return getGroupmateCell(indexPath)
            }
        }
    }

    private func getInfoCell(_ indexPath: IndexPath) -> UITableViewCell {
        switch cells![indexPath.row] {
        case let .bigText(date):
            return getBigTextCell(indexPath, date)
        case let .date(date, isEditable):
            return getDateCell(indexPath, date, isEditable)
        case let .name(text, isEditable):
            return getNameCell(indexPath, text, isEditable)
        }
    }

    private func setupPickerCell(_ pickerCell: DatePickerTableViewCell) -> UITableViewCell {
        pickerCell.datePicker.date = date ?? Date(timeIntervalSinceNow: 3600)
        pickerCell.delegate = self
        return pickerCell
    }

    private func getGroupmateCell(_ indexPath: IndexPath) -> UITableViewCell {
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

    private func getBigTextCell(_ indexPath: IndexPath, _ date: Date) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BigTextTableViewCell", for: indexPath)
        guard let bigTextCell = cell as? BigTextTableViewCell else { return cell }
        bigTextCell.dateCounter = DateCounter(date: date)
        bigCellIndexPath = indexPath
        return cell
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let cell = tableView.cellForRow(at: indexPath)
        guard cell is BigTextTableViewCell || indexPath == datePickerIndexPath else { return tableView.rowHeight }
        return 320
    }

    private func getDateCell(_ indexPath: IndexPath, _ date: Date?, _ isEditable: Bool) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DateTableViewCell", for: indexPath)
        guard let dateCell = cell as? DateTableViewCell else { return cell }
        dateIndexPath = indexPath
        dateCell.titleLabel.text = "Начало"
        dateCell.date = date ?? Date(timeIntervalSinceNow: 60 * 5)
        dateCell.isUserInteractionEnabled = isEditable
        return cell
    }

    private func getNameCell(_ indexPath: IndexPath, _ text: String, _ isEditable: Bool) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "EditableTableViewCell", for: indexPath)
        guard let editableCell = cell as? EditableTableViewCell else { return cell }
        nameIndexPath = indexPath
        editableCell.textField.text = text
        editableCell.isUserInteractionEnabled = isEditable
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
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

    enum EventSections: Int {
        case info, groupmates
    }
}

extension EventViewController: DatePickerDelegate {
    func didValueChange(_ newValue: Date) {
        dateCell?.date = newValue
    }
}
