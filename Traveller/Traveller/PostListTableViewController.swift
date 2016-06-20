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
    
    var type: Int = 0 // 0: all following posts,1: my posts, 2: my comments
    var comments: [CommentBean] = []
    var posts: [PostBean] = []
    var filteredPosts: [PostBean] = []
    
    let postModel = PostModel()
    let commentModel = CommentModel()
    
    let searchController = UISearchController(searchResultsController: nil)
    
    // MARK: - BaseViewController
    
    static func loadFromStoryboard() -> UIViewController {
        let controller = UIStoryboard.traveller_postListStoryboard().instantiateViewControllerWithIdentifier(self.traveller_className())
        return controller
    }
    
    // MARK: - Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 从NSUserDefault获取user ID
        if type == 1 {
            navigationItem.title = "Posts"
            // 获取用户的post
            postModel.getPosts(byUserID: postModel.userID)
                .then { posts -> () in
                    posts.forEach { print($0.id) }
                }.error { err in
                    print("get user posts list error")
                    print(err)
            }
            
            
        } else if type == 2 {
            navigationItem.title = "Comments"
            // 获取用户的评论
            commentModel.getComments(byUserID: postModel.userID)
                .then { comments -> () in
                    comments.forEach { print($0.postID) }
                }.error { err in
                    print("get user comments list error")
                    print(err)
            }
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
    
    override func viewWillAppear(animated: Bool) {
        if type == 0 {
            // set up navigation bar
            self.tabBarController?.navigationItem.title = "Discover"
            self.tabBarController?.navigationItem.rightBarButtonItem = nil
            self.tabBarController?.navigationItem.leftBarButtonItem = nil
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
            let newComment = CommentBean(commentId: "testId", creatorId: "testId", avatarURL: nil, content: "Great place, I want to go gogogogogogogogogogogogogogo....", postID: "test", createDate: "2016-06-18")
            newComment.user = UserBean(username: "Mandy Xue", avatar: UIImage(named: "avatar")!, place: "Yang Pu District, Shanghai")
            comments.append(newComment)
            i += 1
        }
        
        i = 0
        while i < 20 {
            posts.append(PostBean(place: "Shanghai\(i)", detail: "DetailDetailDetailDetailDetailDetailDetailDetail\(i)", location: CLLocationCoordinate2D(latitude: 31.2855741398, longitude: 121.2147781261), address: "Shanghaishanghai\(i)", creator: UserBean(username: "user\(i)", avatar: UIImage(named: "avatar")!, place: "place....")))
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
        cell.nameLabel.text = posts[indexPath.row].title
        cell.descriptionLabel.text = posts[indexPath.row].summary
        cell.locationLabel.text = posts[indexPath.row].address
    }
    
    func configureCommentCell(cell: CommentTableViewCell, indexPath: NSIndexPath) {
        if posts[indexPath.row].images.count > 0 {
            cell.postImageView.image = posts[indexPath.row].images[0]
        } else {
            cell.postImageView.image = UIImage(named: "avatar")
        }
        cell.nameLabel.text = posts[indexPath.row].title
        cell.locationLabel.text = posts[indexPath.row].address
        cell.usernameLabel.text = comments[indexPath.row].user!.username
        cell.commentLabel.text = comments[indexPath.row].content
        cell.timeLabel.text = "TODO"//NSDateFormatter.stringFromDate(comments[indexPath.row].time)
    }
    
}
