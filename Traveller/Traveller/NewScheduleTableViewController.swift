//
//  NewScheduleTableViewController.swift
//  Traveller
//
//  Created by MandyXue on 16/6/20.
//  Copyright © 2016年 AppleClub. All rights reserved.
//

import UIKit
import PKHUD

protocol NewScheduleDelegate {
    func newSchedule(schedule: ScheduleBean)
}

class NewScheduleTableViewController: UITableViewController {

    @IBOutlet weak var destinationCell: UITableViewCell!
    @IBOutlet weak var datePickerCell: DatePickerCell!
    
    var newScheduleDelegate: NewScheduleDelegate?
    var schedule: ScheduleBean?
    
    var order: Int = 0
    
    // MARK: - BaseViewController
    
    static func loadFromStoryboard() -> UIViewController {
        let controller = UIStoryboard.traveller_scheduleStoryboard().instantiateViewControllerWithIdentifier(self.traveller_className())
        return controller
    }
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // set date picker cell
        datePickerCell.timeStyle = .NoStyle
        datePickerCell.datePicker.datePickerMode = .Date
        datePickerCell.leftLabel.text = "Start Date"
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Done", style: .Done, target: self, action: #selector(newSchedule))
        // TODO: 修改creatorId的默认值，去掉scheduleID
        // TODO: imageURL
        schedule = ScheduleBean(scheduleID: "test", creatorId: "creator", destination: "", order: order, imageURL: nil, startDate: NSDate(timeIntervalSinceNow: 0))
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source and delegate
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        let cell = self.tableView(tableView, cellForRowAtIndexPath: indexPath)
        if cell.isKindOfClass(DatePickerCell) {
            return (cell as! DatePickerCell).datePickerHeight()
        }
        return super.tableView(tableView, heightForRowAtIndexPath: indexPath)
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let cell = self.tableView(tableView, cellForRowAtIndexPath: indexPath)
        if cell.isKindOfClass(DatePickerCell) {
            let datePickerTableViewCell = cell as! DatePickerCell
            
            datePickerTableViewCell.selectedInTableView(tableView)
            self.tableView.deselectRowAtIndexPath(indexPath, animated: true)
        }
        
        if indexPath.row == 0 {
            let alert = UIAlertController(title: "Add Schedule", message: "Enter your destination city or country:", preferredStyle: .Alert)
            alert.addTextFieldWithConfigurationHandler({ (textField) in
                textField.placeholder = "destination name..."
            })
            alert.addAction(UIAlertAction(title: "Submit", style: .Default, handler: { (action) in
                self.destinationCell.detailTextLabel?.text = alert.textFields![0].text
            }))
            alert.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: nil))
            presentViewController(alert, animated: true, completion: nil)
        }
    }
    
    override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 12))
        view.backgroundColor = UIColor.clearColor()
        return view
    }
    
    // MARK: - Helper
    
    func newSchedule() {
        if schedule != nil && schedule?.creatorId != "" {
            schedule?.startDate = datePickerCell.date
            if destinationCell.detailTextLabel?.text == "" || destinationCell.detailTextLabel?.text == nil || destinationCell.detailTextLabel?.text == "not selected" {
                HUD.flash(.LabeledError(title: "Error", subtitle: "Destination cannot be empty"), delay: 2.0)
            } else {
                schedule?.destination = (destinationCell.detailTextLabel?.text)!
                // 用delegate传回
                newScheduleDelegate?.newSchedule(schedule!)
                navigationController?.popViewControllerAnimated(true)
            }
        }
    }
}