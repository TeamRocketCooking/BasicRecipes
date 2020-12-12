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
    
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var signUpButton: UIButton!
    

    
    
    
    var refreshFavoritesClosure: (() -> Void)?
    var alertNotLoggedInFavoritesClosure: (() -> Void)?
    
    var refreshAccountClosure: (() -> Void)?
    var alertNotLoggedInAccountClosure: (() -> Void)?
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loginButton.layer.masksToBounds = true
        //loginButton.layer.borderWidth = 1
        loginButton.layer.borderColor = UIColor.black.cgColor
        loginButton.layer.cornerRadius = 25
        
        signUpButton.layer.masksToBounds = true
        //signUpButton.layer.borderWidth = 1
        signUpButton.layer.borderColor = UIColor.black.cgColor
        signUpButton.layer.cornerRadius = 25
        
        // Do any additional setup after loading the view
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        if PFUser.current() == nil {
            if let unwrappedAlertNotLoggedInAccountClosure = alertNotLoggedInAccountClosure {
                unwrappedAlertNotLoggedInAccountClosure()
            } else if let unwrappedAlertNotLoggedInFavoritesClosure = alertNotLoggedInFavoritesClosure {
                unwrappedAlertNotLoggedInFavoritesClosure()
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
    }
    
    func onLogin() {
        if let unwrappedRefreshAccountClosure = refreshAccountClosure {
            unwrappedRefreshAccountClosure()
        } else if let unwrappedRefreshFavoritesClosure = refreshFavoritesClosure {
            unwrappedRefreshFavoritesClosure()
        }
    }
    
    @IBAction func onLoginButton(_ sender: Any) {
        if (emailField.text!.isEmpty || passwordField.text!.isEmpty) {
            errorMessageLabel.text = "Please enter an email and a password"
        } else if let unwrappedEmailFieldText = emailField.text {
            if let unwrappedPasswordFieldText = passwordField.text  {
                PFUser.logInWithUsername(inBackground: unwrappedEmailFieldText, password: unwrappedPasswordFieldText){
                    (user, error) in
                    if user != nil  {
                        self.dismiss(animated: true)
                        self.onLogin()
                    } else{
                        print("Error: \(String(describing: error?.localizedDescription))")
                        self.errorMessageLabel.text = "Invalid email or password"
                    }
                }
            }
        }
    }
    
    @IBAction func onSignUpButton(_ sender: Any) {
        if (emailField.text!.isEmpty || passwordField.text!.isEmpty) {
            errorMessageLabel.text = "Please enter an email and a password"
        } else if let unwrappedEmailFieldText = emailField.text {
            if let unwrappedPasswordFieldText = passwordField.text  {
                let user = PFUser()
                user.username = unwrappedEmailFieldText
                user.email = unwrappedEmailFieldText
                user.password = unwrappedPasswordFieldText
                user.signUpInBackground{ (success, error) in
                    if success {
                        self.dismiss(animated: true)
                        self.onLogin()
                    } else {
                        print("Error: \(String(describing: error?.localizedDescription))")
                        self.errorMessageLabel.text = "Failed to create account"
                    }
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
