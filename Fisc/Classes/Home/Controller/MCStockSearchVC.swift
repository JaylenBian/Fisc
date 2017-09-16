//
//  MCStockSearchVC.swift
//  Fisc
//
//  Created by Minecode on 2017/9/15.
//  Copyright © 2017年 Minecode. All rights reserved.
//

import UIKit
import SVProgressHUD


class MCStockSearchVC: UIViewController, UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate {
    
    @IBOutlet weak var closeButton: UIBarButtonItem!
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var tableView: UITableView!
    
    var recommands: [MCStock] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        
        loadRecommands()
        
    }
    
    func setupUI() {
        closeButton.action = #selector(self.closeHandler)
    }
    
    func loadRecommands() {
        recommands = [
            MCStock(name: "上海机场", code: "0600009"),
            MCStock(name: "东风汽车", code: "0600006")
        ]
        self.tableView.reloadData()
    }
    
    @IBAction func closeAction(_ sender: Any) {
        self.closeHandler()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        if textField.tag == 1 {
            if let text = textField.text {
                print(text)
            }
        }
        
        return true
    }
    
    
}

// MARK: - main logic function
extension MCStockSearchVC {
    
    
    func closeHandler() {
        self.dismiss(animated: true, completion: nil)
    }
    
}

// MARK: - tableview protocol implemention
extension MCStockSearchVC {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recommands.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "recommandCell")
        
        cell?.textLabel?.text = self.recommands[indexPath.row].name
        cell?.detailTextLabel?.text = self.recommands[indexPath.row].code
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
}
