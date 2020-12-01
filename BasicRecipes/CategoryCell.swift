//
//  CategoryCell.swift
//  BasicRecipes
//
//  Created by Sherb on 11/30/20.
//

import UIKit

class CategoryCell: UITableViewCell {

    @IBOutlet weak var CategoryImageView: UIImageView!
    
    @IBOutlet weak var categoryLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
