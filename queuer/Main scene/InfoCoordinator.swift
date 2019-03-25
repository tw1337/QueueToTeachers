//
//  InfoCoordinator.swift
//  queuer
//
//  Created by Денис on 25/03/2019.
//  Copyright © 2019 Денис. All rights reserved.
//

import Foundation
import UIKit

class InfoCoordinator: Coordinator {
    private var navigationController: UINavigationController

    func start() {
    }

    var childCoordinators: [Coordinator]?
    var completenceCallback: (() -> Void)?
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
    
    required init(_ navigationController: UINavigationController) {
        self.navigationController = navigationController
        guard let infoVC = navigationController.viewControllers.first as? UserInfoViewController else { return }
        setupInfoViewController(infoVC)
    }

    private func setupInfoViewController(_ infoVC: UserInfoViewController) {
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

    func didLogout() {
    }
}
