//
//  SelectTypeTableViewController.swift
//  Traveller
//
//  Created by MandyXue on 16/6/19.
//  Copyright © 2016年 AppleClub. All rights reserved.
//

import UIKit

protocol SelectTypeDelegate {
    func selectType(type: Int)
}

class SelectTypeTableViewController: UITableViewController {
    
    var selectedIndex: Int = 0
    var selectTypeDelegate: SelectTypeDelegate?

    @IBOutlet weak var cateringCell: UITableViewCell!
    @IBOutlet weak var accommodationCell: UITableViewCell!
    @IBOutlet weak var scenerySpotCell: UITableViewCell!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // set navigation item
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Done", style: .Done, target: self, action: #selector(selectType))
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view delegate
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        selectedIndex = indexPath.row
        switch indexPath.row {
        case 0:
            cateringCell.accessoryType = .Checkmark
            accommodationCell.accessoryType = .None
            scenerySpotCell.accessoryType = .None
            cateringCell.selected = false
        case 1:
            cateringCell.accessoryType = .None
            accommodationCell.accessoryType = .Checkmark
            scenerySpotCell.accessoryType = .None
            accommodationCell.selected = false
        default:
            cateringCell.accessoryType = .None
            accommodationCell.accessoryType = .None
            scenerySpotCell.accessoryType = .Checkmark
            scenerySpotCell.selected = false
        }
    }
    
    override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 12))
        view.backgroundColor = UIColor.clearColor()
        return view
    }
    
    // MARK: - Helper
    
    func selectType() {
        selectTypeDelegate?.selectType(selectedIndex)
        self.navigationController?.popViewControllerAnimated(true)
    }
}
