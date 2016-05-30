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

class PostDetailTableViewController: UITableViewController, UIActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIAlertViewDelegate, SDCycleScrollViewDelegate {
    
    let NAVBAR_CHANGE_POINT: CGFloat = 50
    
    var post = PostModel()
    var comments: [CommentModel] = []
    var imageURLs: [String] = []
    var scrollViewWidth: CGFloat = 0
    
    // TODO: 添加图片放大展示效果
//    @IBOutlet weak var refreshHeader: MJRefreshNormalHeader!
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
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Refresh", style: .Plain, target: self, action: #selector(refresh))
        
        prepareData()
        if post.place != nil {
            setUpUI()
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
    
    func refresh() {
        self.tableView.reloadData()
        print("refresh")
    }
    
    func setUpUI() {
        addButton.layer.borderWidth = 2
        addButton.layer.cornerRadius = 5
        addButton.layer.borderColor = UIColor(red: 255/255, green: 211/255, blue: 0/155, alpha: 0.8).CGColor
        titleLabel.text = post.place
        // scroll view
        self.scrollView.showPageControl = false
        self.scrollView.placeholderImage = UIImage(named: "testPlace")
        self.scrollView.delegate = self
        self.scrollView.imageURLStringsGroup = self.imageURLs
    }
    
    func prepareData() {
        // TODO: 假数据，后续添加接口
        var i = 0
        while i < 20 {
            comments.append(CommentModel(user: UserModel(username: "Mandy Xue", avatar: UIImage(named: "avatar")!, place: "Yang Pu District, Shanghai"), comment: "Great place, I want to go.", time: NSDate(timeIntervalSinceNow: 0)))
            i += 1
        }
        // scroll view images
        imageURLs.append("http://www.khxing.com/files/2014-9/20140915132828105078.jpg")
        imageURLs.append("http://file21.mafengwo.net/M00/B3/05/wKgB21AXIVfkK_6eABs2chtBOg409.groupinfo.w600.jpeg")
        imageURLs.append("http://www.oruchina.com/files/2014-9/f20140930095244175411.jpg")
        imageURLs.append("http://youimg1.c-ctrip.com/target/tg/920/427/911/5c52e590249244499dbeede58832e865_jupiter.jpg")
        scrollViewWidth = self.scrollView.frame.size.width
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
        let color = UIColor.customGreenColor()
        let offsetY = scrollView.contentOffset.y
        // set navigation bar
        if offsetY > NAVBAR_CHANGE_POINT {
            let alpha = min(1, 1-((NAVBAR_CHANGE_POINT+64-offsetY)/64))
            
            navigationController?.navigationBar.lt_setBackgroundColor(color.colorWithAlphaComponent(alpha))
            self.title = post.place
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
        if indexPath.row == 1 {
            if let detailView = UserDetailTableViewController.loadFromStoryboard() as? UserDetailTableViewController {
                // TODO: 接上接口以后要改这个参数
                detailView.user = post.creator
                print(post.creator)
                self.navigationController?.pushViewController(detailView, animated: true)
            } else {
                print("something went wrong...")
            }
        }
    }
}

// MARK: - ImagePickerController Delegate and Helpers

extension PostDetailTableViewController {
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        let imageToSave = info[UIImagePickerControllerEditedImage]
        if let image = imageToSave as? UIImage {
            post.addImage(image)
        }
        print(post.images)
        
        // TODO: 连后端接口上传图片
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    // MARK: - ActionSheet Delegate
    
    func actionSheet(actionSheet: UIActionSheet, clickedButtonAtIndex buttonIndex: Int) {
        switch(buttonIndex) {
        case 1:
            print("拍照")
            takePhotoByCamera()
        case 2:
            print("从相册选取")
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
                                    message: "我们不能访问您的相机📷",
                                    delegate: nil,
                                    cancelButtonTitle: "Ok")
            alert.show()
            
       }
    }
    
    func getImagePickerActionSheet() -> UIActionSheet {
        let actionSheet = UIActionSheet(title: "选取照片", delegate: self, cancelButtonTitle: "取消", destructiveButtonTitle: nil, otherButtonTitles: "拍照", "从相册选取")
        actionSheet.actionSheetStyle = .BlackOpaque
        return actionSheet
    }
}
