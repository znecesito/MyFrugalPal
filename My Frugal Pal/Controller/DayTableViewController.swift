//
//  DayTableViewController.swift
//  My Frugal Pal
//
//  Created by Zackarin Necesito on 7/12/18.
//  Copyright © 2018 Zackarin Necesito. All rights reserved.
//

import UIKit
import ChameleonFramework

class DayTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    //MARK: - TableView DataSource Methods
//    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return todoItems?.count ?? 1
//    }
//    
//    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        
//        let cell = super.tableView(tableView, cellForRowAt: indexPath)
//        
//        if let item = todoItems?[indexPath.row]{
//            cell.textLabel?.text = item.title
//            
//            let cellBackground = UIColor.init(hexString: (selectedCategory?.color)!)
//            
//            if let color = cellBackground?.darken(byPercentage: CGFloat(indexPath.row)/CGFloat(todoItems!.count)) {
//                cell.backgroundColor = color
//                cell.textLabel?.textColor = ContrastColorOf(color, returnFlat: true)
//            }
//            
//            cell.accessoryType = item.done == true ? .checkmark : .none
//        } else {
//            cell.textLabel?.text = "No items added."
//        }
//        
//        return cell
//    }
    
    override func viewDidAppear(_ animated: Bool) {
        setBG()
    }

    func setBG() {
        
        let colorArray: [UIColor] = ColorsFromImage(#imageLiteral(resourceName: "background_2"), withFlatScheme: true)
        self.view.backgroundColor = GradientColor(.diagonal, frame: self.view.frame, colors: [colorArray[0],colorArray[1]])
        
    }

}
