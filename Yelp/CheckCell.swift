//
//  CheckCell.swift
//  Yelp
//
//  Created by Golla, Chaitanya Teja on 4/10/17.
//  Copyright © 2017 Timothy Lee. All rights reserved.
//

import UIKit

class CheckCell: UITableViewCell {

    @IBOutlet weak var checkImageView: UIImageView!
    @IBOutlet weak var checkLabel: UILabel!
    var checkImg: UIImage = (UIImage.init(named: "check")?.withRenderingMode(.alwaysTemplate))!
    var isCheck: Bool = false {
        didSet {
            self.checkImageView.tintColor = isCheck ? UIColor.red : UIColor.lightGray
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.selectionStyle = .none
        self.checkImageView.image = checkImg
        self.checkImageView?.tintColor = UIColor.lightGray
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }

}
