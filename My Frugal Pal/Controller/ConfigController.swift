//
//  ConfigController.swift
//  My Frugal Pal
//
//  Created by Zackarin Necesito on 6/12/18.
//  Copyright © 2018 Zackarin Necesito. All rights reserved.
//

import UIKit
import ProgressHUD
import Firebase

class ConfigController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var budgetLabel: UITextField!
    @IBOutlet weak var spendLabel: UITextField!
    @IBOutlet weak var salaryLabel: UITextField!

    
    let numberFormatter = NumberFormatter()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        budgetLabel.delegate = self
        spendLabel.delegate = self
        salaryLabel.delegate = self
        
        budgetLabel.keyboardType = .numberPad
        spendLabel.keyboardType = .numberPad
        salaryLabel.keyboardType = .numberPad
        
    }
    
    @IBAction func backButtonPressed(_ sender: Any) {

        self.dismiss(animated: true, completion: nil)

    }
    
    @IBAction func saveButtonPressed(_ sender: Any) {
                
        if budgetLabel.hasText {
            
            writeToFireBase()
            
        }
        else {
            
            let saveAlert = UIAlertController(title: "Error", message: "Budget can not be created unless a budget is entered", preferredStyle: .alert)
            
            let cancelAction = UIAlertAction(title: "OK", style: .cancel)
            
            saveAlert.addAction(cancelAction)
            
            present(saveAlert, animated: true, completion: nil)
            
        }
        
    }
    
    @IBAction func calculateButtonPressed(_ sender: Any) {
        
        let tempBudget = createBudget()
        
        if tempBudget > 0.0 {
            budgetLabel.text = String(tempBudget)
        }
        
    }
    
    func createBudget() -> Double {
        
        let dSalary = numberFormatter.number(from: salaryLabel.text!)?.doubleValue
        let dSpending = numberFormatter.number(from: spendLabel.text!)?.doubleValue
        
        var dBudget : Double
        
        if let dSal = dSalary, let dSpen = dSpending {
            
            dBudget = dSal - dSpen
            let divisor = (dBudget/100)
            
            if divisor <= 0 {
                
                let alert = UIAlertController(title: "Whoops!", message: "You spend more than you earn", preferredStyle: .alert)
                
                let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
                
                alert.addAction(cancelAction)
                
                present(alert, animated: true, completion: nil)
                
            }
            else if divisor > 1 {
                
                dBudget = (100 * divisor.rounded(.down))/4
            
            }
            
        }
        else {
            
            let alert = UIAlertController(title: "Error", message: "Please enter Salary and Spendings", preferredStyle: .alert)
            
            let cancelAction = UIAlertAction(title: "OK", style: .cancel)
            
            alert.addAction(cancelAction)
            
            present(alert, animated: true, completion: nil)
            
            dBudget = 0.0
            
        }

        return dBudget
        
    }
    
    func writeToFireBase() {
        
        let tempWeeklyBudget = User()
        
        let budgetDB = Database.database().reference().child((Auth.auth().currentUser?.uid)!)
        
        let budgetDictionary = ["Username": Auth.auth().currentUser?.email,
                                "Budget": budgetLabel.text]
        
        budgetDB.child("Budget").setValue(budgetDictionary) {
            (error, reference) in
            
            if error != nil {
                
                ProgressHUD.showError(error?.localizedDescription)
                
            } else{
                
                ProgressHUD.showSuccess("Budget Saved!")
            }
            
        }
        
        budgetDB.child("Daily Spending").observe(DataEventType.value) { (snapshot) in
            
            if snapshot.hasChildren() == false {
                
                budgetDB.child("Daily Spending").setValue(tempWeeklyBudget.dailySpending) {
                    (error, reference) in
                    
                    if error != nil {
                        
                        ProgressHUD.showError(error?.localizedDescription)
                        
                    } else{
                        
                        print("Daily spendings created!")
                    }
                    
                }
                
            }
            
        }
        
    }
    
}
