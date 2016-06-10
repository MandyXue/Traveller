//
//  SignupTableViewController.swift
//  Traveller
//
//  Created by MandyXue on 16/6/10.
//  Copyright © 2016年 AppleClub. All rights reserved.
//

import UIKit

class SignupTableViewController: UITableViewController {
    
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
