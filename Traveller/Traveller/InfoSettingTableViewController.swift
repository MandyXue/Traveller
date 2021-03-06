//
//  InfoSettingTableViewController.swift
//  Traveller
//
//  Created by MandyXue on 16/6/5.
//  Copyright © 2016年 AppleClub. All rights reserved.
//

import UIKit
import PKHUD
import Regex

protocol ModifyUserInfoDelegate {
    func setNewUserInfo(newInfo: UserBean)
}

class InfoSettingTableViewController: UITableViewController, UIActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIAlertViewDelegate {
    
    var user:UserBean?
    
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var genderLabel: UILabel!
    @IBOutlet weak var summaryLabel: UILabel!
    @IBOutlet weak var homepageLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var registerDateLabel: UILabel!
    
    let userModel = UserModel()
    var modifyInfoDelegate:ModifyUserInfoDelegate?
    
    // MARK: - BaseViewController
    
    static func loadFromStoryboard() -> UIViewController {
        let controller = UIStoryboard.traveller_meStoryboard().instantiateViewControllerWithIdentifier(self.traveller_className())
        return controller
    }
    
    // MARK: - Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()

        setInfo()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Helper
    
    func setInfo() {
        avatarImageView.image = (user!.avatar == nil) ? UIImage(named: "avatar"): user!.avatar
        usernameLabel.text = user!.username
        locationLabel.text = (user!.place == nil || user!.place! == "") ? "not setted": user!.place
        genderLabel.text = user!.gender! ? "male": "female"
        summaryLabel.text = (user!.summary == nil || user!.summary! == "") ? "not setted": user!.summary
        homepageLabel.text = (user!.homepage == nil || user!.homepage! == "") ? "not setted": user!.homepage
        emailLabel.text = user!.email
        registerDateLabel.text = NSDateFormatter.stringFromDate(user!.registerDate!)
    }
}

// MARK: - Table view delegate

extension InfoSettingTableViewController {
    
    override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 12))
        view.backgroundColor = UIColor.clearColor()
        return view
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let cell = tableView.cellForRowAtIndexPath(indexPath)
        if indexPath.section == 0 && indexPath.row == 0 {
            let actionSheet = getImagePickerActionSheet()
            actionSheet.showInView(self.view)
        } else if indexPath.section == 2 || (indexPath.section == 0 && indexPath.row == 1) {
            let alert = UIAlertController(title: nil, message: (cell?.textLabel?.text)!+" cannot be modified.", preferredStyle: .Alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .Cancel, handler: nil))
            presentViewController(alert, animated: true, completion: nil)
        } else {
            cell?.setSelected(false, animated: false)
            let alert = UIAlertController(title: "Modify "+(cell?.textLabel?.text)!, message: nil, preferredStyle: .Alert)
            alert.addTextFieldWithConfigurationHandler({ (textField) in
                textField.text = cell?.detailTextLabel?.text
            })
            alert.addAction(UIAlertAction(title: "No", style: .Cancel, handler: nil))
            alert.addAction(UIAlertAction(title: "Yes", style: .Default, handler: { (action) in
                // TODO: upload
                let newText = alert.textFields![0].text
                cell?.detailTextLabel?.text = newText
                
                // 给user赋值
                switch cell!.textLabel!.text! {
                    case "Location":
                    self.user!.place = newText
                    case "Gender":
                        if newText!.grep("female").boolValue {
                            self.user!.gender = false
                        } else {
                            self.user!.gender = true
                        }
                    case "Summary":
                    self.user!.summary = newText
                    case "Homepage":
                    self.user!.homepage = newText
                default:
                    print()
                }
                
                self.user!.id = self.userModel.userID
                self.userModel.modifyUserInfo(self.user!)
                    .then { isSuccess -> () in
                        if isSuccess {
                            // 更新成功，给用户提示
                            print("update uesr info successful")
                            self.modifyInfoDelegate?.setNewUserInfo(self.user!)
                        }
                    }.error { err in
                
                }
                
            }))
            presentViewController(alert, animated: true, completion: nil)
        }
        cell?.selected = false
    }
}

// MARK: - ImagePickerController Delegate and Helpers

extension InfoSettingTableViewController {
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        let imageToSave = info[UIImagePickerControllerEditedImage]
        if let image = imageToSave as? UIImage {
            avatarImageView.image = image
        }
        
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