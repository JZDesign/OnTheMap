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
    
    // annotation vaiables, Float is for color opacity
    var annotations = [MKPointAnnotation]()
    var opacity: Float = 1.0
    
    // activity indicator
    let ai = ActivityIndicator(text:"Loading")
    
    
    @IBOutlet var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(ai)
        
        // on load get pins
        doReload(self)
    }

    
    
    // MARK: HELPER
    
    func addAnnotations(_ locations: [StudentLocation])  {
       
         for location in locations {
            
            if let latitude = location.latitude as! Double?, let longitude = location.longitude as! Double? {
<<<<<<< HEAD
            
                let lat = CLLocationDegrees(latitude)
                let long = CLLocationDegrees(longitude)
                
                // The lat and long are used to create a CLLocationCoordinates2D instance.
                let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
                
                if let first = location.firstName as? String, let last = location.lastName as? String, let mediaURL = location.mediaURL as? String {
                    // Here we create the annotation and set its coordiate, title, and subtitle properties
                    let annotation = MKPointAnnotation()
                    annotation.coordinate = coordinate
                    annotation.title = "\(first) \(last)"
                    annotation.subtitle = mediaURL
                    
=======
                let lat = CLLocationDegrees(latitude)
                let long = CLLocationDegrees(longitude)
            
              // The lat and long are used to create a CLLocationCoordinates2D instance.
                let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
            
                if let first = location.firstName as? String, let last = location.lastName as? String, let mediaURL = location.mediaURL as? String {
                    // Here we create the annotation and set its coordiate, title, and subtitle properties
                    let annotation = MKPointAnnotation()
                    annotation.coordinate = coordinate
                    annotation.title = "\(first) \(last)"
                    annotation.subtitle = mediaURL
                
>>>>>>> origin/master
                    // Finally we place the annotation in an array of annotations.
                    annotations.append(annotation)
                } else {
                    print("Error unwrapping values")
                }
            }
        }
        self.mapView.addAnnotations(annotations)
    }


    
    // MARK: - MKMapViewDelegate
    
    // Here we create a view with a "right callout accessory view". You might choose to look into other
    // decoration alternatives. Notice the similarity between this method and the cellForRowAtIndexPath
    // method in TableViewDataSource.
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        let reuseId = "pin"
        
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
        
        // set float value to edit opacity
        let float = 1.0 / Float(StudentDataSource.sharedInstance.studentData.count)
        
        if pinView == nil {
            
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.canShowCallout = true
            pinView!.pinTintColor = UIColor(colorLiteralRed: 255.00, green: 0, blue: 0, alpha: opacity)
            pinView!.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
            opacity = opacity - float
            // change opacity for next run through
        }
        else {
            pinView!.annotation = annotation
        }
        pinView?.animatesDrop = true
        
        return pinView
    }
    
    
    
    // This delegate method is implemented to respond to taps. It opens the system browser
    // to the URL specified in the annotationViews subtitle property.
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if control == view.rightCalloutAccessoryView {
            let app = UIApplication.shared
            if let toOpen = view.annotation?.subtitle! {
                
                // create mutable object to edit links
                var open = toOpen
                // remove spaces to prevent crash
                if open.range(of: " ") != nil{
                    open = open.replacingOccurrences(of: " ", with: "")
                }
                // set prefix to aid safari
                if (open.range(of: "://") != nil){
                    app.open(URL(string: open)!, options: [:] , completionHandler: nil)
                } else {
                    app.open(URL(string: "http://\(open)")!, options: [:] , completionHandler: nil)
                }

            }
        }
    }

    
    // MARK: BUTTONS
    
    // launch the addAnnotationViewController
    @IBAction func doAddLocation(_ sender: Any) {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let vc: AddAnnotationViewController = storyBoard.instantiateViewController(withIdentifier: "AddAnnotation") as! AddAnnotationViewController 
        present(vc , animated: true, completion: nil)
    }
    
    
    // call the logout function in client
    @IBAction func doLogOut(_ sender: Any) {
        self.ai.show()
        Client.sharedInstance().logOut { (error) in
            if error != nil {
                self.doFailedAlert("Logout Failed",error!)
            } else {
                DispatchQueue.main.async {
                    self.ai.hide()
                    self.dismiss(animated: true, completion: nil)
                }
            }
        }
    }
    
    
    
    // reload pin data and mapview
    @IBAction func doReload(_ sender: Any) {
        
        //reset opacity for pins
        opacity = 1.0
        
        // display indictor
        
        self.ai.show()
        
        //remove pins
        self.mapView.removeAnnotations(self.annotations)
        self.annotations.removeAll()
        
        // reset location data
        StudentDataSource.sharedInstance.studentData.removeAll()

        Client.sharedInstance().getLocations(completed: { (downloadError) in
            if downloadError != nil {
                self.doFailedAlert("Download Failed!", downloadError!)
                self.ai.hide()
            } else {
                // call main queue to update UI
                DispatchQueue.main.async {
                    self.reloadAnnotaions { (result, error) in
                        if error != nil{
                            print(error)
                        }
                        else {
                            self.addAnnotations(result as! [StudentLocation])
                        }
                        // hide indicator
                         self.ai.hide()
                    }
                } // end async
            } // end else
        })// end get locations
    }
    
    // reload helper
    func reloadAnnotaions(_ completion: (_ result : AnyObject?,_ Error : NSError?) -> Void) {
        // get locations and send back on completion
        let locations = StudentDataSource.sharedInstance.studentData
        completion(locations as AnyObject, nil)
        
    }
    
    

    // MARK: ALERT
    
    func doFailedAlert(_ message: String, _ error: NSError) {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: message, message: "\(error.localizedDescription)", preferredStyle: .alert)
            let action = UIAlertAction(title: "Crap Nuggets!", style: .destructive, handler: nil)
            alert.addAction(action)
            self.present(alert, animated: true)
        }
        
    }
    
    
    
}
