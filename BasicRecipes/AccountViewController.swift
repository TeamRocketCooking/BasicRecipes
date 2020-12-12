//
//  AccountViewController.swift
//  BasicRecipes
//
//  Created by Yanni Speron on 12/9/20.
//

import UIKit
import Parse

class AccountViewController: UIViewController {
    
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var emailIndicatorLabel: UILabel!
    
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var logoutButton: UIButton!
    
    var refreshFavoritesClosure: (() -> Void)?
    var alertNotLoggedInFavoritesClosure: (() -> Void)?
    
    var refreshFoodClosure: (() -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if PFUser.current() != nil {
            emailLabel.text = PFUser.current()?.email
            UIView.animate(withDuration: 0.35) {
                self.showAccountView()
            }
        }
    }
    
    func hideAccountView() {
        self.emailLabel.alpha = 0.0
        self.emailIndicatorLabel.alpha = 0.0
        self.logoutButton.alpha = 0.0
    }
    
    func showAccountView() {
        self.emailLabel.alpha = 1.0
        self.emailIndicatorLabel.alpha = 1.0
        self.logoutButton.alpha = 1.0
    }
    
    func hideLoginView() {
        self.errorLabel.alpha = 0.0
        self.loginButton.alpha = 0.0
    }
    
    func showLoginView() {
        self.errorLabel.alpha = 1.0
        self.loginButton.alpha = 1.0
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if PFUser.current() == nil {
            self.performSegue(withIdentifier: "accountToLogin", sender: nil)
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        if let unwrappedRefreshFavoritesClosure = refreshFavoritesClosure {
            unwrappedRefreshFavoritesClosure()
        }
        if PFUser.current() == nil {
            if let unwrappedAlertNotLoggedInFavoritesClosure = alertNotLoggedInFavoritesClosure {
                unwrappedAlertNotLoggedInFavoritesClosure()
            }
        } else {
            if let unwrappedRefreshFoodClosure = refreshFoodClosure {
                unwrappedRefreshFoodClosure()
            }
        }
    }
    
    @IBAction func logout(_ sender: Any) {
        PFUser.logOut()
        self.dismiss(animated: true)
    }
    
    @IBAction func login(_ sender: Any) {
        if PFUser.current() == nil {
            self.performSegue(withIdentifier: "accountToLogin", sender: nil)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        UIView.animate(withDuration: 0.35) {
            self.hideLoginView()
        }
        if let loginViewController = segue.destination as? LoginViewController {
            loginViewController.alertNotLoggedInAccountClosure = {
                UIView.animate(withDuration: 0.35) {
                    self.hideAccountView()
                    
                    self.showLoginView()
                }
            }
            loginViewController.refreshAccountClosure = {
                self.emailLabel.text = PFUser.current()?.email
                UIView.animate(withDuration: 0.35) {
                    self.showAccountView()
                    
                    self.hideLoginView()
                }
            }
        }
    }
}
