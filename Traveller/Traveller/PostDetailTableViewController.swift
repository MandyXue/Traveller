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
import SDCycleScrollView
import MJRefresh
import UITableView_FDTemplateLayoutCell
import PromiseKit
import PKHUD

class PostDetailTableViewController: UITableViewController, UIActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIAlertViewDelegate, SDCycleScrollViewDelegate {
    
    let NAVBAR_CHANGE_POINT: CGFloat = 50
    
    var post:PostBean?
    var postId: String?
    var comments: [CommentBean] = []
    var imageURLs: [String] = []
    var scrollViewWidth: CGFloat = 0
    
    let postModel = PostModel()
    let userModel = UserModel()
    let commentModel = CommentModel()
    
    // TODO: 添加图片放大展示效果
    @IBOutlet weak var scrollView: SDCycleScrollView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var addButton: UIButton!
    @IBAction func addImage(sender: AnyObject) {
        let actionSheet = getImagePickerActionSheet()
        actionSheet.showInView(self.view)
    }
    
    // MARK: - BaseViewController
    
    static func loadFromStoryboard() -> UIViewController {
        let controller = UIStoryboard.traveller_postDetailStoryboard().instantiateViewControllerWithIdentifier(self.traveller_className())
        return controller
    }
    
    // MARK: - Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        self.navigationController?.navigationBar.lt_setBackgroundColor(UIColor.clearColor())
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Comment", style: .Plain, target: self, action: #selector(addComment))
        
        if let id = postId {
            HUD.show(.LabeledProgress(title: nil, subtitle: "Loading....."))
            postModel.getPostDetail(byPostID: id)
                .then { post -> Promise<UserBean> in
                    self.post = post
                    self.imageURLs = post.imagesURL
                    print("images")
                    print(self.imageURLs)
                    return self.userModel.getUserDetail(byUserID: self.post!.creatorID)
                }.then { user -> Promise<[CommentBean]> in
                    self.post!.creator = user
                    return self.commentModel.getComments(byPostID: self.post!.id!)
                }.then { comments -> () in
                    self.comments = comments
                    HUD.flash(.Success)
                    self.tableView.reloadData()
                    self.setUpUI()
                }.error { err in
                    self.handleErrorMsg(err)
                }
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
    
    func addComment() {
        let alert = UIAlertController(title: "Add a comment", message: nil, preferredStyle: .Alert)
        alert.addTextFieldWithConfigurationHandler { (textField) in
            textField.placeholder = "Your comment..."
        }
        alert.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Submit", style: .Default, handler: { (action) in
            let comment = alert.textFields![0].text
            if comment != "" {
                let newComment = CommentBean(creatorID: self.commentModel.userID, content: comment!, postID: self.postId!)
                newComment.user = UserBean(id: self.commentModel.userID, username: self.commentModel.name, avatar: nil)
                self.commentModel.addNewComment(newComment)
                    .then { isSuccess -> () in
                        self.comments.append(newComment)
                        HUD.flash(.Success, delay: 0) { finished in
                            self.tableView.reloadData()
                        }
                    }.error { err in
                        self.handleErrorMsg(err)
                }
            } else {
                HUD.flash(.LabeledError(title: "Error", subtitle: "Comment cannot be empty"))
            }
        }))
        presentViewController(alert, animated: true, completion: nil)
    }
    
    func setUpUI() {
        addButton.layer.borderWidth = 2
        addButton.layer.cornerRadius = 5
        addButton.layer.borderColor = UIColor(red: 255/255, green: 211/255, blue: 0/155, alpha: 0.8).CGColor
        titleLabel.text = post!.title
        // scroll view
        self.scrollView.showPageControl = false
        self.scrollView.placeholderImage = UIImage(named: "testPlace")
        self.scrollView.delegate = self
        self.scrollView.imageURLStringsGroup = self.imageURLs
        // footer view
//        let view = UIView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
//        view.backgroundColor = UIColor.blackColor()
//        self.tableView.tableFooterView = view
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
        return 4+comments.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            let cell = tableView.dequeueReusableCellWithIdentifier("DetailCell", forIndexPath: indexPath) as! PostDetailTableViewCell
            configureDetailCell(cell, indexPath: indexPath)
            return cell
        case 1:
            let cell = tableView.dequeueReusableCellWithIdentifier("CreatorTagCell", forIndexPath: indexPath)
            return cell
        case 3:
            let cell = tableView.dequeueReusableCellWithIdentifier("CommentsTagCell", forIndexPath: indexPath)
            return cell
        case 2:
            let cell = tableView.dequeueReusableCellWithIdentifier("CreatorCell", forIndexPath: indexPath) as! PostCreatorTableViewCell
            cell.creatorImageView.image = post?.creator?.avatar
            cell.creatorNameLabel.text = post?.creator?.username
            cell.creatorPlaceLabel.text = post?.creator?.place
            return cell
        default:
            let cell = tableView.dequeueReusableCellWithIdentifier("CommentCell", forIndexPath: indexPath) as! PostCommentTableViewCell
            configureCommentCell(cell, indexPath: indexPath)
            return cell
        }
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        switch indexPath.row {
        case 0:
            return tableView.fd_heightForCellWithIdentifier("DetailCell", configuration: { (cell) in
                if let detailCell = cell as? PostDetailTableViewCell {
                    self.configureDetailCell(detailCell, indexPath: indexPath)
                }
            })
        case 1:
            return 25.0
        case 2:
            return 80.0
        case 3:
            return 25.0
        default:
            return tableView.fd_heightForCellWithIdentifier("CommentCell", configuration: { (cell) in
                if let commentCell = cell as? PostCommentTableViewCell {
                    self.configureCommentCell(commentCell, indexPath: indexPath)
                }
            })
        }
    }

    override func scrollViewDidScroll(scrollView: UIScrollView) {
        let color = UIColor.customGreenColor()
        let offsetY = scrollView.contentOffset.y
        // set navigation bar
        if offsetY > NAVBAR_CHANGE_POINT {
            let alpha = min(1, 1-((NAVBAR_CHANGE_POINT+64-offsetY)/64))
            
            navigationController?.navigationBar.lt_setBackgroundColor(color.colorWithAlphaComponent(alpha))
            self.title = post!.title
        } else {
            navigationController?.navigationBar.lt_setBackgroundColor(color.colorWithAlphaComponent(0))
            self.title = ""
        }
        
        // set header view
        if offsetY < -64.0 {
            let heightAfter = 170+abs(offsetY)
            self.scrollView.autoScroll = false
            self.scrollView.frame = CGRect(x: 0, y: offsetY, width: self.view.frame.size.width, height: heightAfter)
        } else {
            self.scrollView.autoScroll = true
        }
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let cell = tableView.cellForRowAtIndexPath(indexPath)
        cell?.setSelected(false, animated: false)
        if indexPath.row == 2 {
            if let detailView = UserDetailTableViewController.loadFromStoryboard() as? UserDetailTableViewController {
                // TODO: 接上接口以后要改这个参数
                detailView.user = post!.creator!
                print(post!.creator)
                self.navigationController?.pushViewController(detailView, animated: true)
            } else {
                print("something went wrong...")
            }
        }
    }
    
    // helper
    
    func configureDetailCell(cell: PostDetailTableViewCell, indexPath: NSIndexPath) {
        cell.locationLabel.text = post?.address
        cell.descriptionLabel.text = post?.summary
    }
    
    func configureCommentCell(cell: PostCommentTableViewCell, indexPath: NSIndexPath) {
        cell.commentLabel.text = comments[indexPath.row-4].content
        cell.commentImageView.image = UIImage(named: "avatar")// user!.avatar
        cell.commentNameLabel.text = comments[indexPath.row-4].user!.username
        cell.commentTimeLabel.text = DataBean().dateFormatter.stringFromDate(comments[indexPath.row-4].time)
    }
}

