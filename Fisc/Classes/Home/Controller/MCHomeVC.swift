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

class MCHomeVC: UIViewController {
    
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
    
}

