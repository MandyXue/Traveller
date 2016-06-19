//
//  NewPlanTableViewController.swift
//  Traveller
//
//  Created by MandyXue on 16/6/18.
//  Copyright © 2016年 AppleClub. All rights reserved.
//

import UIKit
import MapKit

protocol NewPlanDelegate {
    func newPlan(plan: [String:String])
}

class NewPlanTableViewController: UITableViewController, SelectLocationDelegate {
    
    @IBOutlet weak var startDateCell: DatePickerCell!
    @IBOutlet weak var endDateCell: DatePickerCell!
    @IBOutlet weak var typeCell: UITableViewCell!
    @IBOutlet weak var locationCell: UITableViewCell!
    
    var newPlanDelegate: NewPlanDelegate?
    var selectedLocation: MKMapItem?
    
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
        
        if indexPath.row == 3 {
            let vc = ChooseLocationViewController.loadFromStoryboard() as! ChooseLocationViewController
            vc.selectLocationDelegate = self
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 12))
        view.backgroundColor = UIColor.clearColor()
        return view
    }
    
    // MARK: - Select location delegate
    
    func selectLocation(selectedLocation: MKMapItem) {
        print("selected location:\(selectedLocation.name)")
        self.selectedLocation = selectedLocation
        locationCell.detailTextLabel?.text = self.selectedLocation!.name
    }
    
    // MARK: - Helper
    
    func newPlan() {
        let formatter = NSDateFormatter()
        formatter.dateStyle = .NoStyle
        formatter.timeStyle = .MediumStyle
        
        let starttime = startDateCell.rightLabel.text
        let endtime = endDateCell.rightLabel.text
        let name = locationCell.detailTextLabel?.text
        let type = typeCell.detailTextLabel?.text
        
        if starttime != nil && endtime != nil && name != nil && type != nil {
            newPlanDelegate?.newPlan(["name": name!, "type": type!, "time": starttime! + " to " + endtime!])
            self.navigationController?.popViewControllerAnimated(true)
        }
    }
}
