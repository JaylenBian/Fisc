//
//  MCStockSearchVC.swift
//  Fisc
//
//  Created by Minecode on 2017/9/15.
//  Copyright © 2017年 Minecode. All rights reserved.
//

import UIKit
import SVProgressHUD

class MCStockSearchVC: UIViewController {
    
    @IBOutlet weak var closeButton: UIBarButtonItem!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    
    func setupUI() {
        closeButton.action = #selector(self.closeHandler)
    }
    
    @IBAction func closeAction(_ sender: Any) {
        self.closeHandler()
    }

}

// MARK: - main logic function
extension MCStockSearchVC {
    
    
    func closeHandler() {
        self.dismiss(animated: true, completion: nil)
    }
    
}
