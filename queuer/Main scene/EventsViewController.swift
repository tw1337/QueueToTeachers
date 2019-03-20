//
//  EventsViewController.swift
//  queuer
//
//  Created by Денис on 19/03/2019.
//  Copyright © 2019 Денис. All rights reserved.
//

import Foundation
import UIKit

class EventsViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    
    var plusCallback: (() -> ())?
    
    @IBAction func didPlusTap(_ sender: Any) {
        plusCallback?()
    }
    override func viewWillAppear(_ animated: Bool) {

    }
    
}
