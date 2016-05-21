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
        let navigationController: UINavigationController = UINavigationController.init(rootViewController: controller)
        return navigationController
    }
    
    // MARK: - Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Home"
        
        initLocationManager()
        mapView.delegate = self
        getAnnotations()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        mapView.showsUserLocation = true
        mapView.userTrackingMode = MKUserTrackingMode.Follow
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
        let testPost = PostModel(place: "Hong Kong Disney Land", detail: "Such a great place!! I love it so much!!!", location: CLLocationCoordinate2D(latitude: 22.3663913986, longitude: 114.1180044924))
        testPost.addImage(UIImage(named: "testPost")!)
        annotations.append(MapDataPointAnnotation(post: testPost))
        self.mapView.showAnnotations(annotations, animated: true)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

// MARK: - Delegate

extension HomeMapViewController {
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        // annotation view
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
    
    func mapView(mapView: MKMapView, regionWillChangeAnimated animated: Bool) {
        print("will change")
        // 这里应该再获取一次annotation
//        getAnnotations()
    }
    
    func mapView(mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        
        if let annotationView = view.annotation as? MapDataPointAnnotation {
            if let detailView = PostDetailTableViewController.loadFromStoryboard() as? PostDetailTableViewController {
                print(annotationView.title)
                // TODO: 接上接口以后要改这个参数
                detailView.post = PostModel(place: "Hong Kong Disney Land", detail: "Such a great place!! I love it so much!!!", location: CLLocationCoordinate2D(latitude: 22.3663913986, longitude: 114.1180044924))
                self.navigationController?.pushViewController(detailView, animated: true)
            } else {
                print("something went wrong...")
            }
        } else {
            print("something went wrong...")
        }
        
    }
}
