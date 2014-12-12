//
//  NavController.swift
//  TableTest
//
//  Created by Alex Dinsmoor on 12/7/14.
//  Copyright (c) 2014 Dinsmoor. All rights reserved.
//

import UIKit

class NavController: UINavigationController{
  
    override func viewDidLoad(){
        super.viewDidLoad()
        self.title = "Your Title"
        
        var homeButton : UIBarButtonItem = UIBarButtonItem(title: "LeftButtonTitle", style: UIBarButtonItemStyle.Plain, target: self, action: "")
        
        var logButton : UIBarButtonItem = UIBarButtonItem(title: "RigthButtonTitle", style: UIBarButtonItemStyle.Plain, target: self, action: "")
        
        self.navigationItem.leftBarButtonItem = homeButton
        self.navigationItem.rightBarButtonItem = logButton
    }
}