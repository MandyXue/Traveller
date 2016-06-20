//
//  NewDayDetailTableViewController.swift
//  Traveller
//
//  Created by MandyXue on 16/6/20.
//  Copyright © 2016年 AppleClub. All rights reserved.
//

import UIKit
import MapKit

protocol NewDayDetailDelegate {
    func newDayDetail(dayDetail: DayDetailBean)
}

class NewDayDetailTableViewController: UITableViewController, SelectLocationDelegate, SelectTypeDelegate{

    @IBOutlet weak var startDateCell: DatePickerCell!
    @IBOutlet weak var endDateCell: DatePickerCell!
    @IBOutlet weak var typeCell: UITableViewCell!
    @IBOutlet weak var locationCell: UITableViewCell!
    
    var newDayDetailDelegate: NewDayDetailDelegate?
    var selectedLocation: MKMapItem?
    
    var newDayDetail: DayDetailBean?
    
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
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Done", style: .Done, target: self, action: #selector(newDayDetailSelector))
        
        // init day detail
        // TODO: 改变默认值: planID, postID
        self.newDayDetail = DayDetailBean(planID: "", postID: "", startTime: NSDate(timeIntervalSinceNow: 0), endTime: NSDate(timeIntervalSinceNow: 0), place: "", latitude: 1, longitude: 1, type: -1)
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
        if let name = self.selectedLocation!.name {
            newDayDetail?.place = name
        }
        if let coordinate = self.selectedLocation?.placemark.location?.coordinate {
            newDayDetail?.coordinate = coordinate
        }
    }
    
    // MARK: - Select type delegate
    
    func selectType(type: Int) {
        self.newDayDetail?.type = type
        switch type {
        case 0:
            typeCell.detailTextLabel?.text = "Catering"
        case 1:
            typeCell.detailTextLabel?.text = "Accommodation"
        default:
            typeCell.detailTextLabel?.text = "Scenery Spot"
        }
    }
    
    // MARK: - Helper
    
    func newDayDetailSelector() {
        if self.newDayDetail?.place != "" {
            if self.newDayDetail?.type != -1 {
                self.newDayDetail?.startTime = startDateCell.date
                self.newDayDetail?.endTime = endDateCell.date
                // 用delegate把值传回上一页面
                newDayDetailDelegate?.newDayDetail(self.newDayDetail!)
                self.navigationController?.popViewControllerAnimated(true)
            } else {
                let alert = UIAlertController(title: "Error", message: "Type cannot be empty, please choose one.", preferredStyle: .Alert)
                alert.addAction(UIAlertAction(title: "OK", style: .Cancel, handler: nil))
                presentViewController(alert, animated: true, completion: nil)
            }
        } else {
            let alert = UIAlertController(title: "Error", message: "Location cannot be empty, please choose one.", preferredStyle: .Alert)
            alert.addAction(UIAlertAction(title: "OK", style: .Cancel, handler: nil))
            presentViewController(alert, animated: true, completion: nil)
        }
    }
    
    // MARK: - Navigation
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "SelectTypeSegue" {
            if let detailViewController = segue.destinationViewController as? SelectTypeTableViewController {
                detailViewController.selectTypeDelegate = self
            }
        }
    }
}
