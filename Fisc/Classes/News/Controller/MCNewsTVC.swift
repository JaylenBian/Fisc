//
//  MCNewsTVC.swift
//  Fisc
//
//  Created by Minecode on 2017/8/12.
//  Copyright © 2017年 Minecode. All rights reserved.
//

import UIKit
import Alamofire
import SDWebImage
import SwiftyJSON

class MCNewsTVC: UITableViewController {
    
    var news: [MCNews] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        
        loadNews()
    }
    
    func setupUI() {
        refreshControl?.attributedTitle = NSAttributedString(string: "刷新新闻")
        refreshControl?.addTarget(self, action: #selector(loadNews), for: .valueChanged)
    }
    
}

// MARK: - main logic function
extension MCNewsTVC {
    
    func loadNews() {
        let url = "http://i.money.163.com/app/api/info/list/333.json"
        let header = [
            "Content-Type": "application/x-www-form-urlencoded"
        ]
        let params = [
            "appversion": "ios_3.3.3",
            "id": "84",
            "size": "40"
        ]
            //Alamofire.request(postURL, method: .post, parameters: params, encoding: JSONEncoding.default)
        
        Alamofire.request(url, method: .post, parameters: params, encoding: URLEncoding()).responseJSON { (response) in
            
            
            if let value = response.result.value {
                let json = JSON(value)
                print(json)
            }
        }
    }
    
}
