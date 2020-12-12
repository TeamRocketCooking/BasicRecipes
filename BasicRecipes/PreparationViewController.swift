//
//  PreparationViewController.swift
//  BasicRecipes
//
//  Created by Yanni Speron on 11/30/20.
//

import UIKit
import Parse
import AlamofireImage

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
        stepsTable.rowHeight = 120
        
        nameLabel.text = preparation["name"] as? String
        // Do any additional setup after loading the view.
        
        let imageFile = preparation["image"] as! PFFileObject
        let urlString = imageFile.url!
        let url = URL(string: urlString)!
        
        preparationImage.layer.masksToBounds = true
        preparationImage.layer.borderWidth = 5
        preparationImage.layer.borderColor = UIColor.black.cgColor
        preparationImage.layer.cornerRadius = 25
        
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
        
        //cell.layer.masksToBounds = true
        cell.layer.borderWidth = 5
        cell.layer.borderColor = UIColor.black.cgColor
        cell.layer.cornerRadius = 25
        
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
