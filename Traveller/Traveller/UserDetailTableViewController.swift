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
import MapKit
import SDWebImage

class UserDetailTableViewController: UITableViewController {
    
    let NAVBAR_CHANGE_POINT: CGFloat = 50
    
    var user = UserBean()
    var profile = [String:String]()
    var type: Bool = true //true就是profile,false是posts
    
    let userModel = UserModel()
    let postModel = PostModel()
    
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var followingLabel: UILabel!
    @IBOutlet weak var avatarBackImageView: UIImageView!
    @IBOutlet weak var backgroundView: UIView!
    
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
        
        // 做一下好友判断
        modifyFollowBtn()
        setUpUI()
        
        postModel.getPosts(byUserID: self.user.id!)
            .then { posts -> () in
                self.user.posts = posts
                print(posts)
                self.tableView.reloadData()
            }.error { err in
                self.handleErrorMsg(err)
        }
    }
    
    func modifyFollowBtn () {
        if !user.isFollowed {
            self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Follow", style: .Plain, target: self, action: #selector(follow))
        } else {
            self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Cancel Follow", style: .Plain, target: self, action: #selector(disFollow))
        }
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
        avatarImageView.image = UIImage(named: "avatar")
        nameLabel.text = user.username
        followingLabel.text = "\(user.followerNum) Followers | \(user.followingNum) Following"
    }
    
    func follow() {
        print("follow \(user.username)")
        userModel.followUser(followingId: userModel.userID, followeeId: user.id!)
            .then { isSuccess -> () in
                self.user.isFollowed = true
                self.modifyFollowBtn()
            }.error { err in
                self.handleErrorMsg(err)
        }
    }
    
    func disFollow () {
        userModel.cancelFollow(followingId: userModel.userID, followeeId: user.id!)
            .then { isSuccess -> () in
                self.user.isFollowed = false
                self.modifyFollowBtn()
            }.error { err in
                self.handleErrorMsg(err)
        }
    }
}

// MARK: - Table view setting

extension UserDetailTableViewController {
    
    override func scrollViewDidScroll(scrollView: UIScrollView) {
        let color = UIColor.customGreenColor()
        let offsetY = scrollView.contentOffset.y
        
        if offsetY > NAVBAR_CHANGE_POINT {
            let alpha = min(1, 1-((NAVBAR_CHANGE_POINT+64-offsetY)/64))
            
            navigationController?.navigationBar.lt_setBackgroundColor(color.colorWithAlphaComponent(alpha))
            self.title = user.username
        } else {
            navigationController?.navigationBar.lt_setBackgroundColor(color.colorWithAlphaComponent(0))
            self.title = ""
        }
        
        // set header view
        if offsetY < -64.0 {
            let heightAfter = 164+abs(offsetY)
            self.backgroundView.frame = CGRect(x: 0, y: offsetY, width: self.view.frame.size.width, height: heightAfter+64)
            let widthAfter = heightAfter/228*self.view.frame.size.width
            self.avatarBackImageView.frame = CGRect(x: -(widthAfter-self.view.frame.size.width)/2, y: offsetY, width: widthAfter, height: heightAfter)
        }
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if type {
            return 7
        } else {
            return user.posts.count
        }
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if type {
            let cell = tableView.dequeueReusableCellWithIdentifier("UserDetailCell", forIndexPath: indexPath) as! UserProfileTableViewCell
            switch indexPath.row {
            case 0:
                cell.keyLabel.text = "Name"
                cell.valueLabel.text = user.username
            case 1:
                cell.keyLabel.text = "Place"
                cell.valueLabel.text = (user.place == nil || user.place! == "") ? "not setted": user.place
            case 2:
                cell.keyLabel.text = "Gender"
                cell.valueLabel.text = user.gender! ? "male" : "female"
            case 3:
                cell.keyLabel.text = "Summary"
                cell.valueLabel.text = (user.summary == nil || user.summary! == "") ? "not setted": user.summary
            case 4:
                cell.keyLabel.text = "Email"
                cell.valueLabel.text = user.email
            case 5:
                cell.keyLabel.text = "Homepage"
                cell.valueLabel.text = (user.homepage == nil || user.homepage! == "") ? "not setted": user.homepage
            case 6:
                cell.keyLabel.text = "Register Date"
                cell.valueLabel.text = NSDateFormatter.stringFromDate(user.registerDate!)
            default:
                cell.keyLabel.text = "not setted"
                cell.valueLabel.text = "not setted"
            }
            return cell
        } else {
            let cell = tableView.dequeueReusableCellWithIdentifier("UserPostCell", forIndexPath: indexPath) as! UserPostTableViewCell
            cell.imageView?.image = UIImage(named: "testPost")
            cell.postNameLabel.text = user.posts[indexPath.row].title
            cell.postLocationLabel.text = user.posts[indexPath.row].address
            return cell
        }
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let cell = tableView.cellForRowAtIndexPath(indexPath)
        cell?.setSelected(false, animated: false)
        if !type {
            if let detailView = PostDetailTableViewController.loadFromStoryboard() as? PostDetailTableViewController {
                // TODO: 接上接口以后要改这个参数
                detailView.postId = user.posts[indexPath.row].id!
                self.navigationController?.pushViewController(detailView, animated: true)
            } else {
                print("something went wrong...")
            }
        }
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if type {
            return 45
        } else {
            return 84
        }
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
        
        // draw underline
        let underline = UIView()
        if type {
            underline.frame = CGRect(x: 0, y: 40, width: tableView.frame.size.width/2, height: 4)
        } else {
            underline.frame = CGRect(x: tableView.frame.size.width/2, y: 40, width: tableView.frame.size.width/2, height: 4)
        }
        underline.backgroundColor = UIColor.customGreenColor()
        view.addSubview(underline)
        
        return view
    }
    
    // helper
    func getProfile(sender: UIButton!) {
        print("profile")
        type = true
        tableView.reloadData()
    }
    
    func getPosts(sender: UIButton!) {
        print("posts")
        type = false
        tableView.reloadData()
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
