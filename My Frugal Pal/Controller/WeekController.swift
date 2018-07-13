//
//  BudgetController.swift
//  My Frugal Pal
//
//  Created by Zackarin Necesito on 6/12/18.
//  Copyright © 2018 Zackarin Necesito. All rights reserved.
//

import UIKit
import Firebase
import ChameleonFramework

class WeekController: UIViewController {
    
    @IBOutlet weak var budgetLabel: UILabel!
    @IBOutlet weak var sundayLabel: UILabel!
    @IBOutlet weak var mondayLabel: UILabel!
    @IBOutlet weak var tuesdayLabel: UILabel!
    @IBOutlet weak var wednesdayLabel: UILabel!
    @IBOutlet weak var thursdayLabel: UILabel!
    @IBOutlet weak var fridayLabel: UILabel!
    @IBOutlet weak var saturdayLabel: UILabel!
    
    let numberFormatter = NumberFormatter()
    let weeklyBudget = User()
    var dayPressed : Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        retrieveBudget()
        retrieveSpendDaily()
                
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func backButtonPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func retrieveBudget() {
        
        let updateDB = Database.database().reference().child((Auth.auth().currentUser?.uid)!)
        
        updateDB.observe(DataEventType.value, with: { (snapshot) in
            
            if snapshot.childSnapshot(forPath: "Budget").hasChildren(),
                snapshot.childSnapshot(forPath: "Daily Spending").hasChildren() {
                
                let budgetValue = snapshot.childSnapshot(forPath: "Budget").value as! Dictionary<String,String>
                let spendValue = snapshot.childSnapshot(forPath: "Daily Spending").value as! Dictionary<String,Double>
                
                var totalSpent = 0.0
                
                for (_, money) in spendValue {
                    
                    totalSpent += money
                    
                }
                
                var currentBudget = self.numberFormatter.number(from: budgetValue["Budget"]!)?.doubleValue
                
                currentBudget = currentBudget! - totalSpent
                
                self.budgetLabel.text = "$\(currentBudget!)"
                
                if currentBudget! > 0 {
                    self.budgetLabel.textColor = UIColor.flatGreenDark
                } else if currentBudget! < 0{
                    self.budgetLabel.textColor = UIColor.red
                }
                
            }
            
        })
        
    }
    
    func retrieveSpendDaily() {
        
        let spendDB = Database.database().reference().child((Auth.auth().currentUser?.uid)!)
        
        spendDB.child("Daily Spending").observe(DataEventType.value) { (snapshot) in
            
            if snapshot.hasChildren() {
                
                if self.checkDate() {
                    
                    spendDB.child("Daily Spending").setValue(self.weeklyBudget.dailySpending)
                    
                }
                
                let snapshotValue = snapshot.value as! Dictionary<String, Double>
                
                self.setWeeklyLabels(spentOnDay: snapshotValue)
                
            }
            
        }
        
    }
    
    func setWeeklyLabels(spentOnDay: Dictionary<String, Double>) {
        
        sundayLabel.text = "$\(spentOnDay["Sunday"]!)"
        mondayLabel.text = "$\(spentOnDay["Monday"]!)"
        tuesdayLabel.text = "$\(spentOnDay["Tuesday"]!)"
        wednesdayLabel.text = "$\(spentOnDay["Wednesday"]!)"
        thursdayLabel.text = "$\(spentOnDay["Thursday"]!)"
        fridayLabel.text = "$\(spentOnDay["Friday"]!)"
        saturdayLabel.text = "$\(spentOnDay["Saturday"]!)"
        
    }
    
    func checkDate() -> Bool {
        
        let date = Date()
        let calendar = Calendar.current
        let day = calendar.component(.weekday, from: date)
                
        if day == 1 {
            return true
        }
        
        return false
        
    }
    
    @IBAction func sundayPressed(_ sender: Any) {
        
        dayPressed = 0
        performSegue(withIdentifier: "goToDayController", sender: self)
        
    }
    
    @IBAction func mondayPressed(_ sender: Any) {
        
        dayPressed = 1
        performSegue(withIdentifier: "goToDayController", sender: self)
        
    }
    
    @IBAction func tuesdayPressed(_ sender: Any) {
        
        dayPressed = 2
        performSegue(withIdentifier: "goToDayController", sender: self)
        
    }
    
    @IBAction func wednesdayPressed(_ sender: Any) {
        
        dayPressed = 3
        performSegue(withIdentifier: "goToDayController", sender: self)
        
    }
    
    @IBAction func thursdayPressed(_ sender: Any) {
        
        dayPressed = 4
        performSegue(withIdentifier: "goToDayController", sender: self)
        
    }
    
    @IBAction func fridayPressed(_ sender: Any) {
        
        dayPressed = 5
        performSegue(withIdentifier: "goToDayController", sender: self)
        
    }
    
    @IBAction func saturdayPressed(_ sender: Any) {
        
        dayPressed = 6
        performSegue(withIdentifier: "goToDayController", sender: self)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if segue.destination is DayController
        {
            let vc = segue.destination as? DayController
            vc?.dayOfWeek = dayPressed
        }
    }

}
