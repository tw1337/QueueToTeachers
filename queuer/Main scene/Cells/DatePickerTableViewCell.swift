//
//  DatePickerTableViewCell.swift
//  queuer
//
//  Created by Денис on 22/03/2019.
//  Copyright © 2019 Денис. All rights reserved.
//

import UIKit

protocol DatePickerDelegate {
    func didValueChange(_ newValue: Date)
}

class DatePickerTableViewCell: UITableViewCell {
    
    var delegate: DatePickerDelegate?
    
    @IBAction func didValueChange(_ sender: UIDatePicker) {
        delegate?.didValueChange(sender.date)
    }
    
    @IBOutlet var datePicker: UIDatePicker!
    override func awakeFromNib() {
        super.awakeFromNib()
        let fiveMinutes = 60 * 5
           let week = 60 * 60 * 24 * 14
        datePicker.minimumDate = Date(timeIntervalSinceNow: Double(fiveMinutes))
     
        datePicker.maximumDate = Date(timeIntervalSinceNow: Double(week))
        
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        // Configure the view for the selected state
    }
}
