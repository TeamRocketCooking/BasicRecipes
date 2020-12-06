//
//  PreparationViewController.swift
//  BasicRecipes
//
//  Created by Yanni Speron on 11/30/20.
//

import UIKit
import Parse

class PreparationViewController: UIViewController, UITableViewDataSource, UITableViewDelegate  {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var preparationImage: UIImageView!
    @IBOutlet weak var stepsTable: UITableView!
    
    var preparation: PFObject!
    
    var steps = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        stepsTable.delegate = self
        stepsTable.dataSource = self
        
        nameLabel.text = preparation["name"] as? String
        // Do any additional setup after loading the view.
        
        let imageFile = preparation["image"] as! PFFileObject
        let urlString = imageFile.url!
        let url = URL(string: urlString)!
        
        preparationImage.af.setImage(withURL: url)
        
        let preparationSteps = preparation["steps"] as? [String]
        
        if let unwrappedPreparationSteps = preparationSteps {
            for step in unwrappedPreparationSteps {
                steps.append(step)
            }
            stepsTable.reloadData()
        } else {
            print("Preparation steps not found!")
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return steps.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PreparationStepCell") as! PreparationStepCell
        
        let step = steps[indexPath.row]
        cell.stepLabel.text = "\(indexPath.row + 1). " + step
        
        return cell
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        
    }*/

}
