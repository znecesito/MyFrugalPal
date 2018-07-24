//
//  WeeklyBudget.swift
//  My Frugal Pal
//
//  Created by Zackarin Necesito on 6/12/18.
//  Copyright © 2018 Zackarin Necesito. All rights reserved.
//

import Foundation
import RealmSwift

class WeeklyBudget: Object {
    
    @objc dynamic var day : String = ""
    var dailySpendings = List<DailySpendings>()
    
    var parentCategory = LinkingObjects(fromType: User.self, property: "weeklyBudget") 
    
}
