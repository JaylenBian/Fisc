//
//  MCSourceVC.swift
//  Fisc
//
//  Created by Minecode on 2017/8/21.
//  Copyright © 2017年 Minecode. All rights reserved.
//

import UIKit

class MCSourceVC: UIViewController, UIWebViewDelegate {

    @IBOutlet weak var webView: UIWebView!
    @IBOutlet weak var backButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "正在打开Github..."
        self.webView.delegate = self
        self.webView.loadRequest(URLRequest(url: URL(string: "https://github.com/Minecodecraft/Fisc")!))
        self.webView.scrollView.bounces = true
        self.webView.scrollView.alwaysBounceVertical = true
        
        self.backButton.layer.borderWidth = 2
        self.backButton.layer.borderColor = UIColor.lightText.cgColor
        self.backButton.backgroundColor = UIColor.lightGray
        self.backButton.layer.cornerRadius = 12
        
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        self.title = "Minecode's的Github"
    }
    
    @IBAction func bakcAction(_ sender: Any) {
        if self.navigationController != nil {
            navigationController?.popViewController(animated: true)
        }
        else {
            self.dismiss(animated: true, completion: nil)
        }
    }
    
}
