//
//  CutomNavigationController.swift
//  My Frugal Pal
//
//  Created by Zackarin Necesito on 7/12/18.
//  Copyright © 2018 Zackarin Necesito. All rights reserved.
//

import UIKit
import ChameleonFramework

class CutomNavigationController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationBar.shadowImage = UIImage()
        self.navigationBar.tintColor = UIColor.flatBlack

    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
