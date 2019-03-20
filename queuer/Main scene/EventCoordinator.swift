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
    
    func showTabBar(){
  
        
        let viewController = UIStoryboard(name: "Events", bundle: nil).instantiateViewController(withIdentifier: "events")
        navigationController.setViewControllers([viewController], animated: true)
    }
}
