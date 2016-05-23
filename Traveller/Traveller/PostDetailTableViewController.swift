//
//  PostDetailTableViewController.swift
//  Traveller
//
//  Created by MandyXue on 16/5/21.
//  Copyright © 2016年 AppleClub. All rights reserved.
//

import UIKit
import QuartzCore
import LTNavigationBar

class PostDetailTableViewController: UITableViewController {
    
    let NAVBAR_CHANGE_POINT: CGFloat = 50
    
    var post = PostModel()
    var comments: [CommentModel] = []
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var addButton: UIButton!
    @IBAction func addImage(sender: AnyObject) {
        print("add image")
    }
    
    // MARK: - BaseViewController
    
    static func loadFromStoryboard() -> UIViewController {
        let controller = UIStoryboard.traveller_postStoryboard().instantiateViewControllerWithIdentifier(self.traveller_className())
        return controller
    }
    
    // MARK: - Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        self.navigationController?.navigationBar.lt_setBackgroundColor(UIColor.clearColor())
        
        prepareData()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        scrollViewDidScroll(tableView)
        tableView.delegate = self
        navigationController?.navigationBar.shadowImage = UIImage()
        
        if post.place != nil {
            setUpUI()
        }
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
        addButton.layer.borderWidth = 2
        addButton.layer.cornerRadius = 5
        addButton.layer.borderColor = UIColor(red: 255/255, green: 211/255, blue: 0/155, alpha: 0.8).CGColor
        titleLabel.text = post.place
    }
    
    func prepareData() {
        comments.append(CommentModel(user: UserModel(username: "Mandy Xue", avatar: UIImage(named: "avatar")!, place: "Yang Pu District, Shanghai"), comment: "Great place, I want to go.", time: NSDate(timeIntervalSinceNow: 0)))
        comments.append(CommentModel(user: UserModel(username: "Mandy Xue", avatar: UIImage(named: "avatar")!, place: "Yang Pu District, Shanghai"), comment: "Great place, I want to go.", time: NSDate(timeIntervalSinceNow: 0)))
        comments.append(CommentModel(user: UserModel(username: "Mandy Xue", avatar: UIImage(named: "avatar")!, place: "Yang Pu District, Shanghai"), comment: "Great place, I want to go.", time: NSDate(timeIntervalSinceNow: 0)))
    }

}

// MARK: - Table view setting

extension PostDetailTableViewController {
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 2+comments.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            let cell = tableView.dequeueReusableCellWithIdentifier("DetailCell", forIndexPath: indexPath) as! PostDetailTableViewCell
            cell.locationLabel.text = post.address
            cell.descriptionLabel.text = post.detail
            return cell
        case 1:
            let cell = tableView.dequeueReusableCellWithIdentifier("CreatorCell", forIndexPath: indexPath) as! PostCreatorTableViewCell
            cell.creatorImageView.image = post.creator.avatar
            cell.creatorNameLabel.text = post.creator.username
            cell.creatorPlaceLabel.text = post.creator.place
            return cell
        default:
            let cell = tableView.dequeueReusableCellWithIdentifier("CommentCell", forIndexPath: indexPath) as! PostCommentTableViewCell
            cell.commentLabel.text = comments[indexPath.row-2].comment
            let user = comments[indexPath.row-2].user
            cell.commentImageView.image = user.avatar
            cell.commentNameLabel.text = user.username
            cell.commentTimeLabel.text = NSDate.dateToString(comments[indexPath.row-2].time)
            return cell
        }
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        switch indexPath.row {
        case 0:
            return 147.0
        case 1:
            return 105.0
        default:
            return 65.0
        }
    }

    override func scrollViewDidScroll(scrollView: UIScrollView) {
        let color = UIColor(red: 126/255, green: 211/255, blue: 33/255, alpha: 1)
        let offsetY = scrollView.contentOffset.y
        
        if offsetY > NAVBAR_CHANGE_POINT {
            let alpha = min(1, 1-((NAVBAR_CHANGE_POINT+64-offsetY)/64))
            
            navigationController?.navigationBar.lt_setBackgroundColor(color.colorWithAlphaComponent(alpha))
            self.title = post.place
        } else {
            navigationController?.navigationBar.lt_setBackgroundColor(color.colorWithAlphaComponent(0))
            self.title = ""
        }
    }
}
