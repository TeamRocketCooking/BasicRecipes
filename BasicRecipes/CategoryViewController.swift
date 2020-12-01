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

    var categories = [PFObject]()
    @IBOutlet weak var tableView: UITableView!
    
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
        
        cell.CategoryImageView.af.setImage(withURL: url)
        
        return cell
    }
    
    // Added height to the table view cells 
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        let cell = sender as! UITableViewCell
        let indexPath = tableView.indexPath(for: cell)!
        
        let preparationViewController = segue.destination as! PreparationViewController
        //categoryViewController.preparation = categories[indexPath.row]
        
        tableView.deselectRow(at: indexPath, animated: true)
    }

}
