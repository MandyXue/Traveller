//
//  MeTableViewController.swift
//  Traveller
//
//  Created by MandyXue on 16/5/21.
//  Copyright © 2016年 AppleClub. All rights reserved.
//

import UIKit
import MessageUI

class MeTableViewController: UITableViewController, MFMailComposeViewControllerDelegate {
    
    var user = UserBean(username: "Huo Teng", avatar: UIImage(named: "avatar")!, place: "Jiading District, Shanghai", gender: true, summary: "Like photography and coding", email: "huoteng@huoteng.com", homepage: "www.huoteng.com", registerDate: NSDate(timeIntervalSinceNow: 0))
    
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    
    let userModel = UserModel()
    var currentUser: UserBean?
    
    // MARK: - BaseViewController
    
    static func loadFromStoryboard() -> UIViewController {
        let controller = UIStoryboard.traveller_meStoryboard().instantiateViewControllerWithIdentifier(self.traveller_className())
//        let navigationController: UINavigationController = UINavigationController.init(rootViewController: controller)
        return controller
    }
    
    // MARK: - Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        avatarImageView.image = user.avatar
        nameLabel.text = user.username
        locationLabel.text = user.place
        
        //从NSUserDefault中取ID
//        let id = ""
//        
//        userModel.getUserDetail(byUserID: id)
//            .then { userInfo -> Void in
//                self.currentUser = userInfo
//                self.tableView.reloadData()
//            } .error { err in
//                // 错误处理
//                print(err)
//        }
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
            vc.user = self.user
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
                // TODO: logout
                //        UIApplication.sharedApplication().windows[0].rootViewController = DispatchController.dispatchToMain()
                UIApplication.sharedApplication().windows[0].rootViewController = WelcomeViewController.loadFromStoryboard()
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

}
