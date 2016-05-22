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
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var addButton: UIButton!
    
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

}

// MARK: - Table view setting

extension PostDetailTableViewController {
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 20
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            let cell = tableView.dequeueReusableCellWithIdentifier("DetailCell", forIndexPath: indexPath) as! PostDetailTableViewCell
            cell.locationLabel.text = "\(post.location)"
            cell.descriptionLabel.text = post.detail
            return cell
        case 1:
            let cell = tableView.dequeueReusableCellWithIdentifier("CreatorCell", forIndexPath: indexPath) as! PostCreatorTableViewCell
            return cell
        default:
            let cell = tableView.dequeueReusableCellWithIdentifier("CommentCell", forIndexPath: indexPath) as! PostCommentTableViewCell
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
