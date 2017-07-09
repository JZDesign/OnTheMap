//
//  AddAnnotationViewController.swift
//  OnTheMap
//
//  Created by JacobRakidzich on 7/6/17.
//  Copyright © 2017 Jacob Rakidzich. All rights reserved.


import UIKit
import MapKit
import CoreLocation

class AddAnnotationViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate, UISearchBarDelegate, UIGestureRecognizerDelegate {

    // variables for search function
    var searchController:UISearchController!
    var annotation:MKAnnotation!
    var localSearchRequest:MKLocalSearchRequest!
    var localSearch:MKLocalSearch!
    var localSearchResponse:MKLocalSearchResponse!
    var error:NSError!
    var pointAnnotation:MKPointAnnotation!
    var pinAnnotationView:MKPinAnnotationView!

    var mapString: String = ""
    
    var userPinExists = false
    var userPins = [StudentLocation]()
    
    var tapRecognizer = UITapGestureRecognizer()
    
    let urlParse = Client.URLFromParameters(Client.Constants.Parse.Scheme, Client.Constants.Parse.Host, Client.Constants.Parse.Path, withPathExtension: Client.Constants.Methods.StudentLocation)
    
    @IBOutlet var shareButton: UIBarButtonItem!
    @IBOutlet var findLocationView: UIView!
    @IBOutlet var searchByTextButton: UIBarButtonItem!
    @IBOutlet var mapView: MKMapView!
    @IBOutlet var locationLabel: UILabel!
    
    // location manager to find user location
    var locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationLabel.text = "Peanut Butter Jelly Time"
        // check if user has a pin on the map already
        findUserAnnotation()
        
        tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.tapGestureHandler(sender:)))
        tapRecognizer.delegate = self
        mapView.addGestureRecognizer(tapRecognizer)
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    // MARK: MAP VIEW
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        let reuseId = "pin"
        
        // set annotation data
        self.annotation = annotation
        Client.sharedInstance().myinfo?.latitude = self.annotation.coordinate.latitude
        Client.sharedInstance().myinfo?.longitude = self.annotation.coordinate.longitude
        self.geoString {
            Client.sharedInstance().myinfo?.mapString = self.mapString
            // Update UI
            self.locationLabel.text = self.mapString
        }
        
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
        // display pin
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.canShowCallout = true
            pinView!.pinTintColor = .green
            pinView!.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        } else {
            pinView!.annotation = annotation
        }
        
        pinView?.animatesDrop = true
        return pinView
    }
    
    
    // remove current pins
    
    func removePins() {
        self.mapView.removeAnnotations(self.mapView.annotations)
    }
    
        
    // MARK: Post
    
    func findUserAnnotation() {
        // method to locate any annotations by a given uniqueKey and delete them
        //let url = Client.URLFromParameters(Client.Constants.Parse.Scheme, Client.Constants.Parse.Host, Client.Constants.Parse.Path, withPathExtension: Client.Constants.Methods.StudentLocation as! String, withQuery: "?where={\"uniqueKey\": \"\(Client.Constants.UserSession.accountKey)\"}")
       
        let url = URL(string:"https://parse.udacity.com/parse/classes/StudentLocation?where=%7B%22uniqueKey%22%3A%22\(Client.Constants.UserSession.accountKey )%22%7D")
        
        Client.sharedInstance().doAllTasks(url: url!, task:"GET", jsonBody: "", truncatePrefix: 0, completionHandlerForAllTasks:  { (result, error) in
            if error != nil {
                print(error)
            }
            print("######### FIND USER ###### \(result?["results"])")
            let locationsDict = result?["results"] as! [[String : Any]]
            for item in locationsDict {
                let newLocation = StudentLocation(studentLocation: item)
                self.userPins.append(newLocation)
            }

            if self.userPins.count > 0 {
                self.userPinExists = true
            }
        })
    }
    
    
    
    // MARK: PIN GET SET DESTROY REPLACE
    
    // DESTROY PINS FUNCTION TO DELETE USER PINS IN MULTIPLES.
    func destroyPins() {
        //
        
        for item in userPins {
            print(item.firstName,item.mapString,item.mediaURL,item.objectId)
            if let string = item.objectId as? String {
                let url = URL(string:"https://parse.udacity.com/parse/users/\(string)")

                let jsonBody = ""
                Client.sharedInstance().doAllTasks(url: url!, task: "DELETE", jsonBody: jsonBody, truncatePrefix: 0, completionHandlerForAllTasks: { (result, error) in
                    if error != nil {
                        print(error?.localizedDescription)
                    }
                    else {
                        print(result)
                    }
                })
            }
        }
        
    }
    
    func doReplacePin(){
        let url = Client.URLFromParameters(Client.Constants.Parse.Scheme, Client.Constants.Parse.Host, Client.Constants.Parse.Path, withPathExtension: Client.Constants.Methods.StudentLocation + "/" + self.userPins[0].objectId! as! String, withQuery:  nil)
        
        let jsonBody = "{\"uniqueKey\": \"\(Client.Constants.UserSession.accountKey)\", \"firstName\": \"\(Client.sharedInstance().myinfo?.firstName as! String)\", \"lastName\": \"\(Client.sharedInstance().myinfo?.lastName  as! String)\",\"mapString\": \"\(Client.sharedInstance().myinfo?.mapString  as! String)\", \"mediaURL\": \"\(Client.sharedInstance().myinfo?.mediaURL  as! String)\",\"latitude\": \(Client.sharedInstance().myinfo?.latitude as! Double), \"longitude\": \(Client.sharedInstance().myinfo?.longitude as! Double)}"
        
        Client.sharedInstance().doAllTasks(url: url, task: "PUT", jsonBody: jsonBody, truncatePrefix: 0, completionHandlerForAllTasks:  { (result, error) in
            if error != nil {
                print(error)
            }
            print(result)
            
        })
    }
    
    func doSetPin(_ replacePin: Bool) {
        if locationLabel.text != "Peanut Butter Jelly Time" {
            let alert = UIAlertController(title: "You're on the Map!!", message: "Share a link!", preferredStyle: .alert)
            
            // Submit button
            let submitAction = UIAlertAction(title: "Submit", style: .default, handler: { (action) -> Void in
              
                // Get 1st TextField's text
                Client.sharedInstance().myinfo?.mediaURL = alert.textFields![0].text
                Client.sharedInstance().myinfo?.createdAt = NSDate(timeIntervalSinceNow: 0)
                
                if replacePin {
                    self.doReplacePin()
               
                } else {
                    
                    let url = self.urlParse
                    
                    let jsonBody = "{\"uniqueKey\": \"\(Client.Constants.UserSession.accountKey)\", \"firstName\": \"\(Client.sharedInstance().myinfo?.firstName as! String)\", \"lastName\": \"\(Client.sharedInstance().myinfo?.lastName  as! String)\",\"mapString\": \"\(Client.sharedInstance().myinfo?.mapString  as! String)\", \"mediaURL\": \"\(Client.sharedInstance().myinfo?.mediaURL  as! String)\",\"latitude\": \(Client.sharedInstance().myinfo?.latitude as! Double), \"longitude\": \(Client.sharedInstance().myinfo?.longitude as! Double)}"
                    
                    Client.sharedInstance().doAllTasks(url: url, task: "POST", jsonBody: jsonBody, truncatePrefix: 0, completionHandlerForAllTasks:{ (results, error) in
                        
                        // Send values to completion handler
                        if let error = error {
                            print(error)
                       
                        } else {
                            print(results)
                        }
                        
                    }) // end completionHandlerForPost
                }
                self.dismiss(animated: true, completion: nil)
            })
           
            // Cancel button
            let cancel = UIAlertAction(title: "Cancel", style: .destructive, handler: { (action) -> Void in
                
            })
            
            alert.addTextField { (textField) in
                textField.keyboardAppearance = .light
                textField.keyboardType = .default
                textField.autocorrectionType = .no
                textField.placeholder = "Enter a Link"
            }
            
            alert.addAction(submitAction)
            alert.addAction(cancel)
            present(alert, animated: true, completion: nil)
        
        } else {
            let alert = UIAlertController(title: "You're Not on the Map!!", message: "Tell us your location!", preferredStyle: .alert)
            
            // Cancel button
            let cancel = UIAlertAction(title: "Okay", style: .default, handler: { (action) -> Void in })
            alert.addAction(cancel)
            present(alert, animated: true, completion: nil)
        }

    }
    
    func doSubmitLocation(_ userPin: Bool){
       
        if userPinExists {
            
            let alert = UIAlertController(title: "Would you like to overwrite your previously posted location?", message: "This cannot be undone.", preferredStyle: .alert)
           
            let noAction = UIAlertAction(title: "Nope", style: .default, handler: { (action) in
                self.dismiss(animated: true, completion: nil)
            })
            
            let overwriteAction = UIAlertAction(title: "Overwrite", style: .destructive, handler: { (action) in
                //self.destroyPins()
                self.doSetPin(true)
            })
           
            alert.addAction(noAction)
            alert.addAction(overwriteAction)
            present(alert, animated: true, completion: nil)
        
        } else {
            doSetPin(false)
        }
        
    }

    
    // MARK: Buttons
    
    @IBAction func doDoneButton(_ sender: Any) {
        //stop updating location
        self.locationManager.stopUpdatingLocation()
        
        
        doSubmitLocation(userPinExists)
        
        
    }
    
    @IBAction func doSearchByText(_ sender: Any) {
        // if there are any annotations remove them
        if CLLocationManager.locationServicesEnabled() {
            mapView.showsUserLocation = false
        }
        removePins()
        showSearchBar()
    }
    
    @IBAction func doFindLocation(_ sender: Any) {
        // if there are any annotations remove them
        removePins()
        self.locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            self.locationManager.delegate = self
            self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
            self.locationManager.startUpdatingLocation()
            print(self.locationManager.location.debugDescription)
            mapView.showsUserLocation = true
     
        }
    }

    @IBAction func doCancelButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
}
