//
//  AddAnnotationViewController.swift
//  OnTheMap
//
//  Created by JacobRakidzich on 7/6/17.
//  Copyright © 2017 Jacob Rakidzich. All rights reserved.


import UIKit
import MapKit
import CoreLocation

class AddAnnotationViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate, UISearchBarDelegate {

    // variables for search function
    var searchController:UISearchController!
    var annotation:MKAnnotation!
    var localSearchRequest:MKLocalSearchRequest!
    var localSearch:MKLocalSearch!
    var localSearchResponse:MKLocalSearchResponse!
    var error:NSError!
    var pointAnnotation:MKPointAnnotation!
    var pinAnnotationView:MKPinAnnotationView!
    
    var latitude: Double = 0.0
    var longitude: Double = 0.0
    
    @IBOutlet var shareButton: UIBarButtonItem!
    @IBOutlet var findLocationView: UIView!
    @IBOutlet var searchByTextButton: UIBarButtonItem!
    @IBOutlet var mapView: MKMapView!
    
    // location manager to find user location
    var locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    

        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: MAP VIEW
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        let reuseId = "pin"
        
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
        
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.canShowCallout = true
            pinView!.pinTintColor = .green
            pinView!.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        } else {
            pinView!.annotation = annotation
        }
        self.annotation = annotation
        
        pinView?.animatesDrop = true
        return pinView
    }
    
    
    
    

  
    // MARK: Search bar
    // http://sweettutos.com/2015/04/24/swift-mapkit-tutorial-series-how-to-search-a-place-address-or-poi-in-the-map/
    // help with the search fucntion from this link
    
    func showSearchBar() {
        searchController = UISearchController(searchResultsController: nil)
        searchController.hidesNavigationBarDuringPresentation = false
        self.searchController.searchBar.delegate = self
        present(searchController, animated: true, completion: nil)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar){
        
        //1
        searchBar.resignFirstResponder()
        dismiss(animated: true, completion: nil)
        if self.mapView.annotations.count != 0{
            annotation = self.mapView.annotations[0]
            self.mapView.removeAnnotation(annotation)
        }
        //2
        localSearchRequest = MKLocalSearchRequest()
        localSearchRequest.naturalLanguageQuery = searchBar.text
        localSearch = MKLocalSearch(request: localSearchRequest)
        localSearch.start { (localSearchResponse, error) -> Void in
            
            if localSearchResponse == nil{
                let alertController = UIAlertController(title: nil, message: "Place Not Found", preferredStyle: UIAlertControllerStyle.alert)
                alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default, handler: nil))
                self.present(alertController, animated: true, completion: nil)
                return
            }
            //3
            self.pointAnnotation = MKPointAnnotation()
            self.pointAnnotation.title = searchBar.text
            self.pointAnnotation.coordinate = CLLocationCoordinate2D(latitude: localSearchResponse!.boundingRegion.center.latitude, longitude:     localSearchResponse!.boundingRegion.center.longitude)
            
            
            self.pinAnnotationView = MKPinAnnotationView(annotation: self.pointAnnotation, reuseIdentifier: nil)
            self.mapView.centerCoordinate = self.pointAnnotation.coordinate
            // store location
            self.latitude = (self.pinAnnotationView.annotation?.coordinate.latitude)!
            self.longitude = (self.pinAnnotationView.annotation?.coordinate.longitude)!
            
            self.mapView.addAnnotation(self.pinAnnotationView.annotation!)
        }
    }
    
    
    // MARK: Alert
    

    
    // MARK: Buttons
    
    @IBAction func doDoneButton(_ sender: Any) {
        //stop updating location
        self.locationManager.stopUpdatingLocation()
        // store lat long data
        if annotation.coordinate.latitude != nil {
            latitude = annotation.coordinate.latitude
            longitude = annotation.coordinate.longitude
        }
        if latitude != 0.0 && longitude != 0.0 {
            let alert = UIAlertController(title: "You're on the Map!!",
                                          message: "Share a link!",
                                          preferredStyle: .alert)
            // Submit button
            let submitAction = UIAlertAction(title: "Submit", style: .default, handler: { (action) -> Void in
                // Get 1st TextField's text
                let textField = alert.textFields![0]
                print(textField.text!)
            })
            // Cancel button
            let cancel = UIAlertAction(title: "Cancel", style: .default, handler: { (action) -> Void in
                
            })
            // goBack button
            let goBack = UIAlertAction(title: "Go Back", style: .destructive, handler: { (action) -> Void in
                self.dismiss(animated: true, completion: nil)
            })
            
            alert.addTextField { (textField) in
                textField.keyboardAppearance = .light
                textField.keyboardType = .default
                textField.autocorrectionType = .no
                textField.placeholder = "Enter a Link"
            }
            alert.addAction(submitAction)
            alert.addAction(cancel)
            alert.addAction(goBack)
            present(alert, animated: true, completion: nil)
        } else {
            let alert = UIAlertController(title: "You're Not on the Map!!",
                                          message: "Tell us your location!",
                                          preferredStyle: .alert)
            // Cancel button
            let cancel = UIAlertAction(title: "Okay", style: .default, handler: { (action) -> Void in })
            // goBack button
            let goBack = UIAlertAction(title: "Go Back", style: .destructive, handler: { (action) -> Void in
                self.dismiss(animated: true, completion: nil)
            })
            alert.addAction(cancel)
            alert.addAction(goBack)
            present(alert, animated: true, completion: nil)
        }
        
        
    }
    
    @IBAction func doSearchByText(_ sender: Any) {
        // if there are any annotations remove them
        if CLLocationManager.locationServicesEnabled() {
            mapView.showsUserLocation = false
        }
        self.mapView.removeAnnotations(self.mapView.annotations)
        showSearchBar()
    }
    
    @IBAction func doFindLocation(_ sender: Any) {
        // if there are any annotations remove them
        self.mapView.removeAnnotations(self.mapView.annotations)
        self.locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            self.locationManager.delegate = self
            self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
            self.locationManager.startUpdatingLocation()
            mapView.showsUserLocation = true
            
            
        }
        
        
        
    }

    
}
