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
    var dateCounters = [DateCounter]()
    var newEvents: [Event]?
    var availableEvents: [Event]?
    var checkedInEvents: [Event]?
    var timer: Timer?
    @IBAction func didPlusTap(_ sender: Any) {
        plusCallback?()
    }

    override func viewDidLoad() {
        newEvents = [Event(name: "aa", date: Date(timeIntervalSinceNow: 100))]
        availableEvents = [Event(name: "123", date: Date(timeIntervalSinceNow: -1 * 24 * 7 * 1000))]
        checkedInEvents = [Event(name: "111111", date: Date(timeIntervalSinceNow: -13 * 10000))]
        tableView.delegate = self
        tableView.dataSource = self
        timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(updateCells), userInfo: nil, repeats: true)
        tableView.register(EventTableViewCell.self)
    }
    
    @objc func updateCells(){
        tableView.visibleCells.forEach { ($0 as! EventTableViewCell).update() }
    }
}

extension EventsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "EventTableViewCell", for: indexPath)
        guard let eventCell = cell as? EventTableViewCell else { return cell }
        eventCell.type = EventTableSections(rawValue: indexPath.section)
        let event = getEvent(indexPath)!
        eventCell.event = event
        eventCell.update()
        return eventCell
    }

    func getEvents(_ section: Int) -> [Event]? {
        switch EventTableSections(rawValue: section)! {
        case .new:
            return newEvents
        case .available:
            return availableEvents
        case .checkedIn:
            return checkedInEvents
        }
    }

    func getEvent(_ indexPath: IndexPath) -> Event? {
        return getEvents(indexPath.section)?[indexPath.row]
    }

    enum EventTableSections: Int {
        case new, available, checkedIn
    }
}
