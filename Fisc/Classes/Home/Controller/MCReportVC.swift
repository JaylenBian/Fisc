//
//  MCReportVC.swift
//  Fisc
//
//  Created by Minecode on 2017/9/16.
//  Copyright © 2017年 Minecode. All rights reserved.
//

import UIKit
import Alamofire
import SVProgressHUD
import SwiftyJSON
import SDWebImage

class MCReportVC: UIViewController {

    @IBOutlet weak var headerContainer: UIView!
    
    var report: MCReport?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        
        loadReport()
        
    }
    
    func setupUI() {
        
        self.navigationController?.navigationBar.barTintColor = self.headerContainer.backgroundColor
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.navigationBar.barTintColor = UIColor(r: 255, g: 85, b: 42)
        
        super.viewWillDisappear(animated)
    }
    
}

// MARK: - main logic function 
extension MCReportVC {
    
    func loadReport() {
        // Load Report function
        // Notice: File must be JSON file
        // File stored in /Data/Reports currently
        // FIX-ME: Report files upload to online database recently
        
        do {
            if let path = Bundle.main.path(forResource: "600006", ofType: "json") {
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .alwaysMapped)
                
                let json = JSON(data)
                
                report = MCReport(dict: json.dictionaryObject!)
                
            }
            
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func setReportInfo() {
        
        
        
    }
    
    func calReportScore() {
        // To get the algprithm of calculating score
        // You can find it on Document Page
        
        
        
    }
    
}
