//
//  BaseTabBarController.swift
//  VKnotes
//
//  Created by Onie on 16.11.2019.
//  Copyright © 2019 Fems. All rights reserved.
//

import UIKit

class BaseTabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let categoriesViewController = UINavigationController(rootViewController: CategoriesViewController() )
    
        let settingsViewController = UINavigationController(rootViewController: SettingsViewController())
        
        viewControllers = [categoriesViewController, settingsViewController]
    }
}

