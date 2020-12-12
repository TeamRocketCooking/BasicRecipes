//
//  FoodCell.swift
//  BasicRecipes
//
//  Created by Yanni Speron on 11/30/20.
//

import UIKit

class FoodCell: UITableViewCell {
    @IBOutlet weak var foodImage: UIImageView!
    @IBOutlet weak var foodLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    // code gotten from:
    // https://stackoverflow.com/questions/47627658/spacing-between-uitableviewcells-swift3
    override var frame: CGRect {
        get {
            return super.frame
        }
        set (newFrame) {
            var frame =  newFrame
            frame.origin.y += 4
            frame.origin.x += 4
            frame.size.height -= 2 * 2
            frame.size.width -= 2 * 5
            super.frame = frame
        }
      }

}
