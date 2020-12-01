//
//  FavoritesViewController.swift
//  BasicRecipes
//
//  Created by Yanni Speron on 11/30/20.
//

import UIKit
import Parse
import AlamofireImage

class FavoritesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    
    var foods = [PFObject]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        var savedFavorites = [String]()
        
        if let favoritesDefaults = UserDefaults.standard.array(forKey: "favorites") as? [String] {
            savedFavorites = favoritesDefaults
        }
        
        // LOAD THE FOOD DATA FROM THE SERVER
        var parseObjects = [PFObject]()
        for favoriteFood in savedFavorites {
            parseObjects.append(PFObject.init(withoutDataWithClassName: "Food", objectId: favoriteFood))
        }
        
        PFObject.fetchAll(inBackground: parseObjects) { (fetchedFoods, error) in
            if let objects = fetchedFoods as? [PFObject] {
                self.foods = objects
            } else {
                print("Invalid objectId stored in favorites array")
            }
            self.tableView.reloadData()
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return foods.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FavoriteFoodCell") as! FavoriteFoodCell
        
        let food = foods[indexPath.row]
        cell.foodLabel.text = food["name"] as? String
        
        let imageFile = food["image"] as! PFFileObject
        let urlString = imageFile.url!
        let url = URL(string: urlString)!
        
        cell.foodImage.af.setImage(withURL: url)
        
        return cell
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        
        let cell = sender as! UITableViewCell
        let indexPath = tableView.indexPath(for: cell)!
        
        // Pass the selected movie to the details view controller
        let foodViewController = segue.destination as! FoodViewController
        foodViewController.food = foods[indexPath.row]
        
        tableView.deselectRow(at: indexPath, animated: true)
    }

}
