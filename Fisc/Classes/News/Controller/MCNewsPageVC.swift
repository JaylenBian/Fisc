//
//  MCNewsPageVC.swift
//  Fisc
//
//  Created by Minecode on 2017/9/16.
//  Copyright © 2017年 Minecode. All rights reserved.
//

import UIKit
import SVProgressHUD

class MCNewsPageVC: UIViewController, UIWebViewDelegate {
    
    @IBOutlet weak var progressView: UIProgressView!
    @IBOutlet weak var webView: UIWebView!
    
    var news: MCNews?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        if news != nil {
            self.loadWebPage(with: news!)
        }
        else {
            self.navigationItem.title = "加载失败"
            SVProgressHUD.showError(withStatus: "新闻加载失败")
        }
    }
    
    func setupUI() {
        // self.hidesBottomBarWhenPushed = true
    }
    
    func loadWebPage(with news: MCNews) {
        let url = URL(string: news.url ?? "")
        let request = URLRequest(url: url!)
        
        // load web page
        self.webView.loadRequest(request)
        
    }
    
}

// MARK: - webview delegate implemention
extension MCNewsPageVC {
    
    func webViewDidStartLoad(_ webView: UIWebView) {
        self.navigationItem.title = "加载中"
        // progress view action
        self.progressView.isHidden = false
        UIView.animate(withDuration: 2) { 
            self.progressView.setProgress(0.7, animated: true)
        }
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        self.navigationItem.title = "Fisc金融资讯"
        UIView.animate(withDuration: 1, animations: { 
            self.progressView.setProgress(1, animated: true)
        }) { (result) in
            self.progressView.isHidden = true
        }
    }
    
}
