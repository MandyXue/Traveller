//
//  TimelineTableViewController.swift
//  Traveller
//
//  Created by MandyXue on 16/5/21.
//  Copyright © 2016年 AppleClub. All rights reserved.
//

import UIKit

class ScheduleTableViewController: UITableViewController {
    
    var cities: [String] = []
    
    // MARK: - BaseViewController
    
    static func loadFromStoryboard() -> UIViewController {
        let controller = UIStoryboard.traveller_scheduleStoryboard().instantiateViewControllerWithIdentifier(self.traveller_className())
        return controller
    }
    
    // MARK: - Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()

        // delete selection between presentations
        self.clearsSelectionOnViewWillAppear = true
        
        prepareData()
        
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(longPressGestureRecognized))
        self.tableView.addGestureRecognizer(longPress)
    }
    
    override func viewWillAppear(animated: Bool) {
        // set up navigation bar
        self.tabBarController?.navigationItem.title = "Schedule"
        self.tabBarController?.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Add, target: self, action: #selector(addDestination))
        self.tabBarController?.navigationItem.leftBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return cities.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("DestinationCell", forIndexPath: indexPath) as! DestinationTableViewCell
        cell.destImageView?.image = UIImage(named: "testPlace")
        cell.destNameLabel.text = cities[indexPath.row]
        return cell
    }

    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            if indexPath.row < cities.count {
                cities.removeAtIndex(indexPath.row)
                tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Left)
            }
        }
    }
    
    // MARK: - Navigation
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "ScheduleDetailSegue" {
            if let detailViewController = segue.destinationViewController as? TimelineTableViewController {
                if let indexPath = tableView.indexPathForSelectedRow {
                    if let cell = tableView.cellForRowAtIndexPath(indexPath) as? DestinationTableViewCell {
                        // TODO: pass value
                        detailViewController.navigationItem.title = cell.destNameLabel.text
                        cell.setSelected(false, animated: false)
                    }
                }
            }
        }
    }
    
    // MARK: - Helper
    
    func prepareData() {
        cities.append("Shanghai, China")
        cities.append("Uppsala, Sweden")
        cities.append("Paris, France")
        cities.append("Guangzhou, China")
    }
    
    func addDestination() {
        // TODO: 进入地图选点, add destination
        print("add")
        cities.append("New")
        tableView.reloadData()
    }
    
    
    var snapshot: UIView? = nil
    var sourceIndexPath: NSIndexPath? = nil
    
    func longPressGestureRecognized(sender: AnyObject?) {
        if let longPress = sender as? UILongPressGestureRecognizer {
            let state = longPress.state
            
            let location = longPress.locationInView(self.tableView)
            let indexPath = self.tableView.indexPathForRowAtPoint(location)
                
                switch state {
                case .Began:
                    if indexPath != nil {
                        sourceIndexPath = indexPath
                        
                        let cell = tableView.cellForRowAtIndexPath(indexPath!)
                        
                        // take a snapshot of the selected row using helper method
                        snapshot = UIView.customSnapshotFromView(cell!)
                        
                        var center = cell!.center
                        snapshot!.center = center
                        snapshot!.alpha = 0.0
                        self.tableView.addSubview(snapshot!)
                        UIView.animateWithDuration(0.25, animations: {
                            center.y = location.y
                            self.snapshot!.center = center
                            self.snapshot!.transform = CGAffineTransformMakeScale(1.05, 1.05)
                            self.snapshot!.alpha = 0.98
                            cell!.alpha = 0.0
                            cell!.hidden = true
                        })
                    }
                    
                    break
                case .Changed:
                    var center = snapshot!.center
                    center.y = location.y
                    snapshot!.center = center
                    
                    // Is destination valid and is it different from source?
                    if indexPath != nil && !indexPath!.isEqual(sourceIndexPath) {
                        
                        // update data source
                        let temp = NSMutableArray(array: cities)
                        temp.exchangeObjectAtIndex(indexPath!.row, withObjectAtIndex: sourceIndexPath!.row)
                        self.cities = temp as AnyObject as! [String]
                        // TODO: 将cities存到远端
                        
                        // move the rows
                        self.tableView.moveRowAtIndexPath(sourceIndexPath!, toIndexPath: indexPath!)
                        
                        // update source with UI changes
                        sourceIndexPath = indexPath
                    }
                    break
                default:
                    let cell = self.tableView.cellForRowAtIndexPath(sourceIndexPath!)
                    cell!.alpha = 0.0
                    UIView.animateWithDuration(0.25, animations: {
                        self.snapshot!.center = cell!.center
                        self.snapshot!.transform = CGAffineTransformIdentity
                        self.snapshot!.alpha = 0.0
                        cell!.alpha = 1.0
                        }, completion: { (finished: Bool) in
                            cell!.hidden = false
                            self.sourceIndexPath = NSIndexPath(forRow: 0, inSection: 0)
                            self.snapshot!.removeFromSuperview()
                            self.snapshot = UIView()
                    })
                    break
            }
        }
    }

}