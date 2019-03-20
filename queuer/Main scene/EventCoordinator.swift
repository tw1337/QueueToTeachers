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

    var childCoordinators: [Coordinator]?

    var completenceCallback: (() -> Void)?

    required init(_ navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func start() {
        showTabBar()
    }

    fileprivate func instantiateEventsViewController(_ storyboard: UIStoryboard) -> UIViewController {
        let viewController = storyboard.instantiateViewController(withIdentifier: "events")
        if let eventsVC = viewController as? EventsViewController {
            viewController?.plusCallback = {
                self.showNewEvent()
            }
        }
        return viewController
    }

    fileprivate func instantiateUserInfoViewController(_ storyboard: UIStoryboard) -> UIViewController {
        let viewController = storyboard.instantiateViewController(withIdentifier: "info")
        return viewController
    }

    func showTabBar() {
        let storyboard = UIStoryboard(name: "Events", bundle: nil)
        let eventsViewController = instantiateEventsViewController(storyboard)

        let userInfoViewController = instantiateUserInfoViewController(storyboard)
        let tabBar = UITabBarController()
        tabBar.viewControllers = [eventsViewController, userInfoViewController]
        navigationController.setViewControllers([tabBar], animated: true)
    }

    func showNewEvent() {
        print("11")
    }
}
