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
    var imageUrl: String?
    var createTime: String?
    var digest: String?
    
    init(dict: [String: Any]) {
        super.init()
        
        setValuesForKeys(dict)
    }
    
    override func setValue(_ value: Any?, forUndefinedKey key: String) {
        
    }
    
    
}
