//
//  ChooseLocationViewController.swift
//  Traveller
//
//  Created by MandyXue on 16/6/12.
//  Copyright © 2016年 AppleClub. All rights reserved.
//  地图选点页面

import UIKit
import MapKit

class ChooseLocationViewController: UIViewController, UISearchBarDelegate, MapSearchDelegate {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var mapView: MKMapView!
    
    var selectedPoint:MKMapItem?
    
    // MARK: - BaseViewController
    
    static func loadFromStoryboard() -> UIViewController {
        let controller = UIStoryboard.traveller_chooseLocationStoryboard().instantiateViewControllerWithIdentifier(self.traveller_className())
        return controller
    }
    
    // MARK: - Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Done", style: .Done, target: self, action: #selector(makeChoice))
        self.searchBar.delegate = self
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        if let _ = selectedPoint {
            // 放置selectedPoint大头针
            let selectedAnnotation = MKPointAnnotation()
            selectedAnnotation.coordinate = selectedPoint!.placemark.coordinate
            selectedAnnotation.title = selectedPoint!.placemark.title
            selectedAnnotation.subtitle = selectedPoint!.placemark.thoroughfare
            
            mapView.addAnnotation(selectedAnnotation)
            mapView.centerCoordinate = selectedAnnotation.coordinate
            
            let latDelta = 0.05
            let longDelta = 0.05
            let currentLocationSpan:MKCoordinateSpan = MKCoordinateSpanMake(latDelta, longDelta)

            
            let currentRegion = MKCoordinateRegion(center: selectedAnnotation.coordinate, span: currentLocationSpan)
            mapView.setRegion(currentRegion, animated: true)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Helper
    
    func makeChoice() {
        print("make choice")
        // 把地图选点结果回传上个页面
        
        if let _ = self.selectedPoint {
            // 回传数据
            
            self.navigationController?.popViewControllerAnimated(true)
        }
    }
    
    func setSearchResult(selectedLocaiton: MKMapItem) {
        self.selectedPoint = selectedLocaiton
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        print(searchBar.text)
        
        // 根据输入搜索地点
        let request = MKLocalSearchRequest()
        request.naturalLanguageQuery = searchBar.text!
        request.region = mapView.region
        let search = MKLocalSearch(request: request)
        
        search.startWithCompletionHandler { (response, error) in
            guard let response = response else {
                // TODO: 添加错误处理
                print("Search error: \(error)")
                return
            }
            
            for item in response.mapItems {
                print("search result:\(item.name)")
                print("content:\(item.description)")
            }
            
            let searchResult = response.mapItems
            
            let viewController = self.storyboard?.instantiateViewControllerWithIdentifier("ChooseLocationTableViewController") as! ChooseLocationTableViewController
            
            viewController.searchResult = searchResult
            viewController.resultDelegate = self
            searchBar.resignFirstResponder()
            self.navigationController?.pushViewController(viewController, animated: true)
        }
    }
    
    
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
//    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
//    }

}