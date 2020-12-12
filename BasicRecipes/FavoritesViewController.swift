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
        
        self.notLoggedInLabel.alpha = 0.0
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.notLoggedInLabel.alpha = 0.0
        if PFUser.current() == nil {
            self.performSegue(withIdentifier: "favoritesToLogin", sender: nil)
            foods.removeAll()
            self.tableView.reloadData()
        } else {
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
        }
    }
    
    func refresh() {
        if PFUser.current() != nil {
            loggedIn()
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
            self.tableView.reloadData()
        }
    }
    
    func notLoggedIn() {
        UIView.animate(withDuration: 0.35) {
            self.notLoggedInLabel.alpha = 1.0
        }
        print("Not logged in")
    }
    
    func loggedIn() {
        self.notLoggedInLabel.alpha = 0.0
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        UIView.animate(withDuration: 0.35) {
            self.loggedIn()
        }
        if let foodViewController = segue.destination as? FoodViewController {
            if let cell = sender as? UITableViewCell {
                if let indexPath = tableView.indexPath(for: cell) {
                    foodViewController.food = foods[indexPath.row]
                    tableView.deselectRow(at: indexPath, animated: true)
                }
            }
        } else if let loginViewController = segue.destination as? LoginViewController {
            loginViewController.refreshFavoritesClosure = {
                self.refresh()
            }
            loginViewController.alertNotLoggedInFavoritesClosure = {
                self.notLoggedIn()
            }
        } else if let accountViewController = segue.destination as? AccountViewController {
            accountViewController.refreshFavoritesClosure = {
                self.refresh()
            }
            accountViewController.alertNotLoggedInFavoritesClosure = {
                self.notLoggedIn()
            }
        }
    }
}
