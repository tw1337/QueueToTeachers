//
//  EventsViewController.swift
//  queuer
//
//  Created by Денис on 19/03/2019.
//  Copyright © 2019 Денис. All rights reserved.
//

import Foundation
import UIKit

class EventsViewController: UIViewController {
    @IBOutlet var tableView: UITableView!

    var plusCallback: (() -> Void)?

    var newEvents: [Event]?
    var availableEvents: [Event]?
    var checkedInEvents: [Event]?

    @IBAction func didPlusTap(_ sender: Any) {
        plusCallback?()
    }

    override func viewDidLoad() {
        newEvents = [Event(name: "aa", date: Date())]
        availableEvents = [Event(name: "123", date: Date(timeIntervalSince1970: 0.4))]
        checkedInEvents = [Event(name: "111111", date: Date(timeIntervalSinceReferenceDate: 0))]
        tableView.delegate = self
        tableView.dataSource = self
    }
}

extension EventsViewController: UITableViewDelegate {
}

extension EventsViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }

    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        let subview = UIView(frame: view.bounds)
        subview.backgroundColor = UIColor(named: "accent-color")
        view.insertSubview(subview, at: 1)
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch EventTableSections(rawValue: section)! {
        case .new:
            return "Новые"
        case .available:
            return "Доступные"
        case .checkedIn:
            return "Отмеченные"
        }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var out: Int?
        switch EventTableSections(rawValue: section)! {
        case .new:
            out = newEvents?.count
        case .available:
            out = availableEvents?.count
        case .checkedIn:
            out = checkedInEvents?.count
        }
        return out ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch EventTableSections(rawValue: indexPath.section)! {
        case .new:
            return getNewCell(in: tableView, for: indexPath)
        case .available:
            return getAvailableCell(in: tableView, for: indexPath)
        case .checkedIn:
            return getCheckedInCell(in: tableView, for: indexPath)
        }
    }

    func getNewCell(in tableView: UITableView, for indexPath: IndexPath) -> UITableViewCell {
    }

    func getAvailableCell(in tableView: UITableView, for indexPath: IndexPath) -> UITableViewCell {
    }

    func getCheckedInCell(in tableView: UITableView, for indexPath: IndexPath) -> UITableViewCell {
    }

    enum EventTableSections: Int {
        case new, available, checkedIn
    }
}
