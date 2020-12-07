//
//  LoginViewController.swift
//  BasicRecipes
//
//  Created by Sherb on 12/7/20.
//

import UIKit
import Parse

class LoginViewController: UIViewController {
    
    @IBOutlet weak var emailField: UITextField!
    
    @IBOutlet weak var passwordField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the vi
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if UserDefaults.standard.bool(forKey: "userLoggedIn") == true {
            self.performSegue(withIdentifier: "loginSegue", sender: nil)
        }
    }
    
    @IBAction func onLoginButton(_ sender: Any) {
        let email = emailField.text!
        let password = passwordField.text!
        
        
        PFUser.logInWithUsername(inBackground: email, password: password){
            (user, error) in
            if user != nil  {
                // remember that the user is still logged in
                UserDefaults.standard.set(true, forKey: "userLoggedIn")
                self.performSegue(withIdentifier: "loginSegue", sender: nil)
            } else{
                print("Error:\(String(describing: error?.localizedDescription))")
            }
        }
    }
    @IBAction func onSignUpButton(_ sender: Any) {
        let user = PFUser()
        user.username = emailField.text // has to be user.username. not user.email
        user.password = passwordField.text
        user.signUpInBackground{ (success, error) in
            if success {
                self.performSegue(withIdentifier: "loginSegue", sender: nil)
            } else{
                print("Error: \(String(describing: error?.localizedDescription))")
            }
        }
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
