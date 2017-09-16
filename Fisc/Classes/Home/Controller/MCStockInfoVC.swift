//
//  MCStockInfoVC.swift
//  Fisc
//
//  Created by Minecode on 2017/9/16.
//  Copyright © 2017年 Minecode. All rights reserved.
//

import UIKit


protocol MCStockInfoDelegate {
    func stockInfo(like stock: MCStock)
}

class MCStockInfoVC: UIViewController {
    
    @IBOutlet weak var headerCotainer: UIView!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var dataLabel: UILabel!
    @IBOutlet weak var likeButton: UIButton!
    
    
    
    var delegate: MCStockInfoDelegate?
    var stock: MCStock?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        loadStockInfo()
        
    }
    
    func setupUI() {
        self.likeButton.addTarget(self, action: #selector(likeHandler), for: .touchUpInside)
        self.navigationController?.navigationBar.barTintColor = self.headerCotainer.backgroundColor
    }
    
    func loadStockInfo() {
        self.navigationItem.title = stock?.name
        self.priceLabel.text = stock?.price
        self.dataLabel.text = String(format: "%@    %@    %@", (stock?.updown)!, (stock?.percent)!, (stock?.time)!)
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.navigationBar.barTintColor = UIColor(r: 255, g: 85, b: 42)
        
        super.viewWillDisappear(animated)
    }
    
    convenience init(withStock stock: MCStock) {
        self.init()
        
        self.stock = stock
    }
    
    func likeHandler() {
        self.delegate?.stockInfo(like: self.stock!)
    }
    

}
