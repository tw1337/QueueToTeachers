//
//  UserInfoViewController.swift
//  queuer
//
//  Created by Денис on 20/03/2019.
//  Copyright © 2019 Денис. All rights reserved.
//

import UIKit

class UserInfoViewController: UIViewController {
    var groupmates: [Groupmate]?

    @IBOutlet var tableView: UITableView!

    var logoutCallback: (() -> Void)?

    @IBAction func didTapLogout(_ sender: Any) {
        logoutCallback?()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        // Do any additional setup after loading the view.
    }
}

extension UserInfoViewController: UITableViewDelegate {
}

extension UserInfoViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch UserInfoSections(rawValue: section)! {
        case .general:
            return 3
        case .groupmates:
            return groupmates?.count ?? 0
        }
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return UserInfoSections.allCases.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
}

enum UserInfoSections: Int, CaseIterable {
    case general, groupmates
}
