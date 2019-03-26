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

class EventViewController: UIViewController {
    // MARK: Properties

    var barButtonTitle: String! {
        didSet {
            navigationItem.rightBarButtonItem?.title = barButtonTitle
        }
    }

    lazy var provider = IndexPathProvider(tableView: self.tableView)
    var barButtonAction: ((inout Event) -> Void)?
    var didInvalidatedCallback: ((Event) -> Void)?
    var cells: [EventCellType]?
    var groupmates: [Groupmate]?
    var event: Event!
    var eventType: EventType!
    var isInvalidated = false
    let helper = EventTableViewHelper()

    // MARK: Computed properties

    var eventName: String {
        let cell = tableView.cellForRow(at: provider.nameIndexPath!)
        guard let nameCell = cell as? EditableTableViewCell else { return "" }
        return nameCell.textField.text!
    }

    var eventDate: Date {
        let cell = tableView.cellForRow(at: provider.dateIndexPath!)
        let fallbackDate = Date(timeIntervalSince1970: 0)
        guard let dateCell = cell as? DateTableViewCell else { return fallbackDate }
        return dateCell.date ?? fallbackDate
    }

    var tableView: UITableView! {
        return (self.view as! UITableView)
    }

    // MARK: View lifecycle

    override func loadView() {
        view = UITableView()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        UserDefaults.standard.set("11", forKey: "username")
        setup()
    }

    private func setup() {
        setupRightBarButton()
        setupRecognizers()
        registerCells()
        setupTimer()
        setupNotifications()
        setupDelegate()
    }

    // MARK: Action handlers

    @objc func updateCells() {
        guard let indexPath = provider.bigCellIndexPath else { return }
        let cell = tableView.cellForRow(at: indexPath)
        guard let bigTextCell = cell as? BigTextTableViewCell else { return }
        bigTextCell.update()
    }

    @objc func didInvalidate() {
        guard eventType == .new, event.date.isExpired else { return }
        NotificationCenter.default.removeObserver(self, name: .invalidated, object: nil)
        navigationItem.rightBarButtonItem?.isEnabled = true
        isInvalidated = true
        let dateIndexPath = IndexPath(row: 1, section: 0)
        didInvalidatedCallback?(event!)
        tableView.reloadRows(at: [dateIndexPath, provider.bigCellIndexPath!], with: .fade)
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
        if let indexPath = provider.buttonIndexPath {
            tableView.beginUpdates()
            tableView.insertSections(IndexSet(integer: 1), with: .fade)
            tableView.deleteRows(at: [indexPath], with: .automatic)
            tableView.endUpdates()
        }
        provider.usernameIndexPath == nil ? checkin() : checkout()
    }

    // MARK: Private Implementation

    private func setupDelegate() {
        helper.controller = self
        tableView.dataSource = helper
        tableView.delegate = helper
    }

    private func setupRecognizers() {
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(didTap))
        view.addGestureRecognizer(tapRecognizer)
    }

    private func setupTimer() {
        let timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(updateCells), userInfo: nil, repeats: true)
        RunLoop.main.add(timer, forMode: RunLoop.Mode.common)
    }

    private func setupNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(didInvalidate), name: .invalidated, object: nil)
    }

    private func setupRightBarButton() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: barButtonTitle, style: UIBarButtonItem.Style.done, target: self, action: #selector(didBarButtonPress))
        if eventType == .new { navigationItem.rightBarButtonItem?.isEnabled = false }
    }

    private func registerCells() {
        tableView.register(EditableTableViewCell.self)
        tableView.register(DatePickerTableViewCell.self)
        tableView.register(DateTableViewCell.self)
        tableView.register(BigTextTableViewCell.self)
        tableView.register(ButtonTableViewCell.self)
    }

    private func checkout() {
        guard !groupmates!.isEmpty else { return }
        let indexPath = provider.usernameIndexPath!
        groupmates?.remove(at: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: .fade)
        updateGroupmatePosition(indexPath)
    }

    private func checkin() {
        let row = groupmates!.count
        let indexPath = IndexPath(row: row, section: EventSections.groupmates.rawValue)
        let username = UserDefaults.standard.string(forKey: "username")
        groupmates!.append(Groupmate(name: username!, position: row + 1))
        tableView.insertRows(at: [indexPath], with: .fade)
    }

    private func updateGroupmatePosition(_ indexPath: IndexPath) {
        let num = indexPath.row
        updatePositions(num)
        let indexPaths = (num ..< groupmates!.count)
            .map { IndexPath(row: $0, section: EventSections.groupmates.rawValue) }
        tableView.reloadRows(at: indexPaths, with: .fade)
    }

    private func updatePositions(_ num: Int) {
        for index in 0 ..< groupmates!.count {
            let mate = groupmates![index]
            if mate.position > num {
                groupmates![index].position -= 1
            }
        }
    }

    private func createEvent() -> Event {
        return Event(name: eventName, date: eventDate)
    }
}

enum EventSections: Int {
    case info, groupmates
}
