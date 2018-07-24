//
//  RegisterController.swift
//  My Frugal Pal
//
//  Created by Zackarin Necesito on 6/21/18.
//  Copyright © 2018 Zackarin Necesito. All rights reserved.
//

import UIKit
import Firebase
import ProgressHUD

class RegisterController: UIViewController {
    
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func backButtonPressed(_ sender: Any) {
        
        self.dismiss(animated: true, completion: nil)
        
    }
    
    @IBAction func registerButtonPressed(_ sender: Any) {
        
        ProgressHUD.show()

       if usernameField.hasText, passwordField.hasText {
        
            Auth.auth().createUser(withEmail: usernameField.text!, password: passwordField.text!) { (user, error) in
                if error != nil {
                    
                    let alert = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: .alert)
                    
                    let cancelAction = UIAlertAction(title: "OK", style: .cancel)
                    
                    alert.addAction(cancelAction)
                    
                    self.present(alert, animated: true, completion: nil)
                    
                }
                else {
                    //success
                                        
                    ProgressHUD.dismiss()

                    self.performSegue(withIdentifier: "registerCompleteSegue", sender: self)
                    
                }
            }
            
        } else {

            let alert = UIAlertController(title: "Error", message: "Please enter a username and password.", preferredStyle: .alert)

            let cancelAction = UIAlertAction(title: "OK", style: .cancel)

            alert.addAction(cancelAction)

            present(alert, animated: true, completion: nil)

        }
        
        ProgressHUD.dismiss()
        
    }
    
    
}
