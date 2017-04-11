//
//  SeeAllCell.swift
//  Yelp
//
//  Created by Golla, Chaitanya Teja on 4/10/17.
//  Copyright © 2017 Timothy Lee. All rights reserved.
//

import UIKit

class SeeAllCell: UITableViewCell {

    @IBOutlet weak var seeAllLabel: UILabel!
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
