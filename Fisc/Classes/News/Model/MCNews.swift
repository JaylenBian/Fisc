//
//  MCNews.swift
//  Fisc
//
//  Created by Minecode on 2017/9/15.
//  Copyright © 2017年 Minecode. All rights reserved.
//

import UIKit

class MCNews: NSObject {
    
    var title: String?
    var url: String?
    var image: String?
    var ori_source: String?
    var digest: String?
    
    // Use KVC mode
    init(dict: [String: Any]) {
        super.init()
        
        setValuesForKeys(dict)
    }
    
    override func setValue(_ value: Any?, forUndefinedKey key: String) {
        
    }
    
    
}
