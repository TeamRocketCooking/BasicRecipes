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
    @IBOutlet weak var errorMessageLabel: UILabel!
    
    var refreshFavoritesClosure: (() -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the vi
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if PFUser.current() != nil {
            self.performSegue(withIdentifier: "loginSegue", sender: nil)
        }
    }
    
    func onLogin() {
        if let accountViewController = self.presentingViewController as? AccountViewController {
            accountViewController.refresh()
        } else if let unwrappedRefreshFavoritesClosure = refreshFavoritesClosure {
            unwrappedRefreshFavoritesClosure()
        }
    }
    
    @IBAction func onLoginButton(_ sender: Any) {
        let email = emailField.text!
        let password = passwordField.text!
        
        PFUser.logInWithUsername(inBackground: email, password: password){
            (user, error) in
            if user != nil  {
                self.dismiss(animated: true)
                self.onLogin()
            } else{
                print("Error:\(String(describing: error?.localizedDescription))")
                self.errorMessageLabel.text = "Invalid email or password"
            }
        }
    }
    @IBAction func onSignUpButton(_ sender: Any) {
        if (emailField.text!.isEmpty || passwordField.text!.isEmpty) {
            errorMessageLabel.text = "Please enter an email and a password"
        } else {
            let user = PFUser()
            user.username = emailField.text // has to be user.username. not user.email
            user.email = emailField.text
            user.password = passwordField.text
            user.signUpInBackground{ (success, error) in
                if success {
                    self.dismiss(animated: true)
                    self.onLogin()
                } else{
                    print("Error: \(String(describing: error?.localizedDescription))")
                }
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
