//
//  PostListTableViewController.swift
//  Traveller
//
//  Created by MandyXue on 16/6/6.
//  Copyright © 2016年 AppleClub. All rights reserved.
//

import UIKit
import MapKit
import UITableView_FDTemplateLayoutCell

class PostListTableViewController: UITableViewController {
    
    var type: Int = 0 // 0: all following posts,1: my posts, false: my comments
    var comments: [CommentModel] = []
    var posts: [PostModel] = []
    var filteredPosts: [PostModel] = []
    
    let searchController = UISearchController(searchResultsController: nil)
    
    // MARK: - BaseViewController
    
    static func loadFromStoryboard() -> UIViewController {
        let controller = UIStoryboard.traveller_postListStoryboard().instantiateViewControllerWithIdentifier(self.traveller_className())
        return controller
    }
    
    // MARK: - Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        switch type {
        case 1:
            navigationItem.title = "Posts"
        case 2:
            navigationItem.title = "Comments"
        default:
            self.tabBarController?.navigationItem.title = "Discover"
        }
        
        setInfo()
        
        if type == 0 {
            searchController.searchBar.delegate = self
            searchController.dimsBackgroundDuringPresentation = false
            definesPresentationContext = true
            tableView.tableHeaderView = searchController.searchBar
            // set ui
            searchController.searchBar.barTintColor = UIColor.customGreenColor()
            searchController.searchBar.tintColor = UIColor.whiteColor()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Helper
    
    func setInfo() {
        var i = 0
        while i < 20 {
            comments.append(CommentModel(user: UserModel(username: "user\(i)", avatar: UIImage(named: "avatar")!, place: "place...."), comment: "CommentsComments\(i)", time: NSDate(timeIntervalSinceNow: 0)))
            i += 1
        }
        
        i = 0
        while i < 20 {
            posts.append(PostModel(place: "Shanghai\(i)", detail: "DetailDetailDetailDetailDetailDetailDetailDetail\(i)", location: CLLocationCoordinate2D(latitude: 31.2855741398, longitude: 121.2147781261), address: "Shanghaishanghai\(i)", creator: UserModel(username: "user\(i)", avatar: UIImage(named: "avatar")!, place: "place....")))
            i += 1
        }
    }
    
}

// MARK: - Search bar setting

extension PostListTableViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        if searchBar.text != nil {
            filterContentForSearchText(searchBar.text!)
        } else {
            let alert = UIAlertController(title: "Empty Search", message: "Search text shouldn't be empty.", preferredStyle: .Alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .Cancel, handler: nil))
            presentViewController(alert, animated: true, completion: nil)
        }
    }
    
    func filterContentForSearchText(searchText: String) {
        // TODO: search filter
        print("filter")
        tableView.reloadData()
    }
}

// MARK: - Table view data source

extension PostListTableViewController {
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return posts.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if type == 0 || type == 1 {
            let cell = tableView.dequeueReusableCellWithIdentifier("PostCell", forIndexPath: indexPath) as! PostTableViewCell
            configurePostCell(cell, indexPath: indexPath)
            return cell
        } else {
            let cell = tableView.dequeueReusableCellWithIdentifier("CommentCell", forIndexPath: indexPath) as! CommentTableViewCell
            configureCommentCell(cell, indexPath: indexPath)
            return cell
        }
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if type == 0 || type == 1  {
            return tableView.fd_heightForCellWithIdentifier("PostCell", configuration: { (cell) in
                if let commentCell = cell as? PostTableViewCell {
                    self.configurePostCell(commentCell, indexPath: indexPath)
                }
            })
        } else {
            return tableView.fd_heightForCellWithIdentifier("CommentCell", configuration: { (cell) in
                if let commentCell = cell as? CommentTableViewCell {
                    self.configureCommentCell(commentCell, indexPath: indexPath)
                }
            })
        }
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let vc = PostDetailTableViewController.loadFromStoryboard() as! PostDetailTableViewController
        vc.post = posts[indexPath.row]
        navigationController?.pushViewController(vc, animated: true)
    }
    
    // helper
    
    func configurePostCell(cell: PostTableViewCell, indexPath: NSIndexPath) {
        if posts[indexPath.row].images.count > 0 {
            cell.postImageView.image = posts[indexPath.row].images[0]
        } else {
            cell.postImageView.image = UIImage(named: "avatar")
        }
        cell.nameLabel.text = posts[indexPath.row].place
        cell.descriptionLabel.text = posts[indexPath.row].detail
        cell.locationLabel.text = posts[indexPath.row].address
    }
    
    func configureCommentCell(cell: CommentTableViewCell, indexPath: NSIndexPath) {
        if posts[indexPath.row].images.count > 0 {
            cell.postImageView.image = posts[indexPath.row].images[0]
        } else {
            cell.postImageView.image = UIImage(named: "avatar")
        }
        cell.nameLabel.text = posts[indexPath.row].place
        cell.locationLabel.text = posts[indexPath.row].address
        cell.usernameLabel.text = comments[indexPath.row].user.username
        cell.commentLabel.text = comments[indexPath.row].comment
        cell.timeLabel.text = NSDateFormatter.stringFromDate(comments[indexPath.row].time)
    }
    
}