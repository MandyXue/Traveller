//
//  HomeMapViewController.swift
//  Traveller
//
//  Created by MandyXue on 16/5/21.
//  Copyright © 2016年 AppleClub. All rights reserved.
//

import UIKit
import MapKit

class HomeMapViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {
    
    var annotations: [MapDataPointAnnotation] = []
    let annotationViewReuseIdentifier = "annotationViewReuseIdentifier"
    var center:CLLocationCoordinate2D?
    
    @IBOutlet weak var mapView: MKMapView!
    let locationManager = CLLocationManager()
    let postModel = PostModel()
    // MARK: - BaseViewController
    
    static func loadFromStoryboard() -> UIViewController {
        let controller = UIStoryboard.traveller_homeStoryboard().instantiateViewControllerWithIdentifier(self.traveller_className())
        return controller
    }
    
    // MARK: - Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        initLocationManager()
        mapView.delegate = self
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        mapView.showsUserLocation = true
        mapView.userTrackingMode = .Follow
        
        // set up navigation bar
        self.tabBarController?.navigationItem.title = "Home"
        self.tabBarController?.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Add, target: self, action: #selector(addAnnotation))
        self.tabBarController?.navigationItem.leftBarButtonItem = nil
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        
        locationManager.stopUpdatingLocation()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Helper
    
    private func initLocationManager() {
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.distanceFilter = 1000
            locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
            locationManager.requestAlwaysAuthorization()
            locationManager.startUpdatingLocation()
        }
    }
    
    private func getAnnotations(mapView: MKMapView) {
        // 这里应该先用API获取annotation然后放到annotations里
        // 而且应该只获取部分信息就好了
        
        postModel.getAroundPost(mapView.region.span, center: mapView.region.center)
            .then { posts -> () in
                posts.forEach { post in
                    post.addImage(UIImage(named: "testPost")!)
                    self.annotations.append(MapDataPointAnnotation(post: post))
                }
                self.mapView.showAnnotations(self.annotations, animated: true)
            }.error { err in
                self.handleErrorMsg(err)
        }
    }
    
    func addAnnotation() {
        // TODO: add page
        print("add")
        let vc = NewPostTableViewController.loadFromStoryboard()
        presentViewController(vc, animated: true, completion: nil)
    }
}

// MARK: - Delegate

extension HomeMapViewController {
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        // annotation view
        if annotation.isKindOfClass(MKUserLocation) {
            return nil
        }
        
        var annotationView = mapView.dequeueReusableAnnotationViewWithIdentifier(annotationViewReuseIdentifier)
        if annotationView == nil {
            annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: annotationViewReuseIdentifier)
        }
        annotationView?.canShowCallout = true
        // deal with data point
        if let dataPointAnnotation = annotation as? MapDataPointAnnotation {
            let customImage = UIImageView.init(image: dataPointAnnotation.image)
            customImage.layer.cornerRadius = 2.0
            annotationView?.leftCalloutAccessoryView = customImage
            annotationView?.rightCalloutAccessoryView = UIButton(type: .DetailDisclosure)
        }
        return annotationView
    }
    
    func mapView(mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        
        if let annotationView = view.annotation as? MapDataPointAnnotation {
            if let detailView = PostDetailTableViewController.loadFromStoryboard() as? PostDetailTableViewController {
//                print(annotationView.title)
//                print("pointId:\(annotationView.pointId)")
                detailView.postId = annotationView.pointId
                self.navigationController?.pushViewController(detailView, animated: true)
            } else {
                print("something went wrong...")
            }
        } else {
            print("something went wrong...")
        }
    }
    
    
    func mapView(mapView: MKMapView, didUpdateUserLocation userLocation: MKUserLocation) {
        if let _ = self.center {
            let location = CLLocation(latitude: center!.latitude, longitude: center!.longitude)
            let distance = location.distanceFromLocation(userLocation.location!)
            
            if distance > 1000 {
                getAnnotations(mapView)
            }
        } else {
            getAnnotations(mapView)
        }
    }
}
