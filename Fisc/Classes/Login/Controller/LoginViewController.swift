//
//  LoginViewController.swift
//  Fisc
//
//  Created by Minecode on 2017/9/14.
//  Copyright © 2017年 Minecode. All rights reserved.
//

import UIKit
import Firebase
import SVProgressHUD

class LoginViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var iconImage: UIImageView!
    @IBOutlet weak var inputContainer: UIView!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var registerButton: UIButton!
    @IBOutlet weak var loginButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //self.view.backgroundColor = UIColor.white
        
        loadProfile()
        setupUI()
//        setup
        
    }
    
    func setupUI() {
        self.inputContainer.layer.cornerRadius = 10
        self.iconImage.image = UIImage(named: "logo")
        self.iconImage.contentMode = .scaleAspectFill
        self.iconImage.layer.cornerRadius = self.iconImage.frame.width/2
        
        // add target
        self.loginButton.addTarget(self, action: #selector(loginHandler), for: .touchUpInside)
        self.registerButton.addTarget(self, action: #selector(registerHandler), for: .touchUpInside)
        
        // init widget
        registerButton.isEnabled = true
        loginButton.isEnabled = true
        // SVProgressHUD
        SVProgressHUD.setDefaultMaskType(.black)
        SVProgressHUD.setMinimumDismissTimeInterval(1)
        SVProgressHUD.setMaximumDismissTimeInterval(1)
    }
}

// MARK: - main logic function
extension LoginViewController {
    
    func loadProfile() {
        let userDefaults = UserDefaults.standard
        
        if userDefaults.bool(forKey: "isSaved") {
            // load profile
            let account = userDefaults.string(forKey: "savedAccount")
            let password = userDefaults.string(forKey: "savedPassword")
            // load to text field
            emailTextField.text = account
            passwordTextField.text = password
        }
    }
    
    func writeProfile(accout: String, password: String) {
        let userDefaults = UserDefaults.standard
        userDefaults.set(true, forKey: "isSaved")
        
        // save
        userDefaults.set(accout, forKey: "savedAccount")
        userDefaults.set(password, forKey: "savedPassword")
    }
    
    func loginHandler() {
        guard let email = self.emailTextField.text,
            let password = self.passwordTextField.text
            else {
                return
        }
        
        SVProgressHUD.show(withStatus: "登录中")
        loginButton.isEnabled = false
        Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
            
            if error != nil {
                
                let errorMsg = error?.localizedDescription
                SVProgressHUD.showError(withStatus: errorMsg ?? "未知错误")
                self.loginButton.isEnabled = true
                
                return
            }
            
            SVProgressHUD.showSuccess(withStatus: "登录成功")
            self.loginProcesser(with: user)
        }
    }
    
    func registerHandler() {
        guard let email = self.emailTextField.text,
              let password = self.passwordTextField.text
        else {
            return
        }
        
        SVProgressHUD.show(withStatus: "注册中")
        
        self.registerButton.isEnabled = false
        Auth.auth().createUser(withEmail: email, password: password) { (user, error) in
            
            if error != nil {
                let errorMsg = error?.localizedDescription
                SVProgressHUD.showError(withStatus: errorMsg ?? "未知错误")
                self.registerButton.isEnabled = true
                
                return
            }
            
            SVProgressHUD.showSuccess(withStatus: "注册成功")
            self.loginProcesser(with: user)
        }
        
    }
    
    func showAlert(with msg: String) {
        let alert = UIAlertController(title: "错误", message: msg, preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "确定", style: .cancel) { (alertAction) in
            self.emailTextField.text?.removeAll()
            self.passwordTextField.text?.removeAll()
            self.usernameTextField.text?.removeAll()
        }
        alert.addAction(alertAction)
        present(alert, animated: true, completion: nil)
    }
    
    func loginProcesser(with user: User?) {
        let accout = emailTextField.text ?? ""
        let password = passwordTextField.text ?? ""
        self.writeProfile(accout: accout, password: password)
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.uid = user?.uid
        
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateInitialViewController() as! MCTabBarController
        appDelegate.window?.rootViewController = vc
    }
    
}

// MARK: - delegate impelemention
extension LoginViewController {
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        let curTag = textField.tag
        print(curTag)
        if curTag < 3 {
//            textField.resignFirstResponder()
            self.inputContainer.viewWithTag(curTag+1)?.becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
        }
        
        return true
    }
    
}
