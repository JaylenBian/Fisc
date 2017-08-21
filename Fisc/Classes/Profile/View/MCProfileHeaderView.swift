//
//  MCProfileHeaderView.swift
//  Fisc
//
//  Created by Minecode on 2017/8/21.
//  Copyright © 2017年 Minecode. All rights reserved.
//

import UIKit

class MCProfileHeaderView: UIView {

    @IBOutlet weak var imageView: UIImageView!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        draw(self.frame)
    }
    
//    override func draw(_ rect: CGRect) {
//        setupUI()
//    }
    
    func setupUI() {
        // 在此设置UI实现
        self.backgroundColor = UIColor.clear
    }
    
    override func awakeFromNib() {
        setupUI()
    }
    
//
//    required init(coder aDecoder: NSCoder) {
//        super.init(coder: aDecoder)!
//    }
    
//    override func awakeFromNib() {
//        self.backgroundColor = UIColor.red
//    }
}
