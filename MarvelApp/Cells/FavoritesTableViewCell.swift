//
//  FavoritesTableViewCell.swift
//  MarvelApp
//
//  Created by BarisOdabasi on 1.01.2022.
//

import UIKit

class FavoritesTableViewCell: UITableViewCell {

    @IBOutlet weak var favoritesNameLabel: UILabel!
    @IBOutlet weak var favoritesImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
       
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

      
    }

}
