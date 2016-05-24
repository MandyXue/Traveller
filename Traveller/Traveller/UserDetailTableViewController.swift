//
//  UserDetailTableViewController.swift
//  Traveller
//
//  Created by MandyXue on 16/5/24.
//  Copyright © 2016年 AppleClub. All rights reserved.
//

import UIKit
import LTNavigationBar
import SnapKit

class UserDetailTableViewController: UITableViewController {
    
    let NAVBAR_CHANGE_POINT: CGFloat = 50
    
    var user = UserModel()
    
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var followingLabel: UILabel!
    
    // MARK: - BaseViewController
    
    static func loadFromStoryboard() -> UIViewController {
        let controller = UIStoryboard.traveller_userDetailStoryboard().instantiateViewControllerWithIdentifier(self.traveller_className())
        return controller
    }
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        self.navigationController?.navigationBar.lt_setBackgroundColor(UIColor.clearColor())
        
        setUpUI()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        scrollViewDidScroll(tableView)
        tableView.delegate = self
        navigationController?.navigationBar.shadowImage = UIImage()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        tableView.delegate = nil
        navigationController?.navigationBar.lt_reset()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Helper
    
    func setUpUI() {
        if user.avatar != nil {
            avatarImageView.image = user.avatar
        }
        nameLabel.text = user.username
        followingLabel.text = "0 Followers | 0 Following"
    }
    
}

// MARK: - Table view setting

extension UserDetailTableViewController {
    
    override func scrollViewDidScroll(scrollView: UIScrollView) {
        let color = UIColor(red: 126/255, green: 211/255, blue: 33/255, alpha: 1)
        let offsetY = scrollView.contentOffset.y
        
        if offsetY > NAVBAR_CHANGE_POINT {
            let alpha = min(1, 1-((NAVBAR_CHANGE_POINT+64-offsetY)/64))
            
            navigationController?.navigationBar.lt_setBackgroundColor(color.colorWithAlphaComponent(alpha))
            self.title = user.username
        } else {
            navigationController?.navigationBar.lt_setBackgroundColor(color.colorWithAlphaComponent(0))
            self.title = ""
        }
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 25
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("UserDetailCell", forIndexPath: indexPath)
        
        // Configure the cell...
        
        return cell
    }
    
    override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 44))
        view.backgroundColor = UIColor.whiteColor()
        
        // draw a line
        let line = UIView(frame: CGRect(x: 0, y: 42, width: tableView.frame.size.width, height: 2))
        line.backgroundColor = UIColor(red: 0.5, green: 0.5, blue: 0.5, alpha: 0.2)
        view.addSubview(line)
        
        // draw two buttons
        let width = view.frame.size.width/2
        let button = UIButton.drawButton(width, x: 0, title: "Profile")
        button.addTarget(self, action: #selector(getProfile), forControlEvents: .TouchUpInside)
        view.addSubview(button)
        
        let button2 = UIButton.drawButton(width, x: width, title: "Posts")
        button2.addTarget(self, action: #selector(getPosts), forControlEvents: .TouchUpInside)
        view.addSubview(button2)
        return view
    }
    
    // helper
    func getProfile(sender: UIButton!) {
        print("profile")
        tableView.reloadData()
        sender.selected = true
    }
    
    func getPosts(sender: UIButton!) {
        print("posts")
        tableView.reloadData()
        sender.selected = true
    }
}

extension UIButton {
    static func drawButton(width: CGFloat, x: CGFloat, title: String) -> UIButton {
        let button = UIButton(type: .Custom)
        button.frame = CGRectMake(x, 5, width, 30)
        button.setTitle(title, forState: .Normal)
        let color = UIColor(red: 0.5, green: 0.5, blue: 0.5, alpha: 1)
        button.setTitleColor(color, forState: .Normal)
        button.setTitleColor(UIColor.blackColor(), forState: .Selected)
        button.titleLabel?.font = UIFont(name: "System", size: 12)
        return button
    }
}
