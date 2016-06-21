//
//  UserListTableViewController.swift
//  Traveller
//
//  Created by MandyXue on 16/6/6.
//  Copyright © 2016年 AppleClub. All rights reserved.
//

import UIKit
import PKHUD

class UserListTableViewController: UITableViewController {
    
    var type: Bool = true // true: following, false: follower
    var users: [UserBean] = []
    var userModel = UserModel()
    
    // MARK: - BaseViewController
    
    static func loadFromStoryboard() -> UIViewController {
        let controller = UIStoryboard.traveller_userListStoryboard().instantiateViewControllerWithIdentifier(self.traveller_className())
        return controller
    }
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = type ? "Following": "Follower"
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        // 获取数据
        HUD.show(.LabeledProgress(title: nil, subtitle: "Loading"))
        userModel.getFollowList(byUserID: userModel.userID, isFollowing: type)
            .then { users -> () in
                self.users = users
                self.tableView.reloadData()
                HUD.flash(.Success)
            }.error { err in
                print(err)
                // TODO: 错误处理
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if type {
            let cell = tableView.dequeueReusableCellWithIdentifier("FollowingCell", forIndexPath: indexPath) as! FollowingTableViewCell
            let avatarImage = users[indexPath.row].avatar
            cell.avatarImageView.image = (avatarImage == nil) ? UIImage(named: "avatar"): avatarImage
            cell.usernameLabel.text = users[indexPath.row].username
            let username = users[indexPath.row].place
            cell.locationLabel.text = (username == nil || username! == "") ? "not setted": username
            return cell
        } else {
            let cell = tableView.dequeueReusableCellWithIdentifier("FollowerCell", forIndexPath: indexPath) as! FollowerTableViewCell
            let avatarImage = users[indexPath.row].avatar
            cell.avatarImageView.image = (avatarImage == nil) ? UIImage(named: "avatar"): avatarImage
            cell.usernameLabel.text = users[indexPath.row].username
            let username = users[indexPath.row].place
            cell.locationLabel.text = (username == nil || username! == "") ? "not setted": username
            return cell
        }
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let vc = UserDetailTableViewController.loadFromStoryboard() as! UserDetailTableViewController
        vc.user = users[indexPath.row]
        navigationController?.pushViewController(vc, animated: true)
    }
}
