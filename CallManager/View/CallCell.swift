//
//  CallCell.swift
//  CallManager
//
//  Created by James Thomson on 17/01/2019.
//  Copyright © 2019 James Thomson. All rights reserved.
//

import UIKit

class CallCell: UITableViewCell {
    @IBOutlet weak var callNumberLabel: UILabel!
    @IBOutlet weak var callDateLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
