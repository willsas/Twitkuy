//
//  PlaceCustomTableViewCell.swift
//  Twitkuy
//
//  Created by Willa on 08/10/19.
//  Copyright © 2019 WillaSaskara. All rights reserved.
//

import UIKit

class PlaceCustomTableViewCell: UITableViewCell {
    
    @IBOutlet var placeNameOutlet: UILabel!
    @IBOutlet var imageOutlet: UIImageView!
    @IBOutlet var adressOutlet: UILabel!
    @IBOutlet var distanceOutlet: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
