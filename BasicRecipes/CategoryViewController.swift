//
//  CategoryViewController.swift
//  BasicRecipes
//
//  Created by Sherb on 11/30/20.
//

import UIKit
import Parse
import AlamofireImage

class CategoryViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    
    var categories = [PFObject]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self

        // Do any additional setup after loading the view.
        let query = PFQuery(className:"Category")
        query.findObjectsInBackground {( fetchedCategories: [PFObject]?, error: Error? ) in
            if let error = error {
                print(error.localizedDescription)
            } else if let unwrappedCategories = fetchedCategories {
                self.categories = unwrappedCategories
            }
            self.tableView.reloadData()
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell") as! CategoryCell
        
        let category = categories[indexPath.row]
        cell.categoryLabel.text = category["name"] as? String
        
        let imageFile = category["image"] as! PFFileObject
        let urlString = imageFile.url!
        let url = URL(string: urlString)!
        
        cell.categoryImage.af.setImage(withURL: url)
        
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        let cell = sender as! UITableViewCell
        let indexPath = tableView.indexPath(for: cell)!
        
        let foodSelectorViewController = segue.destination as! FoodSelectorViewController
        foodSelectorViewController.category = categories[indexPath.row]
        
        tableView.deselectRow(at: indexPath, animated: true)
    }

}
