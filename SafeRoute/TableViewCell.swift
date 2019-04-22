//
//  TableViewCell.swift
//  SafeRoute
//
//  Created by Pujan Tandukar on 4/18/19.
//  Copyright © 2019 Pujan Tandukar. All rights reserved.
//

import UIKit

class TableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    @IBOutlet var mainImageView: UIImageView!
    @IBOutlet var labelView: UILabel!
    
    
}
