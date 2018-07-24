//
//  DayTableViewController.swift
//  My Frugal Pal
//
//  Created by Zackarin Necesito on 7/12/18.
//  Copyright © 2018 Zackarin Necesito. All rights reserved.
//

import UIKit
import ChameleonFramework
import Firebase

class DayTableViewController: UITableViewController {
    
    let dailyDB = Database.database().reference().child((Auth.auth().currentUser?.uid)!).child("Daily Spending")
    var dailySpendings : [Spending] = [Spending]()
    var today : String?
    let numberFormatter = NumberFormatter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = setBG()
        tableView.rowHeight = 45.0
        
        readFromFireBase()

    }
    
    //MARK: - TableView DataSource Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dailySpendings.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "SpentCell", for: indexPath) as! SpentCell
        
        cell.costLabel.text = "$\(dailySpendings[indexPath.row].cost ?? 0.0)"
        cell.itemNameLabel.text = dailySpendings[indexPath.row].name
        
        cell.backgroundColor = setBG()
        
        return cell
    }
    
    //MARK: - TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let delete = deleteAction(at: indexPath)
        
        return UISwipeActionsConfiguration(actions: [delete])
    }

    
    //MARK: - Class methods

    func setBG() -> UIColor {
        
        let colorArray: [UIColor] = ColorsFromImage(#imageLiteral(resourceName: "background_2"), withFlatScheme: true)
        let backGroundColor = GradientColor(.diagonal, frame: self.view.frame, colors: [colorArray[0],colorArray[1]])
        return backGroundColor
    }
    
    func deleteFromFireBase(childIDBeingDeleted childID: String) {
        
        dailyDB.child(today!).child(childID).observeSingleEvent(of: .value) { (snapshot) in
            
            let snapshotValue = snapshot.value as! Dictionary<String,Any>
            
            let costSubtracted = snapshotValue["Cost"]
            
            self.setupSum(accumulatingCost: costSubtracted as! Double, operation: self.subtract)
            
        }
        
        dailyDB.child(today!).child(childID).removeValue()
        
    }
    
    func readFromFireBase() {
        
        dailyDB.child(today!).observe(.childAdded) { (snapshot) in
            
            let snapshotValue = snapshot.value as! Dictionary<String,Any>
            
            let item = snapshotValue["Name"]!
            let cost = snapshotValue["Cost"]!
            let key = snapshotValue["Auto Key"]!
            
            let dailySpending = Spending()
            dailySpending.name = item as? String
            dailySpending.cost = cost as? Double
            dailySpending.key = key as! String
            
            self.dailySpendings.append(dailySpending)
            self.tableView.reloadData()
            
        }
        
        dailyDB.child(today!).observe(.childRemoved) { (snapshot) in
            self.tableView.reloadData()
        }
        
    }
    
    func setupSum(accumulatingCost: Double, operation: (Double) -> Void) {
        
        operation(accumulatingCost)
        
    }
    
    func add(moneyAdded: Double){
        
        let dailySpendingSumDB = Database.database().reference().child((Auth.auth().currentUser?.uid)!).child("Sum")
        
        dailySpendingSumDB.observeSingleEvent(of: .value, with: { (snapshot) in
            
            if snapshot.hasChildren() {
                
                let snapshotValue = snapshot.value as! Dictionary<String,Double>
                var sumValue = snapshotValue[self.today!]
                sumValue? += moneyAdded
                dailySpendingSumDB.updateChildValues([self.today! : sumValue ?? 0.0])
                
            }
            
        })
        
    }
    
    func subtract(moneySubtracted: Double){
        
        let dailySpendingSumDB = Database.database().reference().child((Auth.auth().currentUser?.uid)!).child("Sum")
        
        dailySpendingSumDB.observeSingleEvent(of: .value, with: { (snapshot) in
            
            if snapshot.hasChildren() {
                
                let snapshotValue = snapshot.value as! Dictionary<String,Double>
                var sumValue = snapshotValue[self.today!]
                sumValue? -= moneySubtracted
                dailySpendingSumDB.updateChildValues([self.today! : sumValue ?? 0.0])
                
            }
            
        })
        
    }
    
    func writeToFireBase(item: String, cost: Double){
        
        setupSum(accumulatingCost: cost, operation: add)
        let childIdDB = dailyDB.child(today!).childByAutoId()
        let key = childIdDB.key
        
        let budgetDictionary = ["Name" : item,
                                "Cost" : cost,
                                "Auto Key": key] as [String : Any]
        
        childIdDB.setValue(budgetDictionary)
        
    }
    
    //MARK: - UI Actions

    @IBAction func addButtonPressed(_ sender: Any) {
        
        var itemTextField = UITextField()
        var costTextField = UITextField()

        let alert = UIAlertController(title: "Add Item Spent", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add", style: .default) { (action) in
            //what will happen once the user clicks AddButton item in UIAlert
            let dCost = self.numberFormatter.number(from: costTextField.text!)?.doubleValue
            self.writeToFireBase(item: itemTextField.text!, cost: dCost ?? 0.0)
            
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Item Bought"
            itemTextField = alertTextField
        }
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Cost"
            costTextField = alertTextField
        }
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
        
    }
    
    
    
    func deleteAction(at indexPath: IndexPath) -> UIContextualAction {
        
        let action = UIContextualAction(style: .normal, title: "Delete") { (action, view, completion) in
            self.deleteFromFireBase(childIDBeingDeleted: self.dailySpendings[indexPath.row].key)
            self.dailySpendings.remove(at: indexPath.row)
            completion(true)
        }
        
        action.image = #imageLiteral(resourceName: "delete-icon")
        action.backgroundColor = UIColor.flatRed
        
        return action
        
    }
    
}
