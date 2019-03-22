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
        infoVC.userInfoSelectedCallback = didSelected
        infoVC.info = userInfo
        infoVC.groupmates = groupmates
        userInfoUpdatedAction = {
            infoVC.info = $0
            infoVC.tableView.reloadData()
        }
        groupmatesUpdatedAction = {
            infoVC.groupmates = $0
            infoVC.tableView.reloadData()
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

    func didSelected(section: UserInfoType) {
        let alertController = prepareAlertController(for: section)
        userInfoNavigationController?.visibleViewController?.present(alertController, animated: true)
    }

    func prepareAlertController(for section: UserInfoType) -> UIViewController {
        let titleString = "Введите " + (section == .group ? "новую группу" : "новое имя")
        let alertController = UIAlertController(title: titleString, message: "", preferredStyle: .alert)
        let saveAction = UIAlertAction(title: "Обновить", style: .default, handler: { _ -> Void in
            let textField = alertController.textFields![0] as UITextField
            guard let text = textField.text, !text.isEmpty else { return }
            if section == .group {
                self.userInfo.group = text
            } else {
                self.userInfo.name = text
            }
        })
        let cancelAction = UIAlertAction(title: "Отмена", style: .cancel, handler: { (_: UIAlertAction!) -> Void in })
        alertController.addTextField { (textField: UITextField!) -> Void in
            textField.text = section == .group ? self.userInfo.group : self.userInfo.name
        }
        alertController.addAction(saveAction)
        alertController.addAction(cancelAction)
        return alertController
    }

    func didSelected(event: Event, of type: EventType) {
    }
}
