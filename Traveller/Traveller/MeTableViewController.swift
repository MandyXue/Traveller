//
//  MeTableViewController.swift
//  Traveller
//
//  Created by MandyXue on 16/5/21.
//  Copyright © 2016年 AppleClub. All rights reserved.
//

import UIKit
import MessageUI
import PKHUD

class MeTableViewController: UITableViewController, MFMailComposeViewControllerDelegate, ModifyUserInfoDelegate {
    
    var user = UserBean(username: "not setted", avatar: UIImage(named: "avatar")!, place: "not setted", gender: true, summary: "not setted", email: "not setted", homepage: "not setted", registerDate: NSDate(timeIntervalSinceNow: 0))
    
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    
    let userModel = UserModel()
    var currentUser: UserBean?
    
    // MARK: - BaseViewController
    
    static func loadFromStoryboard() -> UIViewController {
        let controller = UIStoryboard.traveller_meStoryboard().instantiateViewControllerWithIdentifier(self.traveller_className())
        return controller
    }
    
    // MARK: - Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        HUD.show(.LabeledProgress(title: nil, subtitle: "Loading..."))
        userModel.getUserDetail(byUserID: userModel.userID)
            .then { userInfo -> Void in
                print("get user info in Me")
                
                self.nameLabel.text = userInfo.username
                self.locationLabel.text = (userInfo.place == nil || userInfo.place! == "") ? "not setted": userInfo.place
                HUD.flash(.Success)
                self.currentUser = userInfo
                self.tableView.reloadData()
            } .error { err in
                // 错误处理
                switch err {
                case DataError.TokenInvalid:
                    let vc = WelcomeViewController.loadFromStoryboard()
                    self.presentViewController(vc, animated: true, completion: nil)
                default:
                    print("get user info error:")
                    print(err)
                }
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        // set up navigation bar
        self.tabBarController?.navigationItem.title = "Me"
        self.tabBarController?.navigationItem.rightBarButtonItem = nil
        self.tabBarController?.navigationItem.leftBarButtonItem = nil
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table View Delegate
    
    override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 12))
        view.backgroundColor = UIColor.clearColor()
        return view
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        switch indexPath.section {
        // setting information
        case 0:
            let vc = InfoSettingTableViewController.loadFromStoryboard() as! InfoSettingTableViewController
            vc.user = self.currentUser!
            vc.modifyInfoDelegate = self
            self.navigationController?.pushViewController(vc, animated: true)
        // followings and followers
        case 1:
            let vc = UserListTableViewController.loadFromStoryboard() as! UserListTableViewController
            vc.type = (indexPath.row == 0) ? true: false
            self.navigationController?.pushViewController(vc, animated: true)
        // my posts and my comments
        case 2:
            let vc = PostListTableViewController.loadFromStoryboard() as! PostListTableViewController
            vc.type = (indexPath.row == 0) ? 1: 2
            self.navigationController?.pushViewController(vc, animated: true)
        // about traveller and feedback
        case 3:
            if indexPath.row == 0 {
                let vc = storyboard?.instantiateViewControllerWithIdentifier("AboutTraveller")
                navigationController?.pushViewController(vc!, animated: true)
            } else {
                let title = "Feedback of Traveller @"+user.username
                let messageBody = ""
                let toRecipents = ["xuemengdi513@gmail.com"]
                self.send(title, messageBody: messageBody, toRecipients: toRecipents)
            }
        // logout
        case 4:
            let alert = UIAlertController(title: "Are you sure to log out?", message: nil, preferredStyle: .Alert)
            alert.addAction(UIAlertAction(title: "No", style: .Cancel, handler: nil))
            alert.addAction(UIAlertAction(title: "Yes", style: .Default, handler: { (action) in
                UIApplication.sharedApplication().windows[0].rootViewController = WelcomeViewController.loadFromStoryboard()
                NSUserDefaults.standardUserDefaults().setObject(nil, forKey: "token")
                print("logout")
            }))
            presentViewController(alert, animated: true, completion: nil)
        default:
            break
        }
        tableView.cellForRowAtIndexPath(indexPath)?.setSelected(false, animated: false)
    }
    
    // MARK: - Sending Emails
    
    func send(title: String, messageBody: String, toRecipients: [String]) {
        if MFMailComposeViewController.canSendMail() {
            let mc: MFMailComposeViewController = MFMailComposeViewController()
            mc.mailComposeDelegate = self
            mc.setSubject(title)
            mc.setMessageBody(messageBody, isHTML: false)
            mc.setToRecipients(toRecipients)
            mc.navigationBar.tintColor = UIColor.whiteColor()
            self.presentViewController(mc, animated: true, completion: nil)
        } else {
            print("No email account found.")
        }
    }
    
    func mailComposeController(controller: MFMailComposeViewController, didFinishWithResult result: MFMailComposeResult, error: NSError?) {
        
        self.dismissViewControllerAnimated(false, completion: nil)
        
        switch result.rawValue {
        case MFMailComposeResultCancelled.rawValue:
            print("Mail Cancelled")
        case MFMailComposeResultSaved.rawValue:
            let alert = UIAlertController(title: "Saved", message: "Your mail has been saved.", preferredStyle: .Alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .Cancel, handler: nil))
            presentViewController(alert, animated: true, completion: nil)
        case MFMailComposeResultSent.rawValue:
            let alert = UIAlertController(title: "Success", message: "Your mail has been sent.", preferredStyle: .Alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .Cancel, handler: nil))
            presentViewController(alert, animated: true, completion: nil)
        case MFMailComposeResultFailed.rawValue:
            let alert = UIAlertController(title: "Fail", message: "Your mail has failed to be sent according to unknown error.", preferredStyle: .Alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .Cancel, handler: nil))
            presentViewController(alert, animated: true, completion: nil)
        default: break
        }
    }
    
    func setNewUserInfo(newInfo: UserBean) {
        self.user = newInfo
    }

}
