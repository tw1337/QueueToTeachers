//
//  EventsViewController.swift
//  queuer
//
//  Created by Денис on 19/03/2019.
//  Copyright © 2019 Денис. All rights reserved.
//

import Foundation
import UIKit

extension Notification.Name {
    public static let invalidated = Notification.Name(rawValue: "invalidated")
}

class EventsViewController: UIViewController {
    @IBOutlet var tableView: UITableView!

    var plusCallback: (() -> Void)?
    var selectedCallback: ((Event, EventType) -> Void)?
    var newEvents: [Event]?
    var availableEvents: [Event]?
    var checkedInEvents: [Event]?

    var timer: Timer?
    @IBAction func didPlusTap(_ sender: Any) {
        plusCallback?()
    }

    override func viewDidLoad() {
        newEvents = [Event(name: "aa", date: Date(timeIntervalSinceNow: 5)),
                     Event(name: "aa", date: Date(timeIntervalSinceNow: 5)),
                     Event(name: "aa", date: Date(timeIntervalSinceNow: 15)),
                     Event(name: "aa", date: Date(timeIntervalSinceNow: 5))]
        availableEvents = [Event(name: "123", date: Date(timeIntervalSinceNow: -1 * 24 * 7 * 1000)), Event(name: "123", date: Date(timeIntervalSinceNow: -1 * 24 * 7 * 1000)), Event(name: "123", date: Date(timeIntervalSinceNow: -1 * 24 * 7 * 1000)), Event(name: "123", date: Date(timeIntervalSinceNow: -1 * 24 * 7 * 1000)), Event(name: "123", date: Date(timeIntervalSinceNow: -1 * 24 * 7 * 1000)), Event(name: "123", date: Date(timeIntervalSinceNow: -1 * 24 * 7 * 1000)), Event(name: "123", date: Date(timeIntervalSinceNow: -1 * 24 * 7 * 1000))]
        checkedInEvents = [Event(name: "111111", date: Date(timeIntervalSinceNow: -13 * 10000))]
        tableView.delegate = self
        tableView.dataSource = self
        timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(updateCells), userInfo: nil, repeats: true)
        RunLoop.main.add(timer!, forMode: RunLoop.Mode.common)
        tableView.register(EventTableViewCell.self)
        NotificationCenter.default.addObserver(self, selector: #selector(didInvalidated), name: .invalidated, object: nil)
    }

    @objc func updateCells() {
        tableView.visibleCells.forEach { ($0 as! EventTableViewCell).update() }
    }

    @objc func didInvalidated() {
        moveOutdated()
    }

    private func moveChecked(at cell: EventTableViewCell) {
        let indexPath = tableView.indexPath(for: cell)!
        let index = indexPath.row
        let eventToMove = availableEvents![index]
        checkedInEvents!.append(eventToMove)
        availableEvents!.remove(at: index)
        let newIndexPath = IndexPath(row: checkedInEvents!.count - 1, section: 2)
        tableView.moveRow(at: indexPath, to: newIndexPath)
    }

    private func moveOutdated() {
        while let indexToMove = newEvents?.firstIndex(where: { $0.date.isExpired }) {
            let elementToMove = newEvents![indexToMove]
            newEvents?.remove(at: indexToMove)
            let destination = IndexPath(row: availableEvents?.count ?? 1 - 1, section: 1)
            availableEvents?.append(elementToMove)

            tableView.moveRow(at: IndexPath(row: indexToMove, section: 0), to: destination)
        }
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
        switch EventType(rawValue: section)! {
        case .new:
            return "Новые"
        case .available:
            return "Доступные"
        case .checkedIn:
            return "Отмеченные"
        }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return getEvents(section)?.count ?? 0 - 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "EventTableViewCell", for: indexPath)
        guard let eventCell = cell as? EventTableViewCell else { return cell }
        setupCell(indexPath, eventCell)
        return eventCell
    }

    private func setupCell(_ indexPath: IndexPath, _ eventCell: EventTableViewCell) {
        eventCell.type = EventType(rawValue: indexPath.section)
        let event = getEvent(indexPath)!
        eventCell.event = event
        eventCell.buttonCallback = moveChecked
        eventCell.update()
    }

    func getEvents(_ section: Int) -> [Event]? {
        switch EventType(rawValue: section)! {
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
}

enum EventType: Int {
    case new, available, checkedIn
}
