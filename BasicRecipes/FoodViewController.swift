//
//  FoodViewController.swift
//  BasicRecipes
//
//  Created by Yanni Speron on 11/30/20.
//

import UIKit
import Parse

class FoodViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    var food: PFObject!
    var preparations = [PFObject]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self

        // Do any additional setup after loading the view.
        var parseObjects = [PFObject]()
        let preparationsList = food["preparations"] as! [String]
        for prep in preparationsList {
            parseObjects.append(PFObject.init(withoutDataWithClassName: "Preparation", objectId: prep))
        }
        
        PFObject.fetchAll(inBackground: parseObjects) { (fetchedPreparations, error) in
            if let objects = fetchedPreparations as? [PFObject] {
                self.preparations = objects
            } else {
                print("Invalid objectId stored in preparations array")
            }
            self.tableView.reloadData()
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return preparations.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PreparationCell") as! PreparationCell
        
        let preparation = preparations[indexPath.row]
        cell.preparationLabel.text = preparation["name"] as? String
        
        let imageFile = preparation["image"] as! PFFileObject
        let urlString = imageFile.url!
        let url = URL(string: urlString)!
        
        cell.preparationImage.af.setImage(withURL: url)
        
        return cell
    }
    
    // Added height to the table view cells
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        let cell = sender as! UITableViewCell
        let indexPath = tableView.indexPath(for: cell)!
        
        let preparationViewController = segue.destination as! PreparationViewController
        preparationViewController.preparation = preparations[indexPath.row]
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    

}
