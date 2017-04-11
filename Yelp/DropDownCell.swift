//
//  DropDownCell.swift
//  Yelp
//
//  Created by Golla, Chaitanya Teja on 4/10/17.
//  Copyright © 2017 Timothy Lee. All rights reserved.
//

import UIKit

class DropDownCell: UITableViewCell {

    @IBOutlet weak var dropDownLabel: UILabel!
    @IBOutlet weak var dropDownImageView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.selectionStyle = .none
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
