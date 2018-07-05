//
//  CreateAccountViewController.swift
//  MicroBloggingApp
//
//  Created by Nikita Votyakov on 05.07.2018.
//  Copyright © 2018 Nikita Votyakov. All rights reserved.
//

import Foundation
import Firebase

class CreateAccountViewController: UIViewController {
    
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.passwordTextField.isSecureTextEntry = true
        
        self.usernameTextField.setBottomBorder()
        self.emailTextField.setBottomBorder()
        self.passwordTextField.setBottomBorder()
    }
    
    @IBAction func createAccountButtonTapped(_ sender: UIButton) {
        AuthenticationManager.shared().signUp(withEmail: emailTextField.text!,
                                              password: passwordTextField.text!,
                                              username: usernameTextField.text!,
                                              photoURLString: "") { (user, error) in
            self.performSegue(withIdentifier: "NewLoggedIn", sender: nil)
        }
    }
    
    @IBAction func cancelCreateAccount(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
}
