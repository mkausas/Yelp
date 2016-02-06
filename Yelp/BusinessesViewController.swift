//
//  BusinessesViewController.swift
//  Yelp
//
//  Created by Marty Kausas
//  Copyright (c) 2015 Marty Kausas. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation


class BusinessesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, FiltersViewControllerDelegate, UISearchBarDelegate, UIScrollViewDelegate, CLLocationManagerDelegate, MKMapViewDelegate {

    var businesses: [Business]!
    
    @IBOutlet weak var tableView: UITableView!
    
    var mapView: MKMapView!
    var locationManager: CLLocationManager!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 120 // only for scroll bar estimation
        
        
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        locationManager.distanceFilter = 200
        locationManager.requestWhenInUseAuthorization()
//        locationManager.user
        
        let searchBar = UISearchBar()
        searchBar.delegate = self
        
        self.navigationItem.titleView = searchBar
        
        mapView = MKMapView(frame: tableView.frame)
        mapView.delegate = self
        
        Business.searchWithTerm("Thai", completion: { (businesses: [Business]!, error: NSError!) -> Void in
            self.businesses = businesses
            self.tableView.reloadData()
            
            for business in businesses {
                print(business.name!)
                print(business.address!)
            }
        })

/* Example of Yelp search with more search options specified
        Business.searchWithTerm("Restaurants", sort: .Distance, categories: ["asianfusion", "burgers"], deals: true) { (businesses: [Business]!, error: NSError!) -> Void in
            self.businesses = businesses
            
            for business in businesses {
                print(business.name!)
                print(business.address!)
            }
        }
*/
    }
    
    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        if status == CLAuthorizationStatus.AuthorizedWhenInUse {
            locationManager.startUpdatingLocation()
        }
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            let span = MKCoordinateSpanMake(0.1, 0.1)
            let region = MKCoordinateRegionMake(location.coordinate, span)
            mapView.setRegion(region, animated: false)
        }
    }
    
    func addAnnotationAtCoordinate(business: Business) {
        let coordinate = business.coordinate
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate!
        annotation.title = business.name
        mapView.addAnnotation(annotation)
    }
    
    @IBAction func switchMap(sender: AnyObject) {
        UIView.transitionFromView(tableView, toView: mapView!, duration: 1000, options: UIViewAnimationOptions.Autoreverse) { (success) -> Void in
            let centerLocation = CLLocation(latitude: 37.7833, longitude: -122.4167)

            self.goToLocation(centerLocation)
//            self.addAnnotationAtCoordinate(CLLocationCoordinate2D(latitude: 37.7833, longitude: -122.4167))
            self.setupAnnotations()
        }
    }
    
    func setupAnnotations() {

        for business in businesses {
            print("setting up yo")

            addAnnotationAtCoordinate(business)
        }
    }
    
    func goToLocation(location: CLLocation) {
        let span = MKCoordinateSpanMake(0.1, 0.1)
        let region = MKCoordinateRegionMake(location.coordinate, span)
        mapView!.setRegion(region, animated: false)
    }
    
//    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
//        let identifier = "customAnnotationView"
//        
//        // custom image annotation
//        var annotationView = mapView.dequeueReusableAnnotationViewWithIdentifier(identifier)
//        if (annotationView == nil) {
//            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: identifier)
//        }
//        else {
//            annotationView!.annotation = annotation
//        }
//        annotationView!.image = UIImage(named: "yelp")
//        
//        return annotationView
//    }
    
    var isMoreDataLoading = false
    func scrollViewDidScroll(scrollView: UIScrollView) {
        if (!isMoreDataLoading) {
            // Calculate the position of one screen length before the bottom of the results
            let scrollViewContentHeight = tableView.contentSize.height
            let scrollOffsetThreshold = scrollViewContentHeight - tableView.bounds.size.height
            
            // When the user has scrolled past the threshold, start requesting
            if(scrollView.contentOffset.y > scrollOffsetThreshold && tableView.dragging) {
                
                isMoreDataLoading = true
                
                // Code to load more results
//                loadMoreData()
            }
        }
    }

    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        Business.searchWithTerm(searchText, completion: { (businesses: [Business]!, error: NSError!) -> Void in
            self.businesses = businesses
            self.tableView.reloadData()
            
            for business in businesses {
                print(business.name!)
                print(business.address!)
            }
        })
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if businesses != nil {
            return businesses.count
        }
        
        return 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("BusinessCell", forIndexPath: indexPath) as! BusinessCell
        
        cell.business = businesses[indexPath.row]
        
        return cell
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func filtersViewController(filtersViewController: FiltersViewController, didUpdateFilters filters: [String:AnyObject]) {
        
        let categories = filters["categories"] as? [String]
        
        Business.searchWithTerm("Restuarants", sort: nil, categories: categories, deals: nil) { (businesses: [Business]!, error: NSError!) -> Void in
            self.businesses = businesses
            self.tableView.reloadData()
        }
    }

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let navigationController = segue.destinationViewController as! UINavigationController
        
        let filtersViewController = navigationController.topViewController as! FiltersViewController
        filtersViewController.delegate = self
    }

}
