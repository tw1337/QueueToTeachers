//
//  AppDelegate.swift
//  queuer
//
//  Created by Денис on 18/03/2019.
//  Copyright © 2019 Денис. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    var coordinator: Coordinator!
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        let navigationController = UINavigationController()
        navigationController.navigationBar.isHidden = true
        prepareCoordinator(navigationController)
        setupAppearance()
        coordinator.start()
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
        return true
    }
    
    private func prepareCoordinator(_ navigationController: UINavigationController) {
        coordinator = MainCoordinator(navigationController)
        let childCoordinatorMaker = CoordinatorMaker(navigationController)
        coordinator.childCoordinators = prepareChildCoordinators(childCoordinatorMaker)
    }
    
    private func prepareChildCoordinators(_ childCoordinatorMaker: CoordinatorMaker) -> [Coordinator] {
        let isLoggedIn = false
        var toCreate = [CoordinatorType.event]
        if !isLoggedIn {
            toCreate.append(.login)
        }
        return childCoordinatorMaker.make(toCreate)
    }
    
    private func setupAppearance() {
        UINavigationBar.appearance().largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor(named: "accent-color") ?? UIColor.black]
        UITableViewHeaderFooterView.appearance().backgroundColor = UIColor(named: "accent-color")
        UILabel.appearance(whenContainedInInstancesOf: [UITableViewHeaderFooterView.self]).tintColor = UIColor.white
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
}
