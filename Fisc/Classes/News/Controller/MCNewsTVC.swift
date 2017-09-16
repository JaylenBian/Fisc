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
import MJRefresh

class MCNewsTVC: UITableViewController {
    
    var news: [MCNews] = []
    var newsIdx = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        
        self.tableView.mj_header.beginRefreshing()
        loadNews()
    }
    
    func setupUI() {
        refreshControl?.attributedTitle = NSAttributedString(string: "刷新新闻")
        refreshControl?.addTarget(self, action: #selector(loadNews), for: .valueChanged)
        
        self.tableView.mj_header = MJRefreshNormalHeader.init(refreshingTarget: self, refreshingAction: #selector(loadNews))
        self.tableView.mj_footer = MJRefreshAutoNormalFooter.init(refreshingTarget: self, refreshingAction: #selector(loadMoreNews))
        self.tableView.mj_footer.isAutomaticallyHidden = true
    }
    
}

// MARK: - main logic function
extension MCNewsTVC {
    
    func loadNews(){
        let curDateDouble = Date(timeIntervalSinceNow: 0).timeIntervalSince1970 as Double
        let curSec = Int(curDateDouble)
        let timestamp = curSec.description
        let url = "http://api.nbd.com.cn/3/columns/317/articles.json?app_key=d401a38c50a567882cd71cec43201c78&app_version_name=4.2.1&client_key=iPhone&count=15&page=1&timestamp" + timestamp
        
        newsIdx = 1

        Alamofire.request(url, method: .get).responseJSON { (response) in
            
            if let value = response.result.value {
                let json = JSON(value)
                let jsonData = json["data"]
                
                self.news.removeAll()
                // update news array
                for i in 0..<jsonData.count {
                    // KVC 
                    let newsItem = MCNews.init(dict: jsonData[i].dictionaryObject!)
                    self.news.append(newsItem)
                }
                self.tableView.mj_header.endRefreshing()
                // update user interface
                self.tableView.reloadData()
            }
        }
    }
    
    func loadMoreNews() {
        let max_id = ["1148125", "1147967", "1147784", "1147611", "1147454", "1147259", "1147167", "1146979", "1146927"]
        
        if (newsIdx+1 > max_id.count){
            self.tableView.mj_footer.endRefreshingWithNoMoreData()
            return
        }
        else {
            newsIdx += 1
        }
        
        let curDateDouble = Date(timeIntervalSinceNow: 0).timeIntervalSince1970 as Double
        let curSec = Int(curDateDouble)
        let timestamp = curSec.description
        let url = "http://api.nbd.com.cn/3/columns/317/articles.json?app_key=d401a38c50a567882cd71cec43201c78&app_version_name=4.2.1&client_key=iPhone&count=15&max_id=" + max_id[newsIdx-2] + "&page=" + String(newsIdx) + "&timestamp" + timestamp
        
        Alamofire.request(url, method: .get).responseJSON { (response) in
            
            if let value = response.result.value {
                let json = JSON(value)
                let jsonData = json["data"]
                
                // update news array
                for i in 0..<jsonData.count {
                    let newsItem = MCNews.init(dict: jsonData[i].dictionaryObject!)
                    self.news.append(newsItem)
                }
                self.tableView.mj_footer.endRefreshing()
                // update user interface
                self.tableView.reloadData()
            }
        }
        
    }
    
}

// MARK: - table view datasource and delegate implemention
extension MCNewsTVC {
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return news.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "articleCell")
        
        // get widget item
        let imgView = cell?.viewWithTag(1) as! UIImageView
        let titleLabel = cell?.viewWithTag(2) as! UILabel
        let sourceLabel = cell?.viewWithTag(3) as! UILabel
        
        // clear
        imgView.image = nil
        
        // set
        titleLabel.text = news[indexPath.row].title
        sourceLabel.text = news[indexPath.row].ori_source
        let imgUrl = URL(string: news[indexPath.row].image ?? "")
        imgView.sd_setImage(with: imgUrl, placeholderImage: UIImage(named: "news_placeholder"))
        
        return cell!
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let newsItem = news[indexPath.row]
        
        let vc = UIStoryboard(name: "News", bundle: nil).instantiateViewController(withIdentifier: "newsPageView") as! MCNewsPageVC
        vc.news = newsItem
        
        vc.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}
