//
//  UserListTableViewController.swift
//  Traveller
//
//  Created by MandyXue on 16/6/6.
//  Copyright © 2016年 AppleClub. All rights reserved.
//

import UIKit

class UserListTableViewController: UITableViewController {
    
    var type: Bool = true // true: following, false: follower
    var users: [UserModel] = []
    
    // MARK: - BaseViewController
    
    static func loadFromStoryboard() -> UIViewController {
        let controller = UIStoryboard.traveller_userListStoryboard().instantiateViewControllerWithIdentifier(self.traveller_className())
        return controller
    }
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = type ? "Following": "Follower"
        setInfo()
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
            cell.avatarImageView.image = users[indexPath.row].avatar
            cell.usernameLabel.text = users[indexPath.row].username
            cell.locationLabel.text = users[indexPath.row].place
            return cell
        } else {
            let cell = tableView.dequeueReusableCellWithIdentifier("FollowerCell", forIndexPath: indexPath) as! FollowerTableViewCell
            cell.avatarImageView.image = users[indexPath.row].avatar
            cell.usernameLabel.text = users[indexPath.row].username
            cell.locationLabel.text = users[indexPath.row].place
            return cell
        }
    }
    
    // MARK: - Helper
    
    func setInfo() {
        // TODO: 根据type使用不同接口
        var i = 0
        while i < 20 {
            users.append(UserModel(username: "user\(i)", avatar: UIImage(named: "avatar")!, place: "Shanghai\(i)"))
            i += 1
        }
    }
}
