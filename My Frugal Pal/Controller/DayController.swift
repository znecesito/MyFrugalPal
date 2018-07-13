//
//  DayController.swift
//  My Frugal Pal
//
//  Created by Zackarin Necesito on 6/12/18.
//  Copyright © 2018 Zackarin Necesito. All rights reserved.
//

import UIKit
import Firebase

class DayController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var spentLabel: UILabel!
    @IBOutlet weak var addPurchaseLabel: UITextField!
    @IBOutlet weak var subtractPurchaseLabel: UITextField!
    
    let numberFormatter = NumberFormatter()
    //numberFormatter.number(from: number)?.doubleValue
    
    var dayOfWeek : Int?
    //var weeklyBudgetDictionary : Dictionary<String, Double>?
    let dailySpendingsDB = Database.database().reference().child((Auth.auth().currentUser?.uid)!)
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        addPurchaseLabel.delegate = self
        subtractPurchaseLabel.delegate = self
        
        addPurchaseLabel.keyboardType = .numberPad
        subtractPurchaseLabel.keyboardType = .numberPad
        
        //functionality
        setUILabel()
    }
    
    func setDay() -> String {
        
        var dayStr : String = ""
        
        let calendar = Calendar.current
        dayStr = calendar.weekdaySymbols[dayOfWeek!]
        
        return dayStr
        
    }
    
    func setUILabel() {
      
        dailySpendingsDB.child("Daily Spending").observe(DataEventType.value) { (snapshot) in
            
            if snapshot.hasChildren(){
                
                let snapshotValue = snapshot.value as! Dictionary<String,Double>
                let moneyValue = snapshotValue[self.setDay()]!
            
                self.spentLabel.text = "$\(moneyValue)"
            }
            
        }

    }
    
    func writeToFireBase(moneyIncremented: Double, operation: (Double) -> Void) {
        
        operation(moneyIncremented)
        
    }
    
    func add(moneyAdded: Double) {
        
        dailySpendingsDB.child("Daily Spending").observeSingleEvent(of: DataEventType.value, with: { (snapshot) in
            
            if snapshot.hasChildren(){
                
                let snapshotValue = snapshot.value as! Dictionary<String,Double>
                
                let moneyValue = snapshotValue[self.setDay()]!
                
                var tempDouble = moneyValue
                
                tempDouble += moneyAdded
                
                self.dailySpendingsDB.child("Daily Spending").updateChildValues([self.setDay() : tempDouble])
                
            }
            
        })
        
    }
    
    func subtract(moneySubtracted: Double) {
        
        dailySpendingsDB.child("Daily Spending").observeSingleEvent(of: DataEventType.value, with: { (snapshot) in
            
            if snapshot.hasChildren(){
                
                let snapshotValue = snapshot.value as! Dictionary<String,Double>
                
                let moneyValue = snapshotValue[self.setDay()]!
                
                var tempDouble = moneyValue
                
                tempDouble -= moneySubtracted
                
                self.dailySpendingsDB.child("Daily Spending").updateChildValues([self.setDay() : tempDouble])
                
            }
            
        })
        
    }
    
    @IBAction func backButtonPressed(_ sender: Any) {
        
        self.dismiss(animated: true, completion: nil)
        
    }
    
    @IBAction func addPurchasePressed(_ sender: Any) {
        
        if addPurchaseLabel.hasText {
            
            let moneyAdded = numberFormatter.number(from: addPurchaseLabel.text!)?.doubleValue

            writeToFireBase(moneyIncremented: moneyAdded!, operation: add)
            
        }
        else {
            
            let alert = UIAlertController(title: "Error", message: "Type a the number", preferredStyle: .alert)
            
            let cancelAction = UIAlertAction(title: "OK", style: .cancel)
            
            alert.addAction(cancelAction)
            
            present(alert, animated: true, completion: nil)
            
        }
        
    }
    
    
    @IBAction func subtractPurchasePressed(_ sender: Any) {
        
        if subtractPurchaseLabel.hasText {
            
            let moneySubtracted = numberFormatter.number(from: subtractPurchaseLabel.text!)?.doubleValue
            
            writeToFireBase(moneyIncremented: moneySubtracted!, operation: subtract)
            
        }
        else {
            
            let alert = UIAlertController(title: "Error", message: "Type a the number", preferredStyle: .alert)
            
            let cancelAction = UIAlertAction(title: "OK", style: .cancel)
            
            alert.addAction(cancelAction)
            
            present(alert, animated: true, completion: nil)
            
        }
        
    }
    
}
