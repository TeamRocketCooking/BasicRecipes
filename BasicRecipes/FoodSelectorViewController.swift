//
//  FoodSelectorViewController.swift
//  BasicRecipes
//
//  Created by Yanni Speron on 11/30/20.
//

import UIKit
import Parse
import AlamofireImage

class FoodSelectorViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    var category: PFObject!
    var foods = [PFObject]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self

        // Do any additional setup after loading the view.
        
        let query = PFQuery(className:"Food")
        query.whereKey("category", equalTo: category.objectId!)
        query.findObjectsInBackground {( fetchedFoods: [PFObject]?, error: Error? ) in
            if let error = error {
                print(error.localizedDescription)
            } else if let unwrappedFoods = fetchedFoods {
                self.foods = unwrappedFoods
            }
            self.tableView.reloadData()
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return foods.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FoodCell") as! FoodCell
        
        let food = foods[indexPath.row]
        cell.foodLabel.text = food["name"] as? String
        
        let imageFile = food["image"] as! PFFileObject
        let urlString = imageFile.url!
        let url = URL(string: urlString)!
        let objectId = food.objectId!
        cell.objectId = objectId
        
        if PFUser.current() != nil {
            let favorites = PFUser.current()!["favorites"] as! [String]
            var favorited = false
            if favorites.firstIndex(of: objectId) != nil {
                favorited = true
            }
            
            if (favorited) {
                cell.favoriteImage.setImage(UIImage(systemName: "star.fill")!.withTintColor(UIColor.systemYellow, renderingMode: .alwaysTemplate), for: .normal)
                cell.isFavorited = true
            } else {
                cell.favoriteImage.setImage(UIImage(systemName: "star")!.withTintColor(UIColor.systemYellow, renderingMode: .alwaysTemplate), for: .normal)
                cell.isFavorited = false
            }
        }
        
        cell.foodImage.layer.masksToBounds = true
        cell.foodImage.layer.borderWidth = 5
        cell.foodImage.layer.borderColor = UIColor.black.cgColor
        cell.foodImage.layer.cornerRadius = 25
        
        cell.layer.masksToBounds = true
        cell.layer.borderWidth = 5
        cell.layer.borderColor = UIColor.black.cgColor
        cell.layer.cornerRadius = 25
        
        cell.foodImage.af.setImage(withURL: url)
        
        return cell
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        
        if let foodViewController = segue.destination as? FoodViewController {
            if let cell = sender as? UITableViewCell {
                if let indexPath = tableView.indexPath(for: cell) {
                    foodViewController.food = foods[indexPath.row]
                    
                    tableView.deselectRow(at: indexPath, animated: true)
                }
            }
        } else if let accountViewController = segue.destination as? AccountViewController {
            accountViewController.refreshFoodClosure = { self.tableView.reloadData()
            }
        }
    }
    

}
