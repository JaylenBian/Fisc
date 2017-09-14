//
//  MCHomeVC.swift
//  Fisc
//
//  Created by Minecode on 2017/8/12.
//  Copyright © 2017年 Minecode. All rights reserved.
//

import UIKit
import Lottie

class MCHomeVC: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = UIColor(r: 250, g: 250, b: 250)
        
        if let animationView: LOTAnimationView = LOTAnimationView(name: "atm_link") {
            animationView.frame = CGRect(x: 0, y: 0, width: self.view.bounds.width, height: 400)
//            animationView.center = self.view.center
            animationView.contentMode = .scaleAspectFill
            
            animationView.loopAnimation = true
            
            view.addSubview(animationView)
            
            animationView.play()
        }
        
        
    }
    
}
