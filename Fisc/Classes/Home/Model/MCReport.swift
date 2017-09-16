//
//  MCReport.swift
//  Fisc
//
//  Created by Minecode on 2017/9/16.
//  Copyright © 2017年 Minecode. All rights reserved.
//

import UIKit

class MCReport: NSObject {
    
    var or: String?
    var sr: String?
    var rp: String?
    var mf: String?
    var nr: String?
    var ca: String?
    var gs: String?
    var cl: String?
    var oe: String?
    var ta: String?
    var tl: String?
    var fa: String?
    
    // Use KVC to init MCReport item
    // Please make sure obey JSON format
    // 
    // para should be [String: Any]
    init(dict: [String: Any]) {
        super.init()
        
        self.setValuesForKeys(dict)
    }
    
    override func setValue(_ value: Any?, forUndefinedKey key: String) {
        
    }
    
}
