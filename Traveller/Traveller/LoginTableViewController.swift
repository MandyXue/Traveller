//
//  LoginTableViewController.swift
//  Traveller
//
//  Created by MandyXue on 16/6/10.
//  Copyright © 2016年 AppleClub. All rights reserved.
//

import UIKit

class LoginTableViewController: UITableViewController {
    
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var passwordView: UIView!
    @IBOutlet weak var usernameView: UIView!
    @IBOutlet weak var loginButton: UIButton!
    @IBAction func cancel(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    @IBAction func login(sender: AnyObject) {
        // TODO: 连接注册接口
        //        UIApplication.sharedApplication().windows[0].rootViewController = DispatchController.dispatchToMain()
        
        if let name = usernameTextField.text, let pass = passwordTextField.text {
            UserModel.login(name, password: pass)
                .then { isSuccess -> () in
                    UIApplication.sharedApplication().windows[0].rootViewController = RootTabBarController.loadFromStoryboard()
                }.error { err in
                    // 提示错误
            }
        }
        
    }
    
    // MARK: - BaseViewController
    
    static func loadFromStoryboard() -> UIViewController {
        let controller = UIStoryboard.traveller_loginStoryboard().instantiateViewControllerWithIdentifier(self.traveller_className())
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
    
    func setUpUI() {
        tableView.backgroundView = UIImageView(image:UIImage(named: "background"))
        UIButton.defaultStyle(loginButton)
        usernameView.layer.cornerRadius = usernameView.bounds.height/2
        passwordView.layer.cornerRadius = passwordView.bounds.height/2
    }
    
}
