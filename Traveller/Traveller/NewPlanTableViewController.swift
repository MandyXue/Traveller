//
//  NewPlanTableViewController.swift
//  Traveller
//
//  Created by MandyXue on 16/6/20.
//  Copyright © 2016年 AppleClub. All rights reserved.
//

import UIKit
import PKHUD

protocol NewPlanDelegate {
    func newPlan(plan: PlanBean)
}

class NewPlanTableViewController: UITableViewController {
    
    var places: [String] = []
    
    var plan: PlanBean?
    var scheduleId: String?
    
    var newPlanDelegate: NewPlanDelegate?
    
    // MARK: - BaseViewController
    
    static func loadFromStoryboard() -> UIViewController {
        let controller = UIStoryboard.traveller_scheduleStoryboard().instantiateViewControllerWithIdentifier(self.traveller_className())
        return controller
    }
    
    // MARK: - Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.rightBarButtonItems = [UIBarButtonItem(barButtonSystemItem: .Add, target: self, action: #selector(addSelector)), UIBarButtonItem(barButtonSystemItem: .Done, target: self, action: #selector(doneSelector))]
        
        // TODO: 把planId去掉
        if scheduleId != nil {
            plan = PlanBean(planId: "test", scheduleId: scheduleId!, content: "")
        } else {
            let alert = UIAlertController(title: "Error", message: "Something went wrong, please exit this page.", preferredStyle: .Alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .Cancel, handler: nil))
            presentViewController(alert, animated: true, completion: nil)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if places.count == 0 {
            return 1
        }
        return places.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if places.count == 0 {
            let cell = tableView.dequeueReusableCellWithIdentifier("NewPlanCell", forIndexPath: indexPath) as UITableViewCell
            cell.textLabel?.text = "Press the right bar button to make a route for your destination cities ➚"
            return cell
        }
        let cell = tableView.dequeueReusableCellWithIdentifier("NewPlanCell", forIndexPath: indexPath) as UITableViewCell
        cell.textLabel?.text = places[indexPath.row]
        return cell
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if places.count == 0 {
            return 100
        } else {
            return 50
        }
    }
    
    // MARK: - Helper
    
    func addSelector() {
        let alert = UIAlertController(title: "Add a place", message: nil, preferredStyle: .Alert)
        alert.addTextFieldWithConfigurationHandler { (textField) in
            textField.placeholder = "Place name..."
        }
        alert.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Submit", style: .Default, handler: { (action) in
            if alert.textFields![0].text != "" {
                self.places.append(alert.textFields![0].text!)
                self.tableView.reloadData()
                HUD.flash(.Success, delay: 1.0)
            } else {
                HUD.flash(.LabeledError(title: "Error", subtitle: "Destination city name cannot be empty."), delay: 2.0)
            }
        }))
        presentViewController(alert, animated: true, completion: nil)
    }
    
    func doneSelector() {
        if places.count != 0 {
            var string = places[0]
            for i in 1 ..< places.count {
                string.appendContentsOf(" > ")
                string.appendContentsOf(places[i])
            }
            self.plan?.content = string
            newPlanDelegate?.newPlan(self.plan!)
            HUD.flash(.Success, delay: 1.0)
            navigationController?.popViewControllerAnimated(true)
        } else {
            let alert = UIAlertController(title: "Error", message: "Plan destination cities cannot be empty!", preferredStyle: .Alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .Cancel, handler: nil))
            presentViewController(alert, animated: true, completion: nil)
        }
    }

}
