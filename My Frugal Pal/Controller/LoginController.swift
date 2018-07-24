//
//  LoginController.swift
//  My Frugal Pal
//
//  Created by Zackarin Necesito on 6/21/18.
//  Copyright © 2018 Zackarin Necesito. All rights reserved.
//

import UIKit
import Firebase
import ProgressHUD
 
class LoginController: UIViewController {
    
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    
    @IBAction func loginButtonPressed(_ sender: Any) {
        
        self.loginButton.isEnabled = false
        ProgressHUD.show()
        
        Auth.auth().signIn(withEmail: emailTextField.text!, password: passwordTextField.text!) { (user, error) in
            if error != nil {
                
                let alert = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: .alert)
                
                let cancelAction = UIAlertAction(title: "OK", style: .cancel)
                
                alert.addAction(cancelAction)
                
                self.present(alert, animated: true, completion: nil)
                
            }
            else {
                //success
                ProgressHUD.dismiss()
                self.loginButton.isEnabled = true
                
                self.performSegue(withIdentifier: "loginSegue", sender: self)
                
            }
            
        }
        
        ProgressHUD.dismiss()
        
    }
    
    @IBAction func backButtonPressed(_ sender: Any) {
        
        self.dismiss(animated: true, completion: nil)
        
    }
}
