//
//  MarvelTableViewCell.swift
//  MarvelApp
//
//  Created by BarisOdabasi on 31.12.2021.
//

import UIKit

class MarvelTableViewCell: UITableViewCell {
    
    @IBOutlet weak var marvelNameImage: UIImageView!
    @IBOutlet weak var marvelNameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
