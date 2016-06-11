//
//  NewPostTableViewController.swift
//  Traveller
//
//  Created by MandyXue on 16/6/11.
//  Copyright © 2016年 AppleClub. All rights reserved.
//

import UIKit

class NewPostTableViewController: UITableViewController, UICollectionViewDataSource, UICollectionViewDelegate, UITextFieldDelegate, UITextViewDelegate, UIActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIAlertViewDelegate {
    
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    var images: [UIImage] = []
    
    // MARK: - BaseViewController
    
    static func loadFromStoryboard() -> UIViewController {
        let controller = UIStoryboard.traveller_newPostStoryboard().instantiateViewControllerWithIdentifier(self.traveller_className())
        let navigationController: UINavigationController = UINavigationController(rootViewController: controller)
        return navigationController
    }
    
    // MARK: - Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // navigation items
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .Plain, target: self, action: #selector(cancel))
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Send", style: .Plain, target: self, action: #selector(send))
        // collection view delegate & data source
        collectionView.delegate = self
        collectionView.dataSource = self
        // textview delegate
        textView.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view delegate
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        switch indexPath.row {
        case 0:
            return 143 + collectionView.collectionViewLayout.collectionViewContentSize().height
        default:
            return 46
        }
    }
    
    override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 12))
        view.backgroundColor = UIColor.clearColor()
        return view
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.row == 1 {
            
        }
    }
    
    // MARK: - TextView Delegate
    
    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        if (text == "\n") {
            textView.resignFirstResponder()
            return false
        }
        return true
    }
    
    func textViewDidBeginEditing(textView: UITextView) {
        if (textView.text == "Introduction to your post...") {
            textView.text = ""
            textView.textColor = UIColor.blackColor()
        }
        textView.becomeFirstResponder()
    }
    
    func textViewDidEndEditing(textView: UITextView) {
        if (textView.text == "") {
            textView.text = "Introduction to your post..."
            textView.textColor = UIColor.lightGrayColor()
        }
        textView.resignFirstResponder()
    }
    
    // MARK: - Collection View Data Source
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("ImageCell", forIndexPath: indexPath) as! PostImageCollectionViewCell
        if indexPath.row == images.count {
            cell.postImage.image = UIImage(named: "addImage")
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(addImage))
            cell.postImage.addGestureRecognizer(tapGesture)
            cell.postImage.userInteractionEnabled = true
            return cell
        } else {
            cell.postImage.image = images[indexPath.row]
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(watchImage))
            cell.postImage.addGestureRecognizer(tapGesture)
            cell.postImage.userInteractionEnabled = true
            return cell
        }
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count + 1
    }
    
    // MARK: - ImagePickerController Delegate
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        let imageToSave = info[UIImagePickerControllerEditedImage]
        images.append(imageToSave as! UIImage)
        collectionView.reloadData()
        tableView.reloadData()
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
    
    func cancel() {
        let alert = UIAlertController(title: nil, message: "Are you sure to exit?", preferredStyle: .Alert)
        alert.addAction(UIAlertAction(title: "Yes", style: .Cancel, handler: { (action: UIAlertAction) in
            self.dismissViewControllerAnimated(true, completion: nil)
        }))
        alert.addAction(UIAlertAction(title: "No", style: .Default, handler: nil))
        presentViewController(alert, animated: true, completion: nil)
    }
    
    func send() {
        dismissViewControllerAnimated(true) { 
            // TODO: send
            print("send")
        }
    }
    
    func addImage() {
        print("add a picture")
        let actionSheet = getImagePickerActionSheet()
        actionSheet.showInView(self.view)
    }
    
    func watchImage() {
        print("watch")
        // TODO: 查看图片详情
    }
    
    func getImagePickerActionSheet() -> UIActionSheet {
        let actionSheet = UIActionSheet(title: "选取照片", delegate: self, cancelButtonTitle: "取消", destructiveButtonTitle: nil, otherButtonTitles: "拍照", "从相册选取")
        actionSheet.actionSheetStyle = .BlackOpaque
        return actionSheet
    }
    
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
        let ipc = UIImagePickerController()
        ipc.delegate = self
        ipc.sourceType = .Camera
        ipc.allowsEditing = true
        presentViewController(ipc, animated: true, completion: nil)
    }
    
}
