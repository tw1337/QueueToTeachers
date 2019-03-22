//
//  EventViewController.swift
//  queuer
//
//  Created by Денис on 22/03/2019.
//  Copyright © 2019 Денис. All rights reserved.
//

import UIKit

enum EventCellType {
    case name(text: String, editable: Bool), date(editable: Bool), bigText(date: Date)
}

class EventViewController: UITableViewController {
    var barButtonTitle: String?
    var barButtonAction: ((Event) -> Void)?
    var cells: [EventCellType]?
    var groupmates: [Groupmate]?
    var datePickerIndexPath: IndexPath?
    var event: Event?

    let dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMM yyyy HH:mm"
        dateFormatter.locale = Locale(identifier: "ru_RU")
        return dateFormatter
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: barButtonTitle, style: UIBarButtonItem.Style.done, target: self, action: #selector(didBarButtonPress))
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTap)))
        tableView.register(EditableTableViewCell.self)
        tableView.register(DatePickerTableViewCell.self)
        tableView.register(DateTableViewCell.self)
        tableView.register(BigTextTableViewCell.self)
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
        case let .date(isEditable):
            return getDateCell(indexPath, isEditable)
        case let .name(text, isEditable):
            return getNameCell(indexPath, text, isEditable)
        }
    }

    private func setupPickerCell(_ pickerCell: DatePickerTableViewCell) -> UITableViewCell {
        pickerCell.datePicker.date = event?.date ?? Date(timeIntervalSinceNow: 3600)
        pickerCell.delegate = self
        return pickerCell
    }

    private func getGroupmateCell(_ indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }

    private func getBigTextCell(_ indexPath: IndexPath, _ date: Date) -> UITableViewCell {
        return UITableViewCell()
    }

    private func getDateCell(_ indexPath: IndexPath, _ isEditable: Bool) -> UITableViewCell {
        return UITableViewCell()
    }

    private func getNameCell(_ indexPath: IndexPath, _ text: String, _ isEditable: Bool) -> UITableViewCell {
        return UITableViewCell()
    }

    enum EventSections: Int {
        case info, groupmates
    }
}

extension EventViewController: DatePickerDelegate {
    func didValueChange(_ newValue: Date) {
        guard let row = cells!.firstIndex(where: { item in
            if case EventCellType.date = item { return true }
            else { return false }
        }) else { return }
        let indexPath = IndexPath(row: row, section: EventSections.info.rawValue)
        let cell = tableView.cellForRow(at: indexPath)
        if let dateCell = cell as? DateTableViewCell {
            dateCell.detailLabel!.text = dateFormatter.string(from: newValue)
        }
    }
}
