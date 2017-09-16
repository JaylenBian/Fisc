//
//  MCStockInfoVC.swift
//  Fisc
//
//  Created by Minecode on 2017/9/16.
//  Copyright © 2017年 Minecode. All rights reserved.
//

import UIKit


protocol MCStockInfoDelegate {
    func stockInfo(processWith stock: MCStock)
}

class MCStockInfoVC: UIViewController {

    var delegate: MCStockInfoDelegate?
    var code: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    
    convenience init(withCode code: String) {
        self.init()
        
        self.code = code
    }
    

}
