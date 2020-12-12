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
    
    @IBOutlet weak var notLoggedInLabel: UILabel!
    
    var foods = [PFObject]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        self.view.bringSubviewToFront(notLoggedInLabel)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if PFUser.current() == nil {
            self.performSegue(withIdentifier: "favoritesToLogin", sender: nil)
        }
        refresh()
    }
    
    func refresh() {
        if PFUser.current() != nil {
            notLoggedInLabel.text = ""
            let objectIDs = PFUser.current()!["favorites"] as! [String]
            print(objectIDs)
            var parseObjects = [PFObject]()
            
            for id in objectIDs {
                parseObjects.append(PFObject.init(withoutDataWithClassName: "Food", objectId: id))
            }
            
            PFObject.fetchAll(inBackground: parseObjects) { (fetchedFoods, error) in
                if let objects = fetchedFoods as? [PFObject] {
                    self.foods = objects
                } else {
                    print("Invalid objectId stored in favorites array")
                }
                self.tableView.reloadData()
            }
        } else {
            foods.removeAll()
            notLoggedInLabel.text = "Please login to view favorites"
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
        
        cell.foodImage.layer.masksToBounds = true
        cell.foodImage.layer.borderWidth = 5
        cell.foodImage.layer.borderColor = UIColor.black.cgColor
        cell.foodImage.layer.cornerRadius = 25
        
        cell.foodImage.af.setImage(withURL: url)
        
        cell.layer.masksToBounds = true
        cell.layer.borderWidth = 5
        cell.layer.borderColor = UIColor.black.cgColor
        cell.layer.cornerRadius = 25
        
        return cell
    }
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        
        if let cell = sender as? UITableViewCell {
            let indexPath = tableView.indexPath(for: cell)!
            
            // Pass the selected movie to the details view controller
            let foodViewController = segue.destination as! FoodViewController
            foodViewController.food = foods[indexPath.row]
            
            tableView.deselectRow(at: indexPath, animated: true)
        } else {
            if let loginViewController = segue.destination as? LoginViewController {
                loginViewController.refreshFavoritesClosure = {
                    self.refresh()
                }
            } else if let accountViewController = segue.destination as? AccountViewController {
                accountViewController.refreshFavoritesClosure = {
                    self.refresh()
                }
            }
        }
    }
    
}