// MARK: - ImagePickerController Delegate and Helpers

extension PostDetailTableViewController {
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        let imageToSave = info[UIImagePickerControllerEditedImage]
        if let image = imageToSave as? UIImage {
            post!.addImage(image)
            postModel.getUpToken().then { uptoken -> [Promise<String>] in
                    return self.postModel.uploadImageToQiniu([image], uptoken: uptoken)
                }.then { urls -> () in
                    // TODO: 为post添加一张图片
                }.error { err in
                    self.handleErrorMsg(err)
            }
        }
        print(post!.images)
        
        // TODO: 连后端接口上传图片
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    // MARK: - ActionSheet Delegate
    
    func actionSheet(actionSheet: UIActionSheet, clickedButtonAtIndex buttonIndex: Int) {
        switch(buttonIndex) {
        case 1:
            print("Take a photo now")
            // TODO: 这里的拍照上传好像有点问题
            takePhotoByCamera()
        case 2:
            print("Choose photo from album")
            choosePhotoFromAlbum()
        default: break
        }
    }
    
    // MARK: - Helper
    // 从相册选取照片
    func choosePhotoFromAlbum() {
        let ipc = UIImagePickerController()
        ipc.delegate = self
        ipc.sourceType = .PhotoLibrary
        ipc.allowsEditing = true
        presentViewController(ipc, animated: true, completion: nil)
    }
    
    // 拍照
    func takePhotoByCamera() {
        if UIImagePickerController.isSourceTypeAvailable(.Camera) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = .Camera;
            imagePicker.allowsEditing = false
            presentViewController(imagePicker, animated: true, completion: nil)
        }
        else {
            let alert = UIAlertView(title: "Sorry",
                                    message: "We cannot get your camera📷",
                                    delegate: nil,
                                    cancelButtonTitle: "Ok")
            alert.show()
       }
    }
    
    func getImagePickerActionSheet() -> UIActionSheet {
        let actionSheet = UIActionSheet(title: "Upload a photo", delegate: self, cancelButtonTitle: "Cancel", destructiveButtonTitle: nil, otherButtonTitles: "Take a photo now", "Choose photo from album")
        actionSheet.actionSheetStyle = .BlackOpaque
        return actionSheet
    }
}
