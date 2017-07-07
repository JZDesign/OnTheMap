//
//  MapViewController.swift
//  OnTheMap
//
//  Created by JacobRakidzich on 7/6/17.
//  Copyright © 2017 Jacob Rakidzich. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController, MKMapViewDelegate {

    var annotations = [MKPointAnnotation]()
    
    
    @IBOutlet var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // fetch locations
        addAnnotations()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: HELPER
    
    func addAnnotations()  {
        
        
        let locations = Client.sharedInstance().locations
         for location in locations {
            
            // Notice that the float values are being used to create CLLocationDegree values.
            // This is a version of the Double type.
            let lat = CLLocationDegrees(location.latitude as! Double)
            let long = CLLocationDegrees(location.longitude as! Double)
            
            // The lat and long are used to create a CLLocationCoordinates2D instance.
            let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
            
            if let first = location.firstName as? String, let last = location.lastName as? String, let mediaURL = location.mediaURL as? String {
                // Here we create the annotation and set its coordiate, title, and subtitle properties
                let annotation = MKPointAnnotation()
                annotation.coordinate = coordinate
                annotation.title = "\(first) \(last)"
                annotation.subtitle = mediaURL
                
               

                
                // Finally we place the annotation in an array of annotations.
                annotations.append(annotation)
            } else {
                print("Error unwrapping values")
            }
            
        }
        self.mapView.addAnnotations(annotations)
    }

    func reloadAnnotaions(_ completion: (_ result : AnyObject?,_ Error : NSError?) -> Void) {
        do {
            self.mapView.removeAnnotations(annotations)
            Client.sharedInstance().getLocations()
        } catch {
            completion(nil,NSError(domain: "NOPE!", code: 1, userInfo: [NSLocalizedDescriptionKey : "Could not reload pins "]))
        }
        let locations = Client.sharedInstance().locations
        completion(locations as AnyObject,nil)
        
    }
    
    // MARK: - MKMapViewDelegate
    
    // Here we create a view with a "right callout accessory view". You might choose to look into other
    // decoration alternatives. Notice the similarity between this method and the cellForRowAtIndexPath
    // method in TableViewDataSource.
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        let reuseId = "pin"
        
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
        
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.canShowCallout = true
            pinView!.pinColor = .red
            pinView!.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        }
        else {
            pinView!.annotation = annotation
        }
        
        return pinView
    }
    
    
    // This delegate method is implemented to respond to taps. It opens the system browser
    // to the URL specified in the annotationViews subtitle property.
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if control == view.rightCalloutAccessoryView {
            let app = UIApplication.shared
            if let toOpen = view.annotation?.subtitle! {
                //app.openURL(URL(string: toOpen)!)
                if (toOpen.range(of: "://") != nil){
                    app.open(URL(string: toOpen)!, options: [:] , completionHandler: nil)
                } else {
                    app.open(URL(string: "http://\(toOpen)")!, options: [:] , completionHandler: nil)
                }
            }
        }
    }

    
        /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    @IBAction func doAddLocation(_ sender: Any) {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let vc: AddAnnotationViewController = storyBoard.instantiateViewController(withIdentifier: "AddAnnotation") as! AddAnnotationViewController 
        present(vc , animated: true, completion: nil)
    }

    @IBAction func doReload(_ sender: Any) {
        
        reloadAnnotaions { (result, error) in
            if error != nil{
                print(error)
            }
            else {
                addAnnotations()
            }
        }
    }
}
