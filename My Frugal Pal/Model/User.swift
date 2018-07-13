//
//  User.swift
//  My Frugal Pal
//
//  Created by Zackarin Necesito on 7/12/18.
//  Copyright © 2018 Zackarin Necesito. All rights reserved.
//

import Foundation

class User {
    
    var budget : Double?
    var email : String?
    
    var dailySpending: [WeeklyBudget]?
    
    init() {
        
    }
    
    convenience init(inputBudget : Double, inputEmail : String) {
        
        self.init()
        budget = inputBudget
        email = inputEmail
        
    }
    
    
}
