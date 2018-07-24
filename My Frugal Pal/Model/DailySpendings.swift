//
//  DailySpendings.swift
//  My Frugal Pal
//
//  Created by Zackarin Necesito on 7/13/18.
//  Copyright © 2018 Zackarin Necesito. All rights reserved.
//

import Foundation
import RealmSwift

class DailySpendings: Object {
    
    @objc dynamic var expenses: Double = 0.0
    @objc dynamic var name: String = ""

    var parentCategory = LinkingObjects(fromType: WeeklyBudget.self, property: "dailySpendings")
    
}
