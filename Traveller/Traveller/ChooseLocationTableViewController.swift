//
//  ChooseLocationTableViewController.swift
//  Traveller
//
//  Created by MandyXue on 16/6/12.
//  Copyright © 2016年 AppleClub. All rights reserved.
//  地图搜索结果

import UIKit
import MapKit

protocol MapSearchDelegate {
    func setSearchResult(selectedLocaiton:MKMapItem)
}

class ChooseLocationTableViewController: UITableViewController {
    
    // MARK: - BaseViewController
    
    var searchResult = [MKMapItem]()
    var resultDelegate:MapSearchDelegate?
    
    static func loadFromStoryboard() -> UIViewController {
        let controller = UIStoryboard.traveller_chooseLocationStoryboard().instantiateViewControllerWithIdentifier(self.traveller_className())
        return controller
    }
    
    // MARK: - Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return searchResult.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("searchResultCell", forIndexPath: indexPath)

        let titleLabel = cell.viewWithTag(101) as! UILabel
        titleLabel.text = searchResult[indexPath.row].name
        
        let detailLabel = cell.viewWithTag(102) as! UILabel
        detailLabel.text = searchResult[indexPath.row].placemark.thoroughfare

        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        // 数据回传
        self.resultDelegate?.setSearchResult(searchResult[indexPath.row])
        
        self.navigationController?.popViewControllerAnimated(true)
    }

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
//    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
//        
//    }

}
