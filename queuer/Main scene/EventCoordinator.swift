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

    var groupmates = [Groupmate(name: "11"), Groupmate(name: "12ada")] {
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
        eventsVC.selectedCallback = didSelected
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
    }

    func didLogout() {
    }

    func didSelected(event: Event, of type: EventType) {
    }
}
