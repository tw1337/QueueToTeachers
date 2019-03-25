//
//  CoordinatorUtil.swift
//  queuer
//
//  Created by Денис on 20/03/2019.
//  Copyright © 2019 Денис. All rights reserved.
//

import Foundation
import UIKit

enum CoordinatorType {
    case login, event
    
    var coordinatorInit: (UINavigationController) -> Coordinator {
        switch self {
        case .login:
            return LoginCoordinator.init
        case .event:
            return MainCoordinator.init
        }
    }
}

class CoordinatorMaker {
    
    var navigationController: UINavigationController
    
    init(_ navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func make(_ types: [CoordinatorType]) -> [Coordinator] {
        var out = [Coordinator]()
        for type in types {
            let coordinator = type.coordinatorInit(navigationController)
            out.append(coordinator)
        }
        return out
    }
}
