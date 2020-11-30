//
//  FoodCell.swift
//  BasicRecipes
//
//  Created by Yanni Speron on 11/30/20.
//

import UIKit

class FoodCell: UITableViewCell {
    @IBOutlet weak var foodLabel: UILabel!
    @IBOutlet weak var foodImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
