//
//  MCCommit.swift
//  Fisc
//
//  Created by Minecode on 2017/9/15.
//  Copyright © 2017年 Minecode. All rights reserved.
//

import UIKit

class MCCommit: NSObject {
    
    var content: String?
    var time: String?
    
    init(content: String, time: String) {
        super.init()
        
        self.content = content
        self.time = time
        
    }
    
}
