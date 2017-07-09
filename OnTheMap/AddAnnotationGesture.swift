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
        let location = CLLocation(latitude: annotation.coordinate.latitude, longitude: annotation.coordinate.longitude)
        let reverseLocation = CLGeocoder()
        var result = ""
        reverseLocation.reverseGeocodeLocation(location) { (placemarks, error) in
            var placemark: CLPlacemark!
            placemark = placemarks?[0]
            print(placemark.addressDictionary)
            if let city = placemark.addressDictionary!["City"] as? String {
                result += city + " "
            }
            if let state = placemark.addressDictionary!["State"] as? String {
                result += state + ", "
            }
            if let country = placemark.addressDictionary!["Country"] as? String {
                result += country
            }
            self.mapString = result
            completed()
        }
    }
    
    // Tap Recognizer
    
    func tapGestureHandler(sender: UITapGestureRecognizer? = nil) {
        removePins()
        
        let pin = tapRecognizer.location(in: mapView)
        let pinLocation = mapView.convert(pin, toCoordinateFrom: mapView)
        let pinAnnotation = MKPointAnnotation()
        pinAnnotation.coordinate = pinLocation
        self.annotation = pinAnnotation
        mapView.addAnnotation(self.annotation)
    }
    

    
}
