//
//  MCRoom.swift
//  Fisc
//
//  Created by Minecode on 2017/9/15.
//  Copyright © 2017年 Minecode. All rights reserved.
//

import UIKit

class MCRoom: NSObject {
    
    var roomName: String?
    var roomDesc: String?
    var liveUrl: String?
    
    init(name: String, desc: String, url: String) {
        super.init()
        
        roomName = name
        roomDesc = desc
        liveUrl = url
        
    }
    
}
