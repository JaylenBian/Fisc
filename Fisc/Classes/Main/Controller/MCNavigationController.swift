//
//  MCNavigationController.swift
//  Fisc
//
//  Created by Minecode on 2017/8/11.
//  Copyright © 2017年 Minecode. All rights reserved.
//

import UIKit

class MCNavigationController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 设置NavigationBar样式
        self.navigationBar.barTintColor = UIColor(r: 255, g: 85, b: 42)
        self.navigationBar.isTranslucent = false
        
    }
    
}
