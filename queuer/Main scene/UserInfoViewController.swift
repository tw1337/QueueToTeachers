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

    var info: UserInfo?

    @IBOutlet var tableView: UITableView!
    var userInfoSelectedCallback: ((String, UserInfoType) -> Void)?
    var logoutCallback: (() -> Void)?

    @IBAction func didTapLogout(_ sender: Any) {
        logoutCallback?()
    }

    @IBAction func didTap(_ sender: Any) {
        view.endEditing(true)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(EditableTableViewCell.self)
        // Do any additional setup after loading the view.
    }
}

extension UserInfoViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

enum UserInfoType: Int, CaseIterable {
    case name, group
}

extension UserInfoViewController: UITableViewDataSource {
    enum UserInfoSections: Int, CaseIterable {
        case general, groupmates
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch UserInfoSections(rawValue: section)! {
        case .general:
            return UserInfoType.allCases.count
        case .groupmates:
            return groupmates?.count ?? 0
        }
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return UserInfoSections.allCases.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch UserInfoSections(rawValue: indexPath.section)! {
        case .general:
            return getUserInfoCell(in: tableView, for: indexPath)
        case .groupmates:
            return getGroupmateCell(in: tableView, for: indexPath)
        }
    }

    func getUserInfoCell(in tableView: UITableView, for indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "EditableTableViewCell", for: indexPath)
        guard let editableCell = cell as? EditableTableViewCell else { return cell }
        editableCell.textField.text = getText(indexPath)
        editableCell.type = UserInfoType(rawValue: indexPath.row)
        editableCell.endEditingCallback = updateUserInfo
        return editableCell
    }

    func updateUserInfo(text: String, type: UserInfoType) {
        guard !text.isEmpty else { tableView.reloadData(); return }
        if type == .group {
            info?.group = text
        } else {
            info?.name = text
        }
        userInfoSelectedCallback?(text, type)
    }

    private func getText(_ indexPath: IndexPath) -> String? {
        switch UserInfoType(rawValue: indexPath.row)! {
        case .name:
            return info?.name
        case .group:
            return info?.group
        }
    }

    func getGroupmateCell(in tableView: UITableView, for indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "1")
        if cell == nil {
            cell = UITableViewCell(style: .default, reuseIdentifier: "1")
        }
        cell?.textLabel?.text = groupmates?[indexPath.row].name ?? ""
        return cell!
    }

    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        let subview = UIView(frame: view.bounds)
        subview.backgroundColor = UIColor(named: "accent-color")
        view.insertSubview(subview, at: 1)
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch UserInfoSections(rawValue: section)! {
        case .general:
            return "Обо мне"
        case .groupmates:
            return "Одногруппники"
        }
    }
}
