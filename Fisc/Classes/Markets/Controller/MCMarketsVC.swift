//
//  MCMarketsVC.swift
//  Fisc
//
//  Created by Minecode on 2017/8/12.
//  Copyright © 2017年 Minecode. All rights reserved.
//

import UIKit
import Alamofire
import SDWebImage
import SwiftyJSON
import SVProgressHUD
import MJRefresh

class MCMarketsVC: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var bannerView: UIView!
    @IBOutlet weak var bannerImage: UIImageView!
    @IBOutlet weak var roomName: UILabel!
    @IBOutlet weak var roomDesc: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    var commits: [MCCommit] = []
    var refresher: UIRefreshControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        
        self.tableView.mj_header.beginRefreshing()
        loadRoomId()
        
    }
    
    func setupUI() {
        // set refresher
        self.tableView.mj_header = MJRefreshNormalHeader.init(refreshingTarget: self, refreshingAction: #selector(loadRoomId))
    }

}

// MARK: - main logic function
extension MCMarketsVC {
    
    func loadRoomId() {
        let url = "http://i.money.163.com/app/api/info/v2/live.json?appversion=ios_3.3.3&"
        Alamofire.request(url).responseJSON { (response) in
            
            if let value = response.result.value {
                let json = JSON(value)
                let roomId = json["data"]["roomId"].stringValue
                
                self.loadInfo(with: roomId)
            }
        }
    }
    
    func loadInfo(with roomId: String) {
        let url: String!
        if roomId != ""{
            url = "http://data.live.126.net/liveAll/" + roomId + ".json?appversion=ios_3.3.3&"
        }
        else {
            url = "http://data.live.126.net/liveAll/152039.json?appversion=ios_3.3.3&"
        }
        Alamofire.request(url, method: .get).responseJSON { (response) in
            
            if let value = response.result.value {
                let json = JSON(value)
                
                let room = MCRoom(name: json["roomName"].stringValue, desc: json["roomDes"].stringValue, url: json["banner"]["liveUrl"].stringValue)
                self.setRoomInfo(with: room)
                
                let commitsJson = json["messages"].array
                self.setNewsInfo(with: commitsJson!)
                
            }
            
        }
    }
    
    func setRoomInfo(with room: MCRoom) {
        self.roomName.text = room.roomName
        self.roomDesc.text = room.roomDesc
        
        self.bannerImage.sd_setImage(with: URL(string: room.liveUrl!), completed: nil)
        
    }
    
    func setNewsInfo(with news: [JSON]) {
        commits.removeAll()
        for newsItem in news.reversed() {
            let content = newsItem["msg"]["content"].stringValue
            let time = newsItem["time"].stringValue
            let commitItem = MCCommit(content: content, time: time)
            commits.append(commitItem)
        }
        self.tableView.mj_header.endRefreshing()
        self.tableView.reloadData()
    }
    
}

// MARK: - TableView Datasource and Delegate
extension MCMarketsVC {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return commits.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: kCommitCellId)
        
        
        let contentLabel = cell?.viewWithTag(1) as! UILabel
        contentLabel.text = commits[indexPath.row].content
        
        let timeLabel = cell?.viewWithTag(2) as! UILabel
        timeLabel.text = commits[indexPath.row].time
        
        
        return cell!
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tableView.estimatedRowHeight = 100
        self.tableView.rowHeight = UITableViewAutomaticDimension
    }
    
}
