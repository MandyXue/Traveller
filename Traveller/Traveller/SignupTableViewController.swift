//
//  SignupTableViewController.swift
//  Traveller
//
//  Created by MandyXue on 16/6/10.
//  Copyright © 2016年 AppleClub. All rights reserved.
//

import UIKit
import Regex
import PromiseKit
import PKHUD

class SignupTableViewController: UITableViewController {
    
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
        
        // 输入检查
        let email = inputEmail.text!
        let emailResult = email.grep("^\\w[-\\w.+]*@([A-Za-z0-9][-A-Za-z0-9]+\\.)+[A-Za-z]{2,14}")
        
        let name = inputUsername.text!
        let nameResult = name.grep("^[A-Za-z0-9_\\-\\u4e00-\\u9fa5]+")
        
        let password = inputPassword.text!
        let repeatPass = repeatPassword.text!
        
        if !emailResult.boolValue {
            let alert = UIAlertController(title: "Invalid input", message: "Your email address is invalid.", preferredStyle: .Alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .Cancel, handler: nil))
            presentViewController(alert, animated: true, completion: nil)
            return
        }
        if !nameResult.boolValue {
            let alert = UIAlertController(title: "Invalid input", message: "Your name is invalid.", preferredStyle: .Alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .Cancel, handler: nil))
            presentViewController(alert, animated: true, completion: nil)
            return
        }
        if password != repeatPass {
            let alert = UIAlertController(title: "Invalid input", message: "Your confirm password is invalid.", preferredStyle: .Alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .Cancel, handler: nil))
            presentViewController(alert, animated: true, completion: nil)
            return
        }
        
        HUD.show(.Progress)
        // 注册新用户
        let user = UserBean(name: inputUsername.text!, password: inputPassword.text!, email: inputEmail.text!)

        UserModel.signup(user)
            .then { isSuccess -> Promise<Bool> in
                if isSuccess {
                    HUD.flash(.LabeledSuccess(title: "Success", subtitle: "Welcome to Traveller!"), delay: 1.0)
                    HUD.show(.LabeledProgress(title: "Login...", subtitle: "Automatically login for you."))
                    print("signup successful")
                    return UserModel.login(user.username, password: user.password!)
                } else {
                    HUD.flash(.LabeledError(title: "Error", subtitle: "Register failed, please try again."), delay: 1.5)
                    print("signup failed")
                    return Promise { fulfill, reject in
                        reject(SignupError.SignupFailled)
                    }
                }
            }.then { loginSuccess -> () in
                if loginSuccess {
                    HUD.flash(.LabeledSuccess(title: "Success", subtitle: "Login success!"), delay: 1.0)
                    UIApplication.sharedApplication().windows[0].rootViewController = RootTabBarController.loadFromStoryboard()
                } else {
                    // 登录失败
                    HUD.flash(.LabeledError(title: "Error", subtitle: "Login failed, please try again"), delay: 1.5)
                }
            }.error { err in
                print("signup with error")
                print(err)
                // TODO: 错误处理
                HUD.flash(.LabeledError(title: "Error", subtitle: "\(err)"), delay: 1.5)
            }
        
        
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
