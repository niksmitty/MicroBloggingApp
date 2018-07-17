//
//  LoginViewController.swift
//  MicroBloggingApp
//
//  Created by Nikita Votyakov on 01.03.18.
//  Copyright © 2018 Nikita Votyakov. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.passwordTextField.isSecureTextEntry = true
        
        self.emailTextField.setBottomBorder()
        self.passwordTextField.setBottomBorder()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        AuthenticationManager.shared().addStateDidChangeListener { (auth, user) in
            if let name = user?.displayName {
                print(name)
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if AuthenticationManager.shared().isCurrentUserExist() {
            self.performSegue(withIdentifier: "LoggedIn", sender: nil)
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        AuthenticationManager.shared().removeStateDidChangeListener()
    }
    
    @IBAction func loginButtonTapped(_ sender: UIButton) {
        AuthenticationManager.shared().signIn(withEmail: emailTextField.text!, password: passwordTextField.text!) { (user, error) in
            self.performSegue(withIdentifier: "LoggedIn", sender: nil)
        }
    }
    
}
