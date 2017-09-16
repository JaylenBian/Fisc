//
//  MCHomeVC.swift
//  Fisc
//
//  Created by Minecode on 2017/8/12.
//  Copyright © 2017年 Minecode. All rights reserved.
//

import UIKit
import Lottie
import Alamofire
import SwiftyJSON
import MJRefresh

class MCHomeVC: UIViewController, MCStockInfoDelegate, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var stockBannerContainer: UIScrollView!
    @IBOutlet weak var barRefreshButton: UIBarButtonItem!
    @IBOutlet weak var stockHeaderView: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var tableFooterView: UIView!
    @IBOutlet weak var stockAnalysisButton: UIButton!
    @IBOutlet weak var stockCommitsButton: UIButton!
    
    
    var stockBannerTimer: Timer?
//    var stocksInBanner: [MCBannerStock] = []
    var stockBanners: [MCStockBannerView] = []
    var stocks: [MCStock] = []
    var favorite: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = UIColor(r: 250, g: 250, b: 250)
        
        //setupLot()
        setupUI()
        setupStockBanner()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        
        //self.tableView.mj_header.beginRefreshing()
        //loadStocks()
    }
    
    func setupLot() {
        if let animationView: LOTAnimationView = LOTAnimationView(name: "atm_link") {
            animationView.frame = CGRect(x: 0, y: 0, width: self.view.bounds.width, height: 400)
            //            animationView.center = self.view.center
            animationView.contentMode = .scaleAspectFill
            
            animationView.loopAnimation = true
            
            view.addSubview(animationView)
            
            animationView.play()
        }
    }
    
    func setupUI() {
        barRefreshButton.action = #selector(loadBannerStockInfo)
        
        let stockSearchButton = self.stockHeaderView.viewWithTag(100) as! UIButton
        stockSearchButton.addTarget(self, action: #selector(stockSearchHandler), for: .touchUpInside)
        stockAnalysisButton.addTarget(self, action: #selector(stockAnalysisHandler), for: .touchUpInside)
        stockCommitsButton.addTarget(self, action: #selector(stockCommitsHandler), for: .touchUpInside)
        
        //self.tableView.mj_header = MJRefreshNormalHeader(refreshingTarget: self, refreshingAction: #selector(loadStocks))
    }
    
    func setupStockBanner() {
        let kBannerMargin = (UIScreen.main.bounds.width - 3*kStockBannerWidth) / 4
        stockBannerContainer.contentSize.width = 10 * kBannerMargin + 9 * kStockBannerWidth
        for i in 0..<9 {
            let stockBanner = Bundle.main.loadNibNamed("MCStockBannerView", owner: nil, options: nil)?.first as! MCStockBannerView
            var stockBannerRect = stockBanner.frame
            stockBannerRect.origin.x = CGFloat(i+1)*kBannerMargin + CGFloat(i)*kStockBannerWidth
            stockBannerRect.origin.y = 10
            stockBanner.frame = stockBannerRect
            stockBannerContainer.addSubview(stockBanner)
            stockBanners.append(stockBanner)
        }
        
        stockBannerTimer = Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(self.loadBannerStockInfo), userInfo: nil, repeats: true)
        
    }
    
}

// MARK: - main logic function 
extension MCHomeVC {
    
    func loadBannerStockInfo() {
        
        Alamofire.request(stockBannerUrl).responseData { (response) in
            
            guard var resData = response.result.value,
                var resStr = String(data: resData, encoding: .utf8)
                else {return}
            // get the substring of json format
            resStr = resStr.replacingOccurrences(of: "market_page_back(", with: "")
            resStr = resStr.replacingOccurrences(of: ");", with: "")
            // transfer to Data
            resData = resStr.data(using: .utf8)!
            // transfer to json
            let json = JSON(data: resData)
            
            for i in 0..<9 {
                
                let name: String = json[stockBannerId[i]]["name"].stringValue
                let price: String = json[stockBannerId[i]]["price"].stringValue
                let updown: String = json[stockBannerId[i]]["updown"].stringValue
                
                self.stockBanners[i].updateStockInfo(name: name, price: price, updown: updown)
            }
            
        }
    }
    
    func stockSearchHandler() {
        let vc = UIStoryboard(name: "Home", bundle: nil).instantiateViewController(withIdentifier: "stockSearchVC")
        self.present(vc, animated: true, completion: nil)
    }
    
    func stockAnalysisHandler() {
        let vc = UIStoryboard(name: "Home", bundle: nil).instantiateViewController(withIdentifier: "reportVC")
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func stockCommitsHandler() {
        if (self.tabBarController?.viewControllers?.count)! >= 3 {
            self.tabBarController?.selectedIndex = 2
        }
        
        let nvc = self.tabBarController?.viewControllers?[2] as! UINavigationController
        let vc  = nvc.viewControllers[0] as! MCMarketsVC
        vc.tableView.mj_header.beginRefreshing()
        vc.loadRoomId()
    }
    
    func loadStocks() {
//        self.tableView.mj_header.beginRefreshing()
        stocks = Array.init(repeating: MCStock(), count: favorite.count)
        for i in 0..<favorite.count {
            loadStockInfo(with: favorite[i], toIdx: i)
        }
        self.tableView.reloadData()
        self.tableView.mj_header.endRefreshing()
    }
    
    func loadStockInfo(with code: String, toIdx des: Int) {
        let url = "http://api.money.126.net/data/feed/" + code + ",clear_cache_KIPENVUH"
        
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
            
            guard let stockJsonItem = json[code].dictionaryObject
            else {
                return
            }
            let stockItem = MCStock(dict: stockJsonItem)
            self.stocks.append(stockItem)
        }
    }
    
}

// MARK: - delegate implemention
extension MCHomeVC {
    
    func stockInfo(like stock: MCStock) {
        if !favorite.contains(stock.code!) {
            favorite.append(stock.code!)
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favorite.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "stockCell")
        
        // get widget
        let nameLabel = cell?.viewWithTag(1) as! UILabel
        let idLabel = cell?.viewWithTag(2) as! UILabel
        let priceLabel = cell?.viewWithTag(3) as! UILabel
        let updownLabel = cell?.viewWithTag(4) as! UILabel
        let updownView = cell?.viewWithTag(5) as! UIView
        
        // set info
        let idx = indexPath.row
        nameLabel.text = stocks[idx].name
        idLabel.text = stocks[idx].symbol
        updownLabel.text = stocks[idx].updown
        priceLabel.text = stocks[idx].price
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
        return "取消关注"
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
        return .delete
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == UITableViewCellEditingStyle.delete {
            favorite.remove(at: indexPath.row)
            stocks.remove(at: indexPath.row)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
}
