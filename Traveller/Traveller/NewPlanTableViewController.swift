//
//  NewPlanTableViewController.swift
//  Traveller
//
//  Created by MandyXue on 16/6/18.
//  Copyright © 2016年 AppleClub. All rights reserved.
//

import UIKit

protocol NewPlanDelegate {
    func newPlan(plan: [String:String])
}

class NewPlanTableViewController: UITableViewController {
    
    @IBOutlet weak var startDateCell: DatePickerCell!
    @IBOutlet weak var endDateCell: DatePickerCell!
    @IBOutlet weak var destinationCell: UITableViewCell!
    @IBOutlet weak var typeCell: UITableViewCell!
    @IBOutlet weak var locationCell: UITableViewCell!
    
    var newPlanDelegate: NewPlanDelegate?
    
    // MARK: - BaseViewController
    
    static func loadFromStoryboard() -> UIViewController {
        let controller = UIStoryboard.traveller_scheduleStoryboard().instantiateViewControllerWithIdentifier(self.traveller_className())
        return controller
    }
    
    // MARK: - Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // set date picker cell
        startDateCell.dateStyle = .NoStyle
        startDateCell.datePicker.datePickerMode = .Time
        startDateCell.leftLabel.text = "Start Time"
        
        endDateCell.dateStyle = .NoStyle
        endDateCell.datePicker.datePickerMode = .Time
        endDateCell.leftLabel.text = "End Time"
        
        // set navigation item
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Done", style: .Done, target: self, action: #selector(newPlan))
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
    }
    
    override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 12))
        view.backgroundColor = UIColor.clearColor()
        return view
    }
    
    // MARK: - Helper
    
    func newPlan() {
        let formatter = NSDateFormatter()
        formatter.dateStyle = .NoStyle
        formatter.timeStyle = .MediumStyle
        
        let starttime = startDateCell.rightLabel.text
        let endtime = endDateCell.rightLabel.text
        let name = destinationCell.detailTextLabel?.text
        let type = typeCell.detailTextLabel?.text
        
        // TODO: location
        if starttime != nil && endtime != nil && name != nil && type != nil {
            newPlanDelegate?.newPlan(["name": name!, "type": type!, "time": starttime! + " to " + endtime!])
            self.navigationController?.popViewControllerAnimated(true)
        }
    }
}
