//
//  EditableTableViewCell.swift
//  queuer
//
//  Created by Денис on 22/03/2019.
//  Copyright © 2019 Денис. All rights reserved.
//

import UIKit

class EditableTableViewCell: UITableViewCell, UITextFieldDelegate {
    
    @IBOutlet weak var textField: UITextField!
    var endEditingCallback: ((String, UserInfoType) -> ())?
    var type: UserInfoType?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        textField.delegate = self
        // Initialization code
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        endEditingCallback?(textField.text!, type!)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        
        // Configure the view for the selected state
    }
    
}
