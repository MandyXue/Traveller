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
    
    @IBOutlet weak var mapView: MKMapView!
    let locationManager = CLLocationManager()
    
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
        getAnnotations()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        mapView.showsUserLocation = true
        mapView.userTrackingMode = MKUserTrackingMode.Follow
        
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
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.requestAlwaysAuthorization()
            locationManager.startUpdatingLocation()
        }
    }
    
    private func getAnnotations() {
        // 这里应该先用API获取annotation然后放到annotations里
        // 而且应该只获取部分信息就好了
        let testPost = PostBean(place: "Hong Kong Disney Land", detail: "Such a great place!! I love it so much!!!", location: CLLocationCoordinate2D(latitude: 22.3663913986, longitude: 114.1180044924), address: "香港，大嶼山", creator: UserBean(username: "Huo Teng", avatar: UIImage(named: "avatar")!, place: "Shanghai, Jia Ding District"))
        testPost.addImage(UIImage(named: "testPost")!)
        annotations.append(MapDataPointAnnotation(post: testPost))
        let testPost2 = PostBean(place: "Hong Kong Disney Land", detail: "Such a great place!! I love it so much!!!", location: CLLocationCoordinate2D(latitude: 31.2855741398, longitude: 121.2147781261), address: "香港，大嶼山", creator: UserBean(username: "Huo Teng", avatar: UIImage(named: "avatar")!, place: "Shanghai, Jia Ding District"))
        testPost2.addImage(UIImage(named: "testPost")!)
        annotations.append(MapDataPointAnnotation(post: testPost2))
        self.mapView.showAnnotations(annotations, animated: true)
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
    
//    func mapView(mapView: MKMapView, regionWillChangeAnimated animated: Bool) {
//        print("will change")
        // 这里应该再获取一次annotation
//        getAnnotations()
//    }
    
    func mapView(mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        
        if let annotationView = view.annotation as? MapDataPointAnnotation {
            if let detailView = PostDetailTableViewController.loadFromStoryboard() as? PostDetailTableViewController {
                print(annotationView.title)
                // TODO: 接上接口以后要改这个参数
                detailView.post = PostBean(place: "Hong Kong Disney Land", detail: "Hong Kong Disneyland (Chinese: 香港迪士尼樂園) is the first theme parklocated inside the Hong Kong Disneyland Resort and is owned and managed by the Hong Kong International Theme Parks.", location: CLLocationCoordinate2D(latitude: 22.3663913986, longitude: 114.1180044924), address: "香港，大嶼山", creator: UserBean(username: "Huo Teng", avatar: UIImage(named: "avatar")!, place: "Shanghai, Jia Ding District"))
                self.navigationController?.pushViewController(detailView, animated: true)
            } else {
                print("something went wrong...")
            }
        } else {
            print("something went wrong...")
        }
        
    }
}
