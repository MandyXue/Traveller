//
//  TimelineTableViewController.swift
//  Traveller
//
//  Created by MandyXue on 16/5/21.
//  Copyright © 2016年 AppleClub. All rights reserved.
//

import UIKit
import PKHUD

class ScheduleTableViewController: UITableViewController, NewScheduleDelegate {
    
    var cities: [ScheduleBean] = [] {
        didSet {
            if cities.count == 0 {
                let imageView = UIImageView(image: UIImage(named: "empty-table-bg"))
                self.tableView.backgroundView = imageView
            } else {
                let view = UIView(frame: CGRect(origin: CGPoint(x: 0, y: 0), size: self.view.bounds.size))
                self.tableView.backgroundView = view
            }
        }
    }
    let scheduleModel = ScheduleModel()
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
        navigationItem.title = "Schedule"
        
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(longPressGestureRecognized))
        self.tableView.addGestureRecognizer(longPress)
        
        // 获取数据
        HUD.show(.LabeledProgress(title: nil, subtitle: "Loading..."))
        scheduleModel.getSchedule(scheduleModel.userID)
            .then { news -> () in
                HUD.flash(.Success)
                self.cities = news
                self.tableView.reloadData()
            }.error { err in
                // 错误处理
                self.handleErrorMsg(err)
        }
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
        // TODO: 图片还是加载不出来
        cell.destNameLabel.text = cities[indexPath.row].destination
        cell.destDateLabel.text = "Start time: " + DataBean.onlyDateFormatter.stringFromDate(cities[indexPath.row].startDate)
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
                        detailViewController.schedule = cities[indexPath.row]
                        cell.setSelected(false, animated: false)
                    }
                }
            }
        }
    }
    
    // MARK: - New schedule delegate
    
    func newSchedule(schedule: ScheduleBean) {
        cities.append(schedule)
        tableView.reloadData()
    }
    
    // MARK: - Helper
    
    func prepareData() {
        cities.append(ScheduleBean(scheduleID: "test1", creatorId: "test", destination: "Shanghai, China", order: 0, imageURL: "http://img2.imgtn.bdimg.com/it/u=1562647182,3454169304&fm=21&gp=0.jpg", startDate: "2008-12-10"))
        cities.append(ScheduleBean(scheduleID: "test1", creatorId: "test", destination: "Uppsala, Sweden", order: 0, imageURL: "http://img1.imgtn.bdimg.com/it/u=1613045286,2980741283&fm=15&gp=0.jpg", startDate: "2008-12-10"))
    }
    
    func addDestination() {
        // TODO: 进入地图选点, add destination
        print("add")
        let vc = NewScheduleTableViewController.loadFromStoryboard() as! NewScheduleTableViewController
        vc.newScheduleDelegate = self
        vc.order = cities.count
        navigationController?.pushViewController(vc, animated: true)
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
                        self.cities = temp as AnyObject as! [ScheduleBean]
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
