//
//  WelcomeViewController.swift
//  Traveller
//
//  Created by MandyXue on 16/5/21.
//  Copyright © 2016年 AppleClub. All rights reserved.
//

import UIKit

class WelcomeViewController: UIViewController {
    
    @IBOutlet weak var signupButton: UIButton!
    @IBOutlet weak var loginButton: UIButton!
    @IBAction func gotoSignup(sender: AnyObject) {
        let vc = SignupTableViewController.loadFromStoryboard()
        presentViewController(vc, animated: true, completion: nil)
    }
    @IBAction func gotoLogin(sender: AnyObject) {
        let vc = LoginTableViewController.loadFromStoryboard()
        presentViewController(vc, animated: true, completion: nil)
    }
    
    // MARK: - BaseViewController
    
    static func loadFromStoryboard() -> UIViewController {
        let controller = UIStoryboard.traveller_welcomeStoryboard().instantiateViewControllerWithIdentifier(self.traveller_className())
        return controller
    }
    
    // MARK: - Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setUpUI() {
        view.backgroundColor = UIColor(patternImage: UIImage(named: "background")!)
        UIButton.defaultStyle(signupButton)
        UIButton.defaultStyle(loginButton)
    }

}
