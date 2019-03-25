//
//  ButtonTableViewCell.swift
//  queuer
//
//  Created by Денис on 25/03/2019.
//  Copyright © 2019 Денис. All rights reserved.
//

import UIKit

class ButtonTableViewCell: UITableViewCell {
    var tapCallback: (() -> Void)?

    @IBOutlet weak var button: UIButton!
    @IBAction func didButtonTap(_ sender: Any) {
        tapCallback?()
    }

    override func awakeFromNib() {
        super.awakeFromNib()
//        button.layerGradient()
        button.layer.cornerRadius = 20
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {

        // Configure the view for the selected state
    }
}
