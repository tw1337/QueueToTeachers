//
//  EventCoordinator.swift
//  queuer
//
//  Created by Денис on 25/03/2019.
//  Copyright © 2019 Денис. All rights reserved.
//

import Foundation
import UIKit

class EventCoordinator: Coordinator {
    private var navigationController: UINavigationController

    var groupmates = [Groupmate(name: "11", position: 1), Groupmate(name: "12ada", position: 2)] {
        didSet {
            groupmatesUpdatedAction?(groupmates)
        }
    }

    var groupmatesUpdatedAction: (([Groupmate]) -> Void)?

    func start() {
    }

    var childCoordinators: [Coordinator]?

    var completenceCallback: (() -> Void)?

    fileprivate func setupEventsViewController(_ eventsVC: EventsViewController) {
        eventsVC.plusCallback = createNewEvent
        eventsVC.selectCallback = didSelect
    }

    required init(_ navigationController: UINavigationController) {
        self.navigationController = navigationController
        guard let eventsVC = navigationController.viewControllers.first as? EventsViewController else { return }
        setupEventsViewController(eventsVC)
    }

    func createNewEvent() {
        showEventViewController(Event(name: "", date: Date(timeIntervalSinceNow: 0)), .creating)
    }

    func didSelect(event: Event, of type: EventType) {
        showEventViewController(event, type)
    }

    func showEventViewController(_ event: Event, _ type: EventType) {
        let eventViewController = EventViewController()
        eventViewController.cells = getCells(for: event, of: type)
        setupController(type, eventViewController, event)
        navigationController.pushViewController(eventViewController, animated: true)
    }

    private func setupController(_ type: EventType, _ eventViewController: EventViewController, _ event: Event) {
        if type == .available || type == .checkedIn {
            eventViewController.groupmates = []
        }
        eventViewController.title = type != .creating ? event.name : "Создание"
        let (barTitle, action, invalidateCallback) = getBarButtonTitleAndCallbacks(for: type)
        eventViewController.barButtonTitle = barTitle
        eventViewController.barButtonAction = action
        eventViewController.eventType = type
        eventViewController.event = event
        eventViewController.didInvalidatedCallback = invalidateCallback
    }

    func getCells(for event: Event, of type: EventType) -> [EventCellType] {
        switch type {
        case .creating, .available, .checkedIn:
            let isCreating = type == .creating
            return [EventCellType.name(text: event.name, isEditable: isCreating), .date(date: event.date, isEditable: isCreating)]
        case .new:
            return [EventCellType.name(text: event.name, isEditable: false), .name(text: "Начало через", isEditable: false), .bigText(date: event.date)]
        }
    }

    func getBarButtonTitleAndCallbacks(for type: EventType) -> (String, ((inout Event) -> Void)?, ((Event) -> Void)?) {
        switch type {
        case .creating:
            return ("Создать", didCreated, nil)
        case .new:
            return ("", didCheckedIn, didBecomeAvailable)
        case .available:
            return ("Я пойду", didCheckedIn, nil)
        case .checkedIn:
            return ("Я не пойду", didUnchecked, nil)
        }
    }

    func didCreated(event: inout Event) {
        // TODO: Show created view
        navigationController.popViewController(animated: true)
    }

    func didCheckedIn(event: inout Event) {
        event.checkedIn = true
        setupEventViewController(as: .checkedIn)
    }

    func didUnchecked(event: inout Event) {
        event.checkedIn = false
        setupEventViewController(as: .available)
    }

    func didBecomeAvailable(event: Event) {
        let viewController = navigationController.visibleViewController
        guard let eventVC = viewController as? EventViewController else { return }
        eventVC.eventType = .available
        eventVC.barButtonAction = didCheckedIn
        eventVC.cells![1] = .date(date: event.date, isEditable: false)
    }

    func setupEventViewController(as type: EventType) {
        guard type == .checkedIn || type == .available else { return }
        let viewController = navigationController.visibleViewController
        guard let eventVC = viewController as? EventViewController else { return }
        let (title, callback, _) = getBarButtonTitleAndCallbacks(for: type)
        if eventVC.cells?.count == 3 { eventVC.cells?.remove(at: 2) }
        eventVC.groupmates = groupmates
        eventVC.barButtonTitle = title
        eventVC.barButtonAction = callback
    }
}
