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
    var barButtonTitle: String?
    var barButtonAction: ((Event) -> Void)?
    var cells: [EventCellType]?
    var groupmates: [Groupmate]?
    var datePickerIndexPath: IndexPath?
    var bigCells = [BigTextTableViewCell]()

    let dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMM yyyy HH:mm"
        dateFormatter.locale = Locale(identifier: "ru_RU")
        return dateFormatter
    }()

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
    }

    @objc func updateCells() {
        bigCells.forEach { $0.update() }
    }

    @objc func didInvalidated() {
    }

    @objc func didTap() {
        view.endEditing(true)
    }

    @objc func didBarButtonPress() {
        let event = createEvent()
        barButtonAction?(event)
    }

    func createEvent() -> Event {
        return Event(name: "", date: Date())
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
            cell = UITableViewCell(style: .default, reuseIdentifier: "1")
        }
        cell?.textLabel?.text = groupmates?[indexPath.row].name ?? ""
        // TODO: check username
        return cell!
    }

    private func getBigTextCell(_ indexPath: IndexPath, _ date: Date) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BigTextTableViewCell", for: indexPath)
        guard let bigTextCell = cell as? BigTextTableViewCell else { return cell }
        bigTextCell.dateCounter = DateCounter(date: date)
        bigCells.append(bigTextCell)
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
        dateCell.titleLabel.text = "Начало"
        dateCell.detailLabel.text = dateFormatter.string(from: date ?? Date(timeIntervalSince1970: 0))
        dateCell.isUserInteractionEnabled = isEditable
        return cell
    }

    private func getNameCell(_ indexPath: IndexPath, _ text: String, _ isEditable: Bool) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "EditableTableViewCell", for: indexPath)
        guard let editableCell = cell as? EditableTableViewCell else { return cell }
        editableCell.textField.text = text
        editableCell.isUserInteractionEnabled = isEditable
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
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
        dateCell?.detailLabel!.text = dateFormatter.string(from: newValue)
    }
}
