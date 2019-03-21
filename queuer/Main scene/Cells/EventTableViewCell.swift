//
//  NewTableViewCell.swift
//  queuer
//
//  Created by Денис on 20/03/2019.
//  Copyright © 2019 Денис. All rights reserved.
//

import UIKit

protocol DateObserver {
    func didUpdate()
}

class EventTableViewCell: UITableViewCell, DateObserver {
    @IBOutlet var roundedView: UIView!
    @IBOutlet var actionButton: UIButton!
    @IBOutlet var detailLabel: UILabel!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var timeLabel: UILabel!

    var dateCounter: DateCounter?

    var date: Date? {
        didSet {
            dateCounter = DateCounter(date: date!)
            dateCounter!.observer = self
        }
    }
    
    var event: Event? {
        didSet {
            date = event?.date
            titleLabel.text = event?.name
            detailLabel.text = event?.readableDate
        }
    }

    func update() {
        if type == .new {
            dateCounter?.update()
        } else {
            timeLabel.text = positionString
        }
    }
    
    var positionString: String {
        return String(event?.position ?? 0) + "й"
    }

    func didUpdate() {
        timeLabel.text = dateCounter?.text
    }

    var type: EventsViewController.EventTableSections? {
        didSet {
            actionButton.isHidden = type != .available
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        roundedView.layer.cornerRadius = 15
        actionButton.layer.cornerRadius = 15
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func didButtonTap(_ sender: Any) {
    }
}
