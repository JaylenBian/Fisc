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
    
    var stocks: [MCStock] = []
    var stockBanners: [MCStockBannerView] = []
    
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
        barRefreshButton.action = #selector(loadStockInfo)
    }
    
    func setupStockBanner() {
        let kBannerMargin = (self.view.frame.width - 3*kStockBannerWidth) / 4
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
        self.loadStockInfo()
    }
    
}

// MARK: - main logic function 
extension MCHomeVC {
    
    func loadStockInfo() {
        
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
    
}

