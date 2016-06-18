//
//  SignupTableViewController.swift
//  Traveller
//
//  Created by MandyXue on 16/6/10.
//  Copyright © 2016年 AppleClub. All rights reserved.
//

import UIKit
import Regex

class SignupTableViewController: UITableViewController {

    let userModel: UserModel = UserModel()
    
    @IBOutlet weak var inputEmail: UITextField!
    @IBOutlet weak var inputUsername: UITextField!
    @IBOutlet weak var inputPassword: UITextField!
    @IBOutlet weak var repeatPassword: UITextField!
    
    
    @IBOutlet weak var confirmView: UIView!
    @IBOutlet weak var passwordView: UIView!
    @IBOutlet weak var usernameView: UIView!
    @IBOutlet weak var emailView: UIView!
    @IBOutlet weak var signupButton: UIButton!
    @IBAction func cancel(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    @IBAction func signup(sender: AnyObject) {
        // TODO: 连接注册接口
//        UIApplication.sharedApplication().windows[0].rootViewController = DispatchController.dispatchToMain()
        
        // 输入检查
        let email = inputEmail.text!
        let emailResult = email.grep("^\\w[-\\w.+]*@([A-Za-z0-9][-A-Za-z0-9]+\\.)+[A-Za-z]{2,14}")
        
        let name = inputUsername.text!
        let nameResult = name.grep("^[A-Za-z0-9_\\-\\u4e00-\\u9fa5]+")
        
        let password = inputPassword.text!
        let repeatPass = repeatPassword.text!
        
        if !emailResult.boolValue || !nameResult.boolValue || (password != repeatPass) {
            print("输入有误，请重新输入")
            return
        }
        
        // 注册新用户
        let user = UserBean(name: inputUsername.text!, password: inputPassword.text!, email: inputEmail.text!)

        userModel.signup(user)
            .then { isSuccess -> Void in
                if isSuccess {
                    print("signup successful")
                } else {
                    print("signup failed")
                }
            }.error { err in
                print("signup with error")
                print(err)
            }
        
        
        UIApplication.sharedApplication().windows[0].rootViewController = RootTabBarController.loadFromStoryboard()
    }
    
    // MARK: - BaseViewController
    
    static func loadFromStoryboard() -> UIViewController {
        let controller = UIStoryboard.traveller_signupStoryboard().instantiateViewControllerWithIdentifier(self.traveller_className())
        return controller
    }
    
    // MARK: - Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpUI()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Helper
    
    func setUpUI() {
        tableView.backgroundView = UIImageView(image:UIImage(named: "background"))
        UIButton.defaultStyle(signupButton)
        emailView.layer.cornerRadius = emailView.bounds.height/2
        usernameView.layer.cornerRadius = usernameView.bounds.height/2
        passwordView.layer.cornerRadius = passwordView.bounds.height/2
        confirmView.layer.cornerRadius = confirmView.bounds.height/2
    }

}
