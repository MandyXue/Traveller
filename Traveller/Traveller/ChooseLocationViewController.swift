//
//  ChooseLocationViewController.swift
//  Traveller
//
//  Created by MandyXue on 16/6/12.
//  Copyright © 2016年 AppleClub. All rights reserved.
//  地图选点页面

import UIKit
import MapKit

protocol SelectLocationDelegate {
    func selectLocation(selectedLocation: MKMapItem)
}

class ChooseLocationViewController: UIViewController, UISearchBarDelegate, MKMapViewDelegate, CLLocationManagerDelegate, MapSearchDelegate {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var mapView: MKMapView!
    
    var selectedPoint:MKMapItem?
    var locationManager:CLLocationManager?
    var selectedAnnotation:MKAnnotation?
    var selectLocationDelegate:SelectLocationDelegate?
    
    let currentLocationSpan = MKCoordinateSpanMake(0.05, 0.05)
    
    
    
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
        
        mapView.delegate = self
        
        // 长按手势
        let longpressGesutre = UILongPressGestureRecognizer(target: self, action: #selector(ChooseLocationViewController.handleLongpressGesture(_:)))
        longpressGesutre.minimumPressDuration = 0.5
        longpressGesutre.allowableMovement = 15
        longpressGesutre.numberOfTouchesRequired = 1
        
        mapView.addGestureRecognizer(longpressGesutre)
        
        // 显示用户当前位置
        mapView.showsUserLocation = true
        mapView.userTrackingMode = .Follow
        startStandardUpdates()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        if let _ = selectedPoint {
            // 放置selectedPoint大头针
            
            if let _ = selectedAnnotation {
                mapView.removeAnnotation(selectedAnnotation!)
            }
            
            let newAnnotation = MKPointAnnotation()
            
            selectedAnnotation = newAnnotation
            newAnnotation.coordinate = selectedPoint!.placemark.coordinate
            newAnnotation.title = selectedPoint!.placemark.title
            newAnnotation.subtitle = selectedPoint!.placemark.thoroughfare
            
            mapView.addAnnotation(newAnnotation)
            mapView.centerCoordinate = newAnnotation.coordinate
            
            let currentRegion = MKCoordinateRegion(center: newAnnotation.coordinate, span: currentLocationSpan)
            mapView.setRegion(currentRegion, animated: true)
        }
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        
        locationManager?.stopUpdatingLocation()
    }
    
    func startStandardUpdates() {
        guard let _ = locationManager else {
            locationManager = CLLocationManager()
            locationManager!.delegate = self
            locationManager!.desiredAccuracy = kCLLocationAccuracyBest
            return
        }
        
        if CLLocationManager.locationServicesEnabled() {
            // 申请开启定位服务
            print("申请开启定位服务")
        }
        
        if getAuthorizationFromUser(CLLocationManager.authorizationStatus()) {
            locationManager!.startUpdatingLocation()
        }
    }
    
    func getAuthorizationFromUser(status: CLAuthorizationStatus) -> Bool {
        
        var userIsAgreeUseLocaiton = false
        switch status {
        case .AuthorizedAlways, .AuthorizedWhenInUse:
            //允许使用定位
            userIsAgreeUseLocaiton = true
        case .Denied, .Restricted:
            //没有获得授权，不允许使用定位
            //给用户提示，请求获得授权
            let alertController = UIAlertController(
                title: "定位权限被禁用",
                message: "请打开app的定位权限以获得当前位置信息",
                preferredStyle: .Alert)
            
            let cancelAction = UIAlertAction(title: "取消", style: .Cancel, handler: nil)
            alertController.addAction(cancelAction)
            
            let openAction = UIAlertAction(title: "设置", style: .Default) { (action) in
                if let url = NSURL(string:UIApplicationOpenSettingsURLString) {
                    UIApplication.sharedApplication().openURL(url)
                }
            }
            alertController.addAction(openAction)
            
            self.presentViewController(alertController, animated: true, completion: nil)
            
        case .NotDetermined:
            //向用户申请授权
            locationManager = CLLocationManager()
            self.locationManager!.requestWhenInUseAuthorization()
            
            userIsAgreeUseLocaiton = true
        }
        return userIsAgreeUseLocaiton
    }
    
    func handleLongpressGesture(sender: UILongPressGestureRecognizer) {
        if sender.state == UIGestureRecognizerState.Began {
            // 移除其他大头针
            if let _ = selectedAnnotation {
                mapView.removeAnnotation(selectedAnnotation!)
            }
            // 在长按的地方放置大头针，显示详情
            
            let touchPoint = sender.locationInView(mapView)
            let newCoordinates = mapView.convertPoint(touchPoint, toCoordinateFromView: mapView)
            let newAnnotation = MKPointAnnotation()
            selectedAnnotation = newAnnotation
            newAnnotation.coordinate = newCoordinates
            
            CLGeocoder().reverseGeocodeLocation(CLLocation(latitude: newCoordinates.latitude, longitude: newCoordinates.longitude), completionHandler: {(placemarks, error) -> Void in
                if error != nil {
                    print("Reverse geocoder failed with error" + error!.localizedDescription)
                    return
                }
                
                if placemarks?.count > 0 {
                    let pm = placemarks![0]
                    
                    // not all places have thoroughfare & subThoroughfare so validate those values
                    newAnnotation.title = pm.thoroughfare
                    newAnnotation.subtitle = pm.subLocality
                } else {
                    newAnnotation.title = "Unknown Place"
                    print("Problem with the data received from geocoder")
                }
                self.mapView.addAnnotation(newAnnotation)
                let selectedPlace:MKPlacemark
                if let address = placemarks?.last?.addressDictionary {
                    let addressInfo = address as! [String: AnyObject]
                    selectedPlace = MKPlacemark(coordinate: newAnnotation.coordinate, addressDictionary: addressInfo)
                } else {
                    selectedPlace = MKPlacemark(coordinate: newAnnotation.coordinate, addressDictionary: nil)
                }
                self.selectedPoint = MKMapItem(placemark: selectedPlace)
            })
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
            selectLocationDelegate!.selectLocation(self.selectedPoint!)
            self.navigationController?.popViewControllerAnimated(true)
        } else {
            print("please choose one location")
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
            
            let searchResult = response.mapItems
            
            let viewController = self.storyboard?.instantiateViewControllerWithIdentifier("ChooseLocationTableViewController") as! ChooseLocationTableViewController
            
            viewController.searchResult = searchResult
            viewController.resultDelegate = self
            searchBar.resignFirstResponder()
            self.navigationController?.pushViewController(viewController, animated: true)
        }
    }
    
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {

        if annotation.isKindOfClass(MKUserLocation) {
            print("user annotation")
            return nil
        } else {
            print("not user annotation")
            
            let newAnnotation = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "selecedPoint")
            newAnnotation.pinTintColor = MKPinAnnotationView.greenPinColor()
            newAnnotation.animatesDrop = true
            newAnnotation.canShowCallout = true
            
                        
            newAnnotation.setSelected(true, animated: true)
            
            return newAnnotation
        }
        
    }
}