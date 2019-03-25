//
//  EventCoordinator.swift
//  queuer
//
//  Created by Денис on 19/03/2019.
//  Copyright © 2019 Денис. All rights reserved.
//

import Foundation
import UIKit

class EventCoordinator: Coordinator {
    private var navigationController: UINavigationController

    private var eventsNavigationController: UINavigationController?

    private var userInfoNavigationController: UINavigationController?

    var userInfoUpdatedAction: ((UserInfo) -> Void)?
    var groupmatesUpdatedAction: (([Groupmate]) -> Void)?

    var userInfo = UserInfo(name: "asa", group: "11") {
        didSet {
            userInfoUpdatedAction?(userInfo)
        }
    }

    var groupmates = [Groupmate(name: "11", position: 1), Groupmate(name: "12ada", position: 2)] {
        didSet {
            groupmatesUpdatedAction?(groupmates)
        }
    }

    var childCoordinators: [Coordinator]?

    var completenceCallback: (() -> Void)?

    required init(_ navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func start() {
        showTabBar()
    }

    fileprivate func setupEventsViewController(_ storyboard: UIStoryboard) {
        eventsNavigationController = storyboard.instantiateViewController(withIdentifier: "events") as? UINavigationController
        guard let eventsVC = eventsNavigationController?.viewControllers.first as? EventsViewController else { return }
        eventsVC.plusCallback = createNewEvent
        eventsVC.selectCallback = didSelect
    }

    fileprivate func setupUserInfoViewController(_ storyboard: UIStoryboard) {
        userInfoNavigationController = storyboard.instantiateViewController(withIdentifier: "info") as? UINavigationController
        guard let infoVC = userInfoNavigationController?.viewControllers.first as? UserInfoViewController else { return }
        infoVC.logoutCallback = didLogout
        infoVC.info = userInfo
        infoVC.groupmates = groupmates
        infoVC.userInfoSelectedCallback = {
            if $1 == .name {
                self.userInfo.name = $0
            } else {
                self.userInfo.group = $0
            }
        }
    }

    func showTabBar() {
        let storyboard = UIStoryboard(name: "Events", bundle: nil)
        setupEventsViewController(storyboard)
        setupUserInfoViewController(storyboard)
        let tabBar = UITabBarController()
        tabBar.viewControllers = ([eventsNavigationController, userInfoNavigationController] as! [UIViewController])
        navigationController.setViewControllers([tabBar], animated: true)
    }

    func createNewEvent() {
        showEventViewController(Event(name: "", date: Date(timeIntervalSinceNow: 0)), .creating)
    }

    func didLogout() {
    }

    func didSelect(event: Event, of type: EventType) {
        showEventViewController(event, type)
    }

    func showEventViewController(_ event: Event, _ type: EventType) {
        let eventViewController = EventViewController()
        eventViewController.cells = getCells(for: event, of: type)
        setupController(type, eventViewController, event)
        eventsNavigationController?.pushViewController(eventViewController, animated: true)
    }

    private func setupController(_ type: EventType, _ eventViewController: EventViewController, _ event: Event) {
        if type == .available || type == .checkedIn {
            eventViewController.groupmates = groupmates
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
            return ("", nil, didBecomeAvailable)
        case .available:
            return ("Я пойду", didCheckedIn, nil)
        case .checkedIn:
            return ("Я не пойду", didUnchecked, nil)
        }
    }

    func didCreated(event: inout Event) {
        eventsNavigationController?.popViewController(animated: true)
    }

    func didCheckedIn( event: inout Event) {
        event.checkedIn = true
        setupEventViewController(as: .checkedIn)
    }

    func didUnchecked( event: inout Event) {
        event.checkedIn = false
        setupEventViewController(as: .available)
    }

    func didBecomeAvailable(event: Event) {
        dump(event)
    }

    func setupEventViewController(as type: EventType) {
        let viewController = eventsNavigationController?.visibleViewController
        guard let eventVC = viewController as? EventViewController else { return }
        let (title, callback, _) = getBarButtonTitleAndCallbacks(for: type)
        eventVC.barButtonTitle = title
        eventVC.barButtonAction = callback
    }
}
