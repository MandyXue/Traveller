//
//  LoginTableViewController.swift
//  Traveller
//
//  Created by MandyXue on 16/6/10.
//  Copyright © 2016年 AppleClub. All rights reserved.
//

import UIKit
import PKHUD

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
        
        if usernameTextField.text == nil || usernameTextField.text! == "" {
            let alert = UIAlertController(title: "Invalid input", message: "Your username is empty.", preferredStyle: .Alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .Cancel, handler: nil))
            presentViewController(alert, animated: true, completion: nil)
            return
        }
        
        if passwordTextField.text == nil || passwordTextField.text! == "" {
            let alert = UIAlertController(title: "Invalid input", message: "Your password is empty.", preferredStyle: .Alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .Cancel, handler: nil))
            presentViewController(alert, animated: true, completion: nil)
            return
        }
        usernameTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
        HUD.show(.Progress)
        if let name = usernameTextField.text, let pass = passwordTextField.text {
            UserModel.login(name, password: pass)
                .then { isSuccess -> () in
                    self.usernameTextField.resignFirstResponder()
                    self.passwordTextField.resignFirstResponder()
                    HUD.flash(.LabeledSuccess(title: "Success", subtitle: "Login successful."))
                    UIApplication.sharedApplication().windows[0].rootViewController = RootTabBarController.loadFromStoryboard()
                }.error { err in
                    // TODO: 提示错误
                    self.handleErrorMsg(err)
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
