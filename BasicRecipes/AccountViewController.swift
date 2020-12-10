//
//  AccountViewController.swift
//  BasicRecipes
//
//  Created by Yanni Speron on 12/9/20.
//

import UIKit
import Parse

class AccountViewController: UIViewController {

    @IBOutlet weak var logoutButton: UIButton!
    @IBOutlet weak var emailLabel: UILabel!
    
    var refreshFavoritesClosure: (() -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if PFUser.current() == nil {
            self.performSegue(withIdentifier: "accountToLogin", sender: nil)
        } else {
            emailLabel.text = PFUser.current()?.email
        }
    }
    
    func refresh() {
        emailLabel.text = PFUser.current()?.email
    }
    
    @IBAction func logout(_ sender: Any) {
        PFUser.logOut()
        if let unwrappedRefreshFavoritesClosure = refreshFavoritesClosure {
            unwrappedRefreshFavoritesClosure()
        }
        self.dismiss(animated: true)
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
