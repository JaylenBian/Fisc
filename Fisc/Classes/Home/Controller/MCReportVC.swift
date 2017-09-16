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
                self.setReportInfo(with: json)
            }
            
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func setReportInfo(with json: JSON) {
        
        let jsonPara = json.dictionaryObject as! [String: String]
        
        var idx = 1
        for item in jsonPara {
            let key = item.key
            var value = item.value
            
            // process str
            value = (value as NSString).substring(to: (value as NSString).length - 6)
            
            
            // get label
            if (idx <= 9) {
                let label = self.view.viewWithTag(idx) as! UILabel
                // set
                label.text = "\(key): \(value)M"
            }
            
            idx += 1
        }
        
    }
    
    func calReportScore() {
        // To get the algprithm of calculating score
        // You can find it on Document Page
        let or = Double((report?.or)!)
        let sr = Double((report?.sr)!)
        let rp = Double((report?.rp)!)
        let mf = Double((report?.mf)!)
        let nr = Double((report?.nr)!)
        let ca = Double((report?.ca)!)
        let gs = Double((report?.gs)!)
        let cl = Double((report?.cl)!)
        let oe = Double((report?.oe)!)
        let ta = Double((report?.ta)!)
        let tl = Double((report?.tl)!)
        let fa = Double((report?.fa)!)
        
        //---------资产状况得分Q1
        // 资产负债率
        let m1 = tl
        let n1 = ta
        let x1 = m1! / n1!
        let s1 = 400 * (-1 * ((x1-0.5)*(x1-0.5)) + 0.25)
        let Q1 = s1
        
        //-------资金流动状况Q2
        // 流通比率
        let m2 = ca
        let n2 = cl
        let x2 = m2! / n2!
        let s2 = 25 * (-1 * ((x2-2)*(x2-2)) + 4)
        
        // 速动比率
        let p1 = gs
        let x3 = (m2! - p1!) * n2!
        let s3 = 100 * (-1 * ((x3-1)*(x3-1)) + 1)
        
        // 现金比率
        let x4 = (mf! + nr!) / cl!
        let s4 = 100 * (-1 * ((x4-1)*(x4-1)) + 1)
        let Q2 = 0.3 * s2 + 0.3 * s3 + 0.4 * s4
        
        //-----------周转状况Q3
        // 总资产周转率
        let m5 = sr
        let n5 = ta
        let x5 = m5! / n5!
        let s5 = 100 * (log(x5+1) / log(10))
        let Q3 = s5
        
        //---------盈利指标Q4
        // 销售额与固定资产比率
        let m6 = sr
        let n6 = fa
        let x6 = m6! / n6!
        let s6 = 4 * (-1 * ((x6-5)*(x6-5)) + 25)
        
        // 净资产收益率
        let m7 = rp
        let n7 = oe
        let x7 = m7! / n7!
        let s7 = 100 * (log(x7+1) / log(1))
        
        // 资产回报率
        let m8 = rp
        let n8 = ta
        let x8 = m8! / n8!
        let s8 = 100 * (log(x8+1) / log(1))
        let Q4 = 0.2 * s6 + 0.4 * s7 + 0.4 * s8

        //--------动态增长状况Q5
        // 置空 使用公式2计算
        let Q = 0.3 * Q1 + 0.2 * Q2 + 0.2 * Q3 + 0.3 * Q4
        
    }
    
}
