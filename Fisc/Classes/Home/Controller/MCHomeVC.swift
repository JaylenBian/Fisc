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
    
    let lottieView: LAAnimationView! = {
        let lottieView = LAAnimationView.animationNamed("atm_link")
        lottieView?.loopAnimation = true
        lottieView?.contentMode = .scaleAspectFit
        lottieView?.play()
        return lottieView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = UIColor(r: 250, g: 250, b: 250)
        
        lottieView.frame = self.view.frame
        lottieView.center = self.view.center
        self.view.addSubview(lottieView)
    }
    
}
