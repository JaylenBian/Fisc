//
//  MCStock.swift
//  Fisc
//
//  Created by Minecode on 2017/9/15.
//  Copyright © 2017年 Minecode. All rights reserved.
//

import UIKit

class MCStock: NSObject {
    
    var name: String?
    var price: CGFloat? = 0.0
    var updown: CGFloat?
    var code: String?
    
    
    init(dict: [String: Any]) {
        super.init()
        
        setValuesForKeys(dict)
    }
    
    override func setValue(_ value: Any?, forUndefinedKey key: String) {
        
    }
    
    init(name: String, code: String) {
        self.name = name
        self.code = code
    }
    
}
