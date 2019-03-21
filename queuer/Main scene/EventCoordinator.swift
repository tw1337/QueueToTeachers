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

    fileprivate func instantiateEventsViewController(_ storyboard: UIStoryboard) -> UINavigationController {
        let navController = storyboard.instantiateViewController(withIdentifier: "events") as? UINavigationController
        guard let eventsVC = navController?.viewControllers.first as? EventsViewController else { return UINavigationController() }
        eventsVC.plusCallback = createNewEvent
        eventsVC.selectedCallback = didSelected
        return navController!
    }

    fileprivate func instantiateUserInfoViewController(_ storyboard: UIStoryboard) -> UINavigationController {
        let navController = storyboard.instantiateViewController(withIdentifier: "info") as? UINavigationController
        guard let infoVC = navController?.viewControllers.first as? UserInfoViewController else { return UINavigationController() }
        infoVC.logoutCallback = didLogout
        infoVC.userInfoSelectedCallback = didSelected
        return navController!
    }

    func showTabBar() {
        let storyboard = UIStoryboard(name: "Events", bundle: nil)
        let eventsViewController = instantiateEventsViewController(storyboard)
        let userInfoViewController = instantiateUserInfoViewController(storyboard)
        let tabBar = UITabBarController()
        tabBar.viewControllers = [eventsViewController, userInfoViewController]
        navigationController.setViewControllers([tabBar], animated: true)
    }

    func createNewEvent() {
        
    }

    func didLogout() {
         
    }
    
    func didSelected(section: UserInfoType) {
        
    }
    
    func didSelected(event: Event, of type: EventType) {
        
    }
}
