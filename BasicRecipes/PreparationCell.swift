//
//  PreparationCell.swift
//  BasicRecipes
//
//  Created by Yanni Speron on 11/30/20.
//

import UIKit

class PreparationCell: UITableViewCell {
    @IBOutlet weak var preparationImage: UIImageView!
    @IBOutlet weak var preparationLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
