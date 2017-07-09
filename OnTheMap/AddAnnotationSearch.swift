//
//  AddAnnotationSearch.swift
//  OnTheMap
//
//  Created by JacobRakidzich on 7/8/17.
//  Copyright © 2017 Jacob Rakidzich. All rights reserved.
//

import Foundation
import MapKit

extension AddAnnotationViewController {
    
    
    
    // MARK: Search bar
    // http://sweettutos.com/2015/04/24/swift-mapkit-tutorial-series-how-to-search-a-place-address-or-poi-in-the-map/
    // help with the search fucntion from this link
    
    func showSearchBar() {
        // initialize and present search bar
        searchController = UISearchController(searchResultsController: nil)
        searchController.hidesNavigationBarDuringPresentation = false
        self.searchController.searchBar.delegate = self
        present(searchController, animated: true, completion: nil)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar){
        // user clicked return
        // start search
        
        // display indicator
        let activityIndicator = ActivityIndicator(text: "Searching")
        self.view.addSubview(activityIndicator)
        activityIndicator.show()
        
        
        // kill keyboard, subview, and pins
        searchBar.resignFirstResponder()
        dismiss(animated: true, completion: nil)
        removePins()
        
        // do search for locations
        localSearchRequest = MKLocalSearchRequest()
        localSearchRequest.naturalLanguageQuery = searchBar.text
        localSearch = MKLocalSearch(request: localSearchRequest)
        localSearch.start { (localSearchResponse, error) -> Void in
            
            
            // alert if location not found
            if localSearchResponse == nil{
                let alertController = UIAlertController(title: nil, message: "Place Not Found", preferredStyle: UIAlertControllerStyle.alert)
                alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default, handler: nil))
                self.present(alertController, animated: true, completion: nil)
                activityIndicator.hide()
                return
            }
            
            // append annotation if result is found
            self.pointAnnotation = MKPointAnnotation()
            self.pointAnnotation.title = searchBar.text
            // get pin location
            self.pointAnnotation.coordinate = CLLocationCoordinate2D(latitude: localSearchResponse!.boundingRegion.center.latitude, longitude:     localSearchResponse!.boundingRegion.center.longitude)
            
            
            self.pinAnnotationView = MKPinAnnotationView(annotation: self.pointAnnotation, reuseIdentifier: nil)
            self.mapView.centerCoordinate = self.pointAnnotation.coordinate
            
            
            self.mapView.addAnnotation(self.pinAnnotationView.annotation!)
            
            // hide indicator
            activityIndicator.hide()
        }
       
    }
    

}
