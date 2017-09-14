//
//  LoginViewController.swift
//  Fisc
//
//  Created by Minecode on 2017/9/14.
//  Copyright © 2017年 Minecode. All rights reserved.
//

import UIKit
import Firebase

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
    }
}

// MARK: - main logic function
extension LoginViewController {
    
    func loginHandler() {
        guard let email = self.emailTextField.text,
            let password = self.passwordTextField.text
            else {
                return
        }
        
        Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
            
            if error != nil {
                print(error?.localizedDescription ?? "Unkown error")
                return
            }
            
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            appDelegate.uid = user?.uid
            
            let vc = UIStoryboard(name: "Main", bundle: nil).instantiateInitialViewController() as! MCTabBarController
            appDelegate.window?.rootViewController = vc
        }
    }
    
    func registerHandler() {
        guard let email = self.emailTextField.text,
              let password = self.passwordTextField.text
        else {
            return
        }
        
        Auth.auth().createUser(withEmail: email, password: password) { (user, error) in
            
            if error != nil {
                print(error?.localizedDescription ?? "Unkown error")
                return
            }
            
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            appDelegate.uid = user?.uid
            
            let vc = UIStoryboard(name: "Main", bundle: nil).instantiateInitialViewController() as! MCTabBarController
            appDelegate.window?.rootViewController = vc
        }
        
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
