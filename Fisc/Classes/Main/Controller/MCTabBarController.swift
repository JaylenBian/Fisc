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
        
        addChildVc(storyName: "Home", title: "首页")
        addChildVc(storyName: "News", title: "快讯")
        addChildVc(storyName: "Markets", title: "行情")
        addChildVc(storyName: "Profile", title: "个人")
        
    }
    
    private func addChildVc(storyName: String, title: String){
        let childVc = UIStoryboard(name: storyName, bundle: nil).instantiateInitialViewController()!
        
        childVc.tabBarItem.title = title
        childVc.tabBarItem.image = UIImage(named: "tab_" + storyName.lowercased() + "_normal")
        childVc.tabBarItem.selectedImage = UIImage(named: "tab_" + storyName.lowercased() + "_selected")?.withRenderingMode(.alwaysOriginal)
        
        addChildViewController(childVc)
    }
    
}
