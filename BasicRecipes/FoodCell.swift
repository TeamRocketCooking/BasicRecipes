//
//  FoodCell.swift
//  BasicRecipes
//
//  Created by Yanni Speron on 11/30/20.
//

import UIKit
import Parse

class FoodCell: UITableViewCell {
    @IBOutlet weak var foodImage: UIImageView!
    @IBOutlet weak var foodLabel: UILabel!
    @IBOutlet weak var favoriteImage: UIButton!
    
    var objectId: String!
    var isFavorited = false
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    @IBAction func toggleFavorite(_ sender: Any) {
        if PFUser.current() != nil {
            if (isFavorited) {
                unfavorite()
            } else {
                favorite()
            }
        } else {
            
        }
    }
    
    private func favorite() {
        var favorites = PFUser.current()!["favorites"] as! [String]
        favorites.append(objectId)
        PFUser.current()!["favorites"] = favorites
        PFUser.current()!.saveInBackground()
        
        favoriteImage.setImage(UIImage(systemName: "star.fill")!.withTintColor(UIColor.systemYellow, renderingMode: .alwaysTemplate), for: .normal)
        isFavorited = true
    }
    
    private func unfavorite() {
        var favorites = PFUser.current()!["favorites"] as! [String]
        if let index = favorites.firstIndex(of: objectId) {
            favorites.remove(at: index)
        }
        PFUser.current()!["favorites"] = favorites
        PFUser.current()!.saveInBackground()
        
        favoriteImage.setImage(UIImage(systemName: "star")!.withTintColor(UIColor.systemYellow, renderingMode: .alwaysTemplate), for: .normal)
        isFavorited = false
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
