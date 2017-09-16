//
//  MCStockSearchVC.swift
//  Fisc
//
//  Created by Minecode on 2017/9/15.
//  Copyright © 2017年 Minecode. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire
import SVProgressHUD


class MCStockSearchVC: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var closeButton: UIBarButtonItem!
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchButton: UIButton!
    
    
    var recommands: [MCSimpleStock] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        
        loadRecommands()
        
    }
    
    func setupUI() {
        closeButton.action = #selector(self.closeHandler)
        
        searchButton.addTarget(self, action: #selector(searchAction), for: .touchUpInside)
    }
    
    func loadRecommands() {
        recommands = [
            MCSimpleStock(name: "上海机场", code: "600009"),
            MCSimpleStock(name: "东风汽车", code: "600006"),
            MCSimpleStock(name: "中正100A", code: "150012"),
            MCSimpleStock(name: "邯郸钢铁", code: "600001")
        ]
        self.tableView.reloadData()
    }
    
    @IBAction func closeAction(_ sender: Any) {
        self.closeHandler()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
        searchTextField.resignFirstResponder()
    }
    
}

// MARK: - main logic function
extension MCStockSearchVC {
    
    
    func closeHandler() {
        self.dismiss(animated: true, completion: nil)
    }
    
    func searchAction() {
        guard let text = searchTextField.text else {return}
        
        if !isPurnInt(string: text) {
            SVProgressHUD.showError(withStatus: "股票代码必须为数字")
            return
        }
        
        self.searchSH(with: text)
        
    }
    
    func searchSH(with code: String) {
        // 0 - Shanghai, 1 - Shenzhen
        let url = "http://api.money.126.net/data/feed/0" + code + ",clear_cache_KIPENVUH"
        
        SVProgressHUD.show(withStatus: "加载中")
        Alamofire.request(url).responseData { (response) in
            
            guard var resData = response.result.value,
                var resStr = String(data: resData, encoding: .utf8)
                else {return}
            // get the substring of json format
            resStr = resStr.replacingOccurrences(of: "_ntes_quote_callback(", with: "")
            resStr = resStr.replacingOccurrences(of: ");", with: "")
            // transfer to Data
            resData = resStr.data(using: .utf8)!
            // transfer to json
            let json = JSON(data: resData)
            
            // if not SH
            if json.count == 0 {
                self.searchSZ(with: code)
            }
            else {
                SVProgressHUD.dismiss()
                guard let stockJsonItem = json["0"+code].dictionaryObject
                else {
                        SVProgressHUD.showError(withStatus: "内部错误")
                        return
                }
                let stockItem = MCStock(dict: stockJsonItem)
                // init MCStockInfoVC
                let vc = UIStoryboard(name: "Home", bundle: nil).instantiateViewController(withIdentifier: "stockInfoVC") as! MCStockInfoVC
                vc.stock = stockItem
                
                let tvc = self.presentingViewController as! MCTabBarController
                let nvc = tvc.viewControllers?.first as! MCNavigationController
                let homeVc = nvc.viewControllers.first as! MCHomeVC
                vc.delegate = homeVc
                
                self.dismiss(animated: true, completion: {
                    homeVc.navigationController?.pushViewController(vc, animated: true)
                })
            }
            
        }
    }
    
    func searchSZ(with code: String) {
        // 0 - Shanghai, 1 - Shenzhen
        let url = "http://api.money.126.net/data/feed/1" + code + ",clear_cache_KIPENVUH"
        
        SVProgressHUD.show(withStatus: "加载中")
        Alamofire.request(url).responseData { (response) in
            
            guard var resData = response.result.value,
                var resStr = String(data: resData, encoding: .utf8)
                else {return}
            // get the substring of json format
            resStr = resStr.replacingOccurrences(of: "_ntes_quote_callback(", with: "")
            resStr = resStr.replacingOccurrences(of: ");", with: "")
            // transfer to Data
            resData = resStr.data(using: .utf8)!
            // transfer to json
            let json = JSON(data: resData)
            
            // if not SZ
            if json.count == 0 {
                SVProgressHUD.showError(withStatus: "查找失败")
            }
            else {
                SVProgressHUD.dismiss()
                guard let stockJsonItem = json["1"+code].dictionaryObject
                else {
                    SVProgressHUD.showError(withStatus: "内部错误")
                    return
                }
                let stockItem = MCStock(dict: stockJsonItem)
                // init MCStockInfoVC
                let vc = UIStoryboard(name: "Home", bundle: nil).instantiateViewController(withIdentifier: "stockInfoVC") as! MCStockInfoVC
                vc.stock = stockItem
                
                let tvc = self.presentingViewController as! MCTabBarController
                let nvc = tvc.viewControllers?.first as! MCNavigationController
                let homeVc = nvc.viewControllers.first as! MCHomeVC
                vc.delegate = homeVc
                
                self.dismiss(animated: true, completion: { 
                    homeVc.navigationController?.pushViewController(vc, animated: true)
                })
                
            }
            
        }
    }
    
    func setStockInfo() {
        
    }
    
    func isPurnInt(string: String) -> Bool {
        
        let scan: Scanner = Scanner(string: string)
        
        var val:Int = 0
        
        return scan.scanInt(&val) && scan.isAtEnd
        
    }
    
}

// MARK: - tableview protocol implemention
extension MCStockSearchVC {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recommands.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "recommandCell")
        
        cell?.textLabel?.text = self.recommands[indexPath.row].name
        cell?.detailTextLabel?.text = self.recommands[indexPath.row].code
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let text = recommands[indexPath.row].code
        print(text)
        self.searchSH(with: text ?? "")
    }
    
}
