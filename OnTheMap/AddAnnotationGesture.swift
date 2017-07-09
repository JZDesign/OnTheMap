//
//  AddAnnotationGesture.swift
//  OnTheMap
//
//  Created by JacobRakidzich on 7/8/17.
//  Copyright © 2017 Jacob Rakidzich. All rights reserved.
//

import Foundation
import MapKit
extension AddAnnotationViewController {
    
    // MARK: GESTURE RECOGNIZER
    // find location string
    // modified from https://stackoverflow.com/questions/38977692/how-to-get-location-name-from-default-annotations-mapkit-in-ios
    
    func geoString(completed: @escaping () -> ())  {
        //set location
        let location = CLLocation(latitude: annotation.coordinate.latitude, longitude: annotation.coordinate.longitude)
        // initialize geocoder to reverse engineer location string
        let reverseLocation = CLGeocoder()
        // variable to store result
        var result = ""
        reverseLocation.reverseGeocodeLocation(location) { (placemarks, error) in
            var placemark: CLPlacemark!
            // read placemark closest to user location
            placemark = placemarks?[0]
            //print(placemark.addressDictionary)
            
            // grab info from dict and append to result string
            if let city = placemark.addressDictionary!["City"] as? String {
                result += city + " "
            }
            if let state = placemark.addressDictionary!["State"] as? String {
                result += state + ", "
            }
            if let country = placemark.addressDictionary!["Country"] as? String {
                result += country
            }
            // store to class variable
            self.mapString = result
            completed()
        }
    }
    
    // Tap Recognizer
    
    func tapGestureHandler(sender: UITapGestureRecognizer? = nil) {
        removePins()
        // use tap to pin location
        let pin = tapRecognizer.location(in: mapView)
        let pinLocation = mapView.convert(pin, toCoordinateFrom: mapView)
        let pinAnnotation = MKPointAnnotation()
        pinAnnotation.coordinate = pinLocation
        self.annotation = pinAnnotation
        mapView.addAnnotation(self.annotation)
    }
    

    
}
