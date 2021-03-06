//
//  DayDetailTableViewController.swift
//  Traveller
//
//  Created by MandyXue on 16/6/13.
//  Copyright © 2016年 AppleClub. All rights reserved.
//

import UIKit
import PKHUD
import MapKit

class DayDetailTableViewController: UITableViewController, NewDayDetailDelegate {
    
    var spots: [DayDetailBean] = [] {
        didSet {
            if spots.count == 0 {
                let imageView = UIImageView(image: UIImage(named: "empty-table-bg"))
                self.tableView.backgroundView = imageView
            } else {
                let view = UIView(frame: CGRect(origin: CGPoint(x: 0, y: 0), size: self.view.bounds.size))
                self.tableView.backgroundView = view
            }
        }
    }
    var planId: String?
    var edit = false
    let dayDetailModel = DayDetailModel()
    
    // MARK: - Life cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.rightBarButtonItems = [UIBarButtonItem(barButtonSystemItem: .Add, target: self, action: #selector(addSpot)), UIBarButtonItem(barButtonSystemItem: .Edit, target: self, action: #selector(editSpot))]
        
        // 获取数据
        HUD.show(.LabeledProgress(title: nil, subtitle: "Loading..."))
        dayDetailModel.getDayDetails(planId!)
            .then { news -> () in
//                news.forEach { print($0.id!) }
                HUD.flash(.Success)
                self.spots = news
                self.tableView.reloadData()
            }.error { err in
                // 错误处理
                self.handleErrorMsg(err)
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if edit {
            return spots.count
        } else {
            return spots.count * 2 - 1
        }
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if edit {
            let index = indexPath.row
            let cell = tableView.dequeueReusableCellWithIdentifier("SpotCell", forIndexPath: indexPath) as! SpotTableViewCell
            // 不显示辅助线
            cell.upLineView.image = nil
            cell.bottomLineView.image = nil
            
            // type: 0:eating/1:living/2:spot
            switch spots[index].type {
            case 0:
                cell.typeImageView.image = UIImage(named: "eating")
            case 1:
                cell.typeImageView.image = UIImage(named: "living")
            default:
                cell.typeImageView.image = UIImage(named: "spot")
            }
            cell.nameLabel.text = spots[index].place
            cell.timeLabel.text = NSDate.dateToString(spots[index].startTime)
            return cell
        } else {
            if indexPath.row % 2 == 0 {
                let index = (indexPath.row+1)/2
                // 0, 2, 4, ... 等行数，即景点
                let cell = tableView.dequeueReusableCellWithIdentifier("SpotCell", forIndexPath: indexPath) as! SpotTableViewCell
                // 如果是第一行则不显示上方的辅助线，如果是最后一行则不显示下方辅助线
                if indexPath.row == 0 {
                    cell.upLineView.image = nil
                    cell.bottomLineView.image = UIImage(named: "line")!
                } else if indexPath.row == spots.count * 2 - 2 {
                    cell.upLineView.image = UIImage(named: "line")!
                    cell.bottomLineView.image = nil
                } else {
                    cell.upLineView.image = UIImage(named: "line")!
                    cell.bottomLineView.image = UIImage(named: "line")!
                }
                
                // type: 0:eating/1:living/2:spot
                switch spots[index].type {
                case 0:
                    cell.typeImageView.image = UIImage(named: "eating")
                case 1:
                    cell.typeImageView.image = UIImage(named: "living")
                default:
                    cell.typeImageView.image = UIImage(named: "spot")
                }
                cell.nameLabel.text = spots[index].place
                cell.timeLabel.text = DataBean().timeFormatter.stringFromDate(spots[index].startTime) + " to " + DataBean().timeFormatter.stringFromDate(spots[index].endTime)
                return cell
            } else {
                // 1, 3, 5, ... 等行数，即过路
                let cell = tableView.dequeueReusableCellWithIdentifier("TransportCell", forIndexPath: indexPath) as! TransportTableViewCell
//                cell.timeLabel.text = "1.1km walking"
                let point1 = spots[(indexPath.row-1)/2].coordinate
                let point2 = spots[(indexPath.row+1)/2].coordinate
                let distance = getDistance(point1, point2: point2)
                let str = NSString(format: "%0.2f", distance)
                cell.timeLabel.text = "\(str) kilometers"
                return cell
            }
        }
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if edit {
            return 84
        } else {
            if indexPath.row % 2 == 0 {
                return 84
            } else {
                return 28
            }
        }
    }
    
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        if edit {
            return true
        }
        return indexPath.row % 2 == 0
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        
        if editingStyle == .Delete {
            if edit {
                // Delete the row from the data source
                if indexPath.row < spots.count {
                    spots.removeAtIndex(indexPath.row)
                    tableView.reloadData()
                }
            } else {
                // Delete the row from the data source
                if indexPath.row < spots.count * 2 - 1 {
                    spots.removeAtIndex((indexPath.row + 1)/2)
                    tableView.reloadData()
                }
            }
        }
    }
    
    // MARK: - New plan delegate
    
    func newDayDetail(dayDetail: DayDetailBean) {
        spots.append(dayDetail)
        tableView.reloadData()
    }
    
    // MARK: - Helper
    
    func getDistance(point1: CLLocationCoordinate2D, point2: CLLocationCoordinate2D) -> Double {
        let earth_radius = 6378.137
        func rad(d: Double) -> Double {
            return d * M_PI / 180.0
        }
        
        let radlat1 = rad(point1.latitude)
        let radlat2 = rad(point2.latitude)
        let a = radlat1 - radlat2
        let b = rad(point1.longitude) - rad(point2.longitude)
        
        var s = 2 * sin(sqrt(pow(sin(a/2), 2) + cos(radlat1) * cos(radlat2) * pow(sin(b/2), 2)))
        s = s * earth_radius
        s = round(s * 10000) / 10000
        return s
    }
    
    func addSpot() {
        let vc = NewDayDetailTableViewController.loadFromStoryboard() as! NewDayDetailTableViewController
        vc.newDayDetailDelegate = self
        vc.planId = self.planId
        print("planId: \(planId)")
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func editSpot() {
        edit = true
        tableView.reloadData()
//        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(longPressGestureRecognized))
//        self.tableView.addGestureRecognizer(longPress)
        self.navigationItem.rightBarButtonItems = [UIBarButtonItem(barButtonSystemItem: .Done, target: self, action: #selector(done))]
    }
    
    func done() {
        edit = false
        tableView.reloadData()
//        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(longPressGestureRecognized))
//        self.tableView.removeGestureRecognizer(longPress)
        self.navigationItem.rightBarButtonItems = [UIBarButtonItem(barButtonSystemItem: .Add, target: self, action: #selector(addSpot)), UIBarButtonItem(barButtonSystemItem: .Edit, target: self, action: #selector(editSpot))]
    }
    
    // MARK: - Long press gesture
    
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
                    let temp = NSMutableArray(array: spots)
                    temp.exchangeObjectAtIndex(indexPath!.row, withObjectAtIndex: sourceIndexPath!.row)
                    self.spots = temp as AnyObject as! [DayDetailBean]
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
