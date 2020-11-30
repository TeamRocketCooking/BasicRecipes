//
//  PreparationViewController.swift
//  BasicRecipes
//
//  Created by Yanni Speron on 11/30/20.
//

import UIKit
import Parse

class PreparationViewController: UIViewController {
    
    @IBOutlet weak var nameLabel: UILabel!
    
    var preparation: PFObject!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        nameLabel.text = preparation["name"] as? String
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        
    }
    */

}
