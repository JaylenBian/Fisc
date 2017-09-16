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
    var price: String?
    var updown: String?
    var code: String?
    var time: String?
    var symbol: String?
    var percent: String?
    
    override init() {
        super.init()
    }
    
    init(dict: [String: Any]) {
        super.init()
        
        
        setOtherValue(dict: dict)
        
    }
    
    func setOtherValue(dict: [String: Any]) {
        self.price = String.init(format: "%@", dict["price"] as! CVarArg)
        self.updown = String.init(format: "%@", dict["updown"] as! CVarArg)
        self.percent = String.init(format: "%@", dict["percent"] as! CVarArg)
        self.name = String.init(format: "%@", dict["name"] as! CVarArg)
        self.time = String.init(format: "%@", dict["time"] as! CVarArg)
        self.code = String.init(format: "%@", dict["code"] as! CVarArg)
        self.symbol = String.init(format: "%@", dict["symbol"] as! CVarArg)
    }
    
}
