//
//  MCStockInfoVC.swift
//  Fisc
//
//  Created by Minecode on 2017/9/16.
//  Copyright © 2017年 Minecode. All rights reserved.
//

import UIKit


protocol MCStockInfoDelegate {
    func stockInfo(like stock: MCStock)
}

class MCStockInfoVC: UIViewController {

    var delegate: MCStockInfoDelegate?
    var stock: MCStock?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        
    }
    
    func setupUI() {
        
    }
    
    convenience init(withCode code: String) {
        self.init()
        
        self.code = code
    }
    

}
