//
//  TimelineTableViewController.swift
//  Traveller
//
//  Created by MandyXue on 16/6/12.
//  Copyright © 2016年 AppleClub. All rights reserved.
//

import UIKit

class TimelineTableViewController: UITableViewController {
    
    var places: [[String:String]] = []
    var gradientColors: [UIColor] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        prepareData()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
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
        cell.dayLabel.text = "D\(indexPath.row+1)"
        cell.placeLabel.text = places[indexPath.row]["place"]
        cell.timeLabel.text = places[indexPath.row]["time"]
        cell.backCircleView.backgroundColor = calculateColor(calculateProgress(indexPath), colors: gradientColors)
        return cell
    }
    
    // MARK: - Helper
    
    func prepareData() {
        var i = 0
        while i < 5 {
            places.append(["place": "Yu Garden", "time": NSDate.dateToString(NSDate.init(timeIntervalSinceNow: 0))])
            places.append(["place": "the Bund", "time": NSDate.dateToString(NSDate.init(timeIntervalSinceNow: 6000))])
            places.append(["place": "Oriental Pearl TV Tower", "time": NSDate.dateToString(NSDate.init(timeIntervalSinceNow: 12000))])
            i += 1
        }
        
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

}
