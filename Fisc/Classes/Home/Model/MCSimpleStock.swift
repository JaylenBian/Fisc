//
//  MCSimpleStock.swift
//  Fisc
//
//  Created by Minecode on 2017/9/16.
//  Copyright © 2017年 Minecode. All rights reserved.
//

import UIKit

class MCSimpleStock: NSObject {

    var name: String?
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
