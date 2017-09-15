//
//  MCStock.swift
//  Fisc
//
//  Created by Minecode on 2017/9/14.
//  Copyright © 2017年 Minecode. All rights reserved.
//

import UIKit

class MCBannerStock: NSObject {
    
    var name: String?
    var price: CGFloat? = 0.0
    var updown: CGFloat?
    
    init(dict: [String: Any]) {
        super.init()
        
        setValuesForKeys(dict)
    }
    
    override func setValue(_ value: Any?, forUndefinedKey key: String) {
        
    }
}
