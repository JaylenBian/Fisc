//
//  MCTabBarController.swift
//  Fisc
//
//  Created by Minecode on 2017/8/11.
//  Copyright © 2017年 Minecode. All rights reserved.
//

import UIKit

class MCTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        addChildVc(storyName: "Home")
        addChildVc(storyName: "News")
        addChildVc(storyName: "Markets")
        addChildVc(storyName: "Profile")
        
    }
    
    private func addChildVc(storyName: String){
        let childVc = UIStoryboard(name: storyName, bundle: nil).instantiateInitialViewController()!
        
        childVc.tabBarItem.title = storyName
        childVc.tabBarItem.image = UIImage(named: "tab_" + storyName.lowercased() + "_normal")
        childVc.tabBarItem.selectedImage = UIImage(named: "tab_" + storyName.lowercased() + "_selected")?.withRenderingMode(.alwaysOriginal)
        
        addChildViewController(childVc)
    }
    
}
