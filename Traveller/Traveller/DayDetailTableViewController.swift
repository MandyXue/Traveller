//
//  DayDetailTableViewController.swift
//  Traveller
//
//  Created by MandyXue on 16/6/13.
//  Copyright © 2016年 AppleClub. All rights reserved.
//

import UIKit

class DayDetailTableViewController: UITableViewController {
    
    var spots: [[String:String]] = []
    
    // MARK: - Life cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Add, target: self, action: #selector(addSpot))
        
        prepareData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return spots.count * 2 - 1
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if indexPath.row % 2 == 0 {
            let index = (indexPath.row+1)/2
            // 0, 2, 4, ... 等行数，即景点
            let cell = tableView.dequeueReusableCellWithIdentifier("SpotCell", forIndexPath: indexPath) as! SpotTableViewCell
            // 如果是第一行则不显示上方的辅助线，如果是最后一行则不显示下方辅助线
            if indexPath.row == 0 {
                cell.upLineView.image = nil
                cell.bottomLineView.image = UIImage(named: "line")!
            }
            if indexPath.row == spots.count * 2 - 2 {
                cell.upLineView.image = UIImage(named: "line")!
                cell.bottomLineView.image = nil
            }
            
            // type: eating/living/spot
            cell.typeImageView.image = UIImage(named: spots[index]["type"]!)
            cell.nameLabel.text = spots[index]["name"]
            cell.timeLabel.text = spots[index]["time"]
            return cell
        } else {
            // 1, 3, 5, ... 等行数，即过路
            let cell = tableView.dequeueReusableCellWithIdentifier("TransportCell", forIndexPath: indexPath) as! TransportTableViewCell
            cell.timeLabel.text = "1.1km walking"
            return cell
        }
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.row % 2 == 0 {
            return 84
        } else {
            return 28
        }
    }
    
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return indexPath.row % 2 == 0
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            if indexPath.row < spots.count * 2 - 1 {
                spots.removeAtIndex((indexPath.row + 1)/2)
                tableView.reloadData()
            }
        }
    }
    
    // MARK: - Helper
    
    func prepareData() {
        spots.append(["name": "鹅銮鼻灯塔", "type": "spot", "time": "10:00 to 10:50"])
        spots.append(["name": "鹅銮鼻公园", "type": "spot", "time": "10:55 to 18:20"])
        spots.append(["name": "台湾最南点碑", "type": "spot", "time": "18:50 to 19:20"])
        spots.append(["name": "垦丁俪山林会馆", "type": "living", "time": "night🌚"])
    }
    
    func addSpot() {
        // TODO: add a spot
        spots.append(["name": "test", "type": "spot", "time": "半夜出来吓人"])
        tableView.reloadData()
    }

}
