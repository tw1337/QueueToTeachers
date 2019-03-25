//
//  EventCoordinator.swift
//  queuer
//
//  Created by Денис on 19/03/2019.
//  Copyright © 2019 Денис. All rights reserved.
//

import Foundation
import UIKit

class MainCoordinator: Coordinator {
    private var navigationController: UINavigationController

    var childCoordinators: [Coordinator]?
    var childNavigationControllers = [UINavigationController]()

    var completenceCallback: (() -> Void)?

    let tabBar = UITabBarController()

    required init(_ navigationController: UINavigationController) {
        self.navigationController = navigationController
        let storyboard = UIStoryboard(name: "Events", bundle: nil)
        childCoordinators = [Coordinator]()
        setupEventsCoordinator(storyboard)
        setupUserInfoCoordinator(storyboard)
        tabBar.viewControllers = (childNavigationControllers as [UIViewController])
    }

    func showTabBar() {
        navigationController.setViewControllers([tabBar], animated: true)
    }

    func start() {
        showTabBar()
    }

    private func setupEventsCoordinator(_ storyboard: UIStoryboard) {
        let eventsNavigationController = storyboard.instantiateViewController(withIdentifier: "events") as! UINavigationController
        let eventsCoordinator = EventCoordinator(eventsNavigationController)
        childNavigationControllers.append(eventsNavigationController)
        childCoordinators?.append(eventsCoordinator)
    }

    private func setupUserInfoCoordinator(_ storyboard: UIStoryboard) {
        let userInfoNavigationController = storyboard.instantiateViewController(withIdentifier: "info") as! UINavigationController
        let userInfoCoordinator = InfoCoordinator(userInfoNavigationController)
        childNavigationControllers.append(userInfoNavigationController)
        childCoordinators?.append(userInfoCoordinator)
    }

   

 
}
