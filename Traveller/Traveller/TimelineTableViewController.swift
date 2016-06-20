//
//  TimelineTableViewController.swift
//  Traveller
//
//  Created by MandyXue on 16/6/12.
//  Copyright © 2016年 AppleClub. All rights reserved.
//

import UIKit

class TimelineTableViewController: UITableViewController, NewPlanDelegate {
    
    var places: [PlanBean] = []
    var gradientColors: [UIColor] = []
    var schedule: ScheduleBean?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        prepareData()

        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Add, target: self, action: #selector(addDay))
        
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(longPressGestureRecognized))
        self.tableView.addGestureRecognizer(longPress)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return places.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("TimelineCell", forIndexPath: indexPath) as! TimelineTableViewCell
        // 算出来的数值
        cell.dayLabel.text = "D\(indexPath.row+1)"
        let date = NSDate(timeInterval: timeIntervalForOneDay * Double(indexPath.row), sinceDate: schedule!.startDate)
        cell.timeLabel.text = DataBean.onlyDateFormatter.stringFromDate(date)
        cell.backCircleView.backgroundColor = calculateColor(calculateProgress(indexPath), colors: gradientColors)
        // 需要设置的内容
        cell.placeLabel.text = places[indexPath.row].content
        return cell
    }
    
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            if indexPath.row < places.count {
                places.removeAtIndex(indexPath.row)
                tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Left)
            }
        }
    }
    
    // MARK: - New plan delegate
    
    func newPlan(plan: PlanBean) {
        self.places.append(plan)
        self.tableView.reloadData()
    }
    
    // MARK: - Navigation
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "DayDetailSegue" {
            if let detailViewController = segue.destinationViewController as? DayDetailTableViewController {
                if let indexPath = tableView.indexPathForSelectedRow {
                    if let cell = tableView.cellForRowAtIndexPath(indexPath) as? TimelineTableViewCell {
                        // TODO: pass value
                        detailViewController.planId = places[indexPath.row].id
                        cell.setSelected(false, animated: false)
                    }
                }
            }
        }
    }
    
    // MARK: - Helper
    
    func addDay() {
        // TODO: add day
        print("addday")
        let vc = NewPlanTableViewController.loadFromStoryboard() as! NewPlanTableViewController
        vc.newPlanDelegate = self
        vc.scheduleId = self.schedule?.id
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func prepareData() {
        places = []
        gradientColors = []
        
        places.append(PlanBean(planId: "test", scheduleId: schedule!.id!, content: "Shanghai > Taipei"))
        places.append(PlanBean(planId: "test", scheduleId: schedule!.id!, content: "Taipei > Hualian"))
        places.append(PlanBean(planId: "test", scheduleId: schedule!.id!, content: "Hualian"))
        places.append(PlanBean(planId: "test", scheduleId: schedule!.id!, content: "Hualian > Taidong"))
        places.append(PlanBean(planId: "test", scheduleId: schedule!.id!, content: "Taidong > Kending"))
        places.append(PlanBean(planId: "test", scheduleId: schedule!.id!, content: "Kending"))
        places.append(PlanBean(planId: "test", scheduleId: schedule!.id!, content: "Kending > Shanghai"))
        
        // color
        gradientColors.append(UIColor(red: 86/255, green: 158/255, blue: 8/255, alpha: 1))
        gradientColors.append(UIColor(red: 213/255, green: 231/255, blue: 194/255, alpha: 1))
    }
    
    func calculateColor(progress: CGFloat, colors: [UIColor]) -> UIColor {
        let color1 = colors.first
        let color2 = colors.last
        
        let red = CGColorGetComponents(color1?.CGColor)[0] + (CGColorGetComponents(color2?.CGColor)[0] - CGColorGetComponents(color1?.CGColor)[0]) * progress
        let green = CGColorGetComponents(color1?.CGColor)[1] + (CGColorGetComponents(color2?.CGColor)[1] - CGColorGetComponents(color1?.CGColor)[1]) * progress
        let blue = CGColorGetComponents(color1?.CGColor)[2] + (CGColorGetComponents(color2?.CGColor)[2] - CGColorGetComponents(color1?.CGColor)[2]) * progress
        
        return UIColor(red: red, green: green, blue: blue, alpha: 1)
    }
    
    func calculateProgress(index: NSIndexPath) -> CGFloat {
        let result = CGFloat(index.row+1)/CGFloat(places.count)
        return result
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
                    let temp = NSMutableArray(array: places)
                    temp.exchangeObjectAtIndex(indexPath!.row, withObjectAtIndex: sourceIndexPath!.row)
                    self.places = temp as AnyObject as! [PlanBean]
                    tableView.reloadData()
                    // TODO: 将places存到远端
                    
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
