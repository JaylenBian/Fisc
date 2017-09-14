//
//  MCProfileVC.swift
//  Fisc
//
//  Created by Minecode on 2017/8/12.
//  Copyright © 2017年 Minecode. All rights reserved.
//

import UIKit
import Firebase

let cellId = "cellId"
let kHeaderViewMargin: CGFloat = 64



enum VC: String {
    case ViewSourceCode
    case ContactAuther
    case About
    
    func sbIdentifier() -> String {
        switch self {
        case .ViewSourceCode:
            return "profile_sourceCode"
        case .ContactAuther:
            return "profile_contactAuthor"
        case .About:
            return "profile_about"
        }
    }
    
    func title() -> String {
        switch self {
        case .ViewSourceCode:
            return "查看项目源代码"
        case .ContactAuther:
            return "联系作者"
        case .About:
            return "关于"
        }
    }
}

class MCProfileVC: UITableViewController {
    
    @IBOutlet weak var logoutButton: UIButton!
    
    
    let vcs = [[VC.ViewSourceCode, VC.ContactAuther],
                 [VC.About]]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupHeaderView()
        setupUI()
        
    }
    
    func setupHeaderView() {
        let headerView: MCProfileHeaderView = Bundle.main.loadNibNamed("MCProfileHeaderView", owner: nil, options: nil)?.first as! MCProfileHeaderView
        var headerViewRect = headerView.frame
        headerViewRect.origin.y += kHeaderViewMargin
        self.tableView.tableHeaderView = headerView
    }
    
    func setupUI() {
        self.logoutButton.layer.cornerRadius = 10
        
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return vcs.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return vcs[section].count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId)
        
        cell?.textLabel?.text = vcs[indexPath.section][indexPath.row].title();
        
        return cell!
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // 加载目标VC
        let storyboard = UIStoryboard.init(name: "Profile", bundle: Bundle.main)
        let vcId = vcs[indexPath.section][indexPath.row].sbIdentifier()
        
        // 判断是否为非控制器跳转的选项
        if vcId == "profile_contactAuthor" {
            let emailAdd = "minecoder@163.com"
            // show alert
            let alertController = UIAlertController(title: "复制邮箱", message: "确认将作者邮箱复制到剪切板吗？", preferredStyle: .alert)
            let alertCancel = UIAlertAction(title: "取消", style: .cancel, handler: nil)
            let alertConfirm = UIAlertAction(title: "确认", style: .default, handler: { (alertConfirm) in
                let pasteBoard = UIPasteboard.general
                pasteBoard.string = emailAdd
                let confirmController = UIAlertController(title: "复制成功", message: "成功复制到剪切板", preferredStyle: .alert)
                let confirmMsg = UIAlertAction(title: "好的", style: .cancel, handler: nil)
                confirmController.addAction(confirmMsg)
                self.present(confirmController, animated: true, completion: nil)
            })
            alertController.addAction(alertCancel)
            alertController.addAction(alertConfirm)
            
            self.present(alertController, animated: true, completion: nil)
            return
        }
        
        let destinationVc = storyboard.instantiateViewController(withIdentifier: vcId)
        
        // 设置目标VC属性
        let vcTitle = vcs[indexPath.section][indexPath.row].title()
        destinationVc.navigationController?.title = vcTitle
        destinationVc.title = vcTitle
        
        // 跳转前准备工作
        hidesBottomBarWhenPushed = true
        // 跳转
        navigationController?.pushViewController(destinationVc, animated: true)
        
        // 跳转后工作
        hidesBottomBarWhenPushed = false
    }

//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        for iter in 0..<vc.count {
//            if segue.identifier == vc[iter].segueIdentifier() {
//                segue.destination.title = vc[iter].rawValue
//                break
//            }
//        }
//    
//    }
    @IBAction func logoutAction(_ sender: Any) {
        do {
            try Auth.auth().signOut()
            
            let vc = UIStoryboard.init(name: "Login", bundle: nil).instantiateInitialViewController() as! LoginViewController
            self.present(vc, animated: true, completion: {
                UIApplication.shared.keyWindow?.rootViewController = vc
            })
            
        } catch {
            print(error.localizedDescription)
            return
        }
    }

}
