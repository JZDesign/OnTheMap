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
    
    var userPinExists = false
    var userPins = [StudentLocation]()
    
    
    let urlParse = Client.URLFromParameters(Client.Constants.Parse.Scheme, Client.Constants.Parse.Host, Client.Constants.Parse.Path, withPathExtension: Client.Constants.Methods.StudentLocation)
    
    @IBOutlet var shareButton: UIBarButtonItem!
    @IBOutlet var findLocationView: UIView!
    @IBOutlet var searchByTextButton: UIBarButtonItem!
    @IBOutlet var mapView: MKMapView!
    
    // location manager to find user location
    var locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        findUserAnnotation()
    

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
            //self.latitude = (self.pinAnnotationView.annotation?.coordinate.latitude)!
            //self.longitude = (self.pinAnnotationView.annotation?.coordinate.longitude)!
            Client.sharedInstance().myinfo?.mapString = searchBar.text
            self.mapView.addAnnotation(self.pinAnnotationView.annotation!)
        }
    }
    
    
    // MARK: Post
    
    func findUserAnnotation() {
        // method to locate any annotations by a given uniqueKey and delete them
        let url = URL(string:"https://parse.udacity.com/parse/classes/StudentLocation?where=%7B%22uniqueKey%22%3A%22\(Client.Constants.UserSession.accountKey )%22%7D")
        let jsonBody = "where:{\"uniqueKey\":\"\(Client.Constants.UserSession.accountKey as! String)\"}"
        Client.sharedInstance().taskForGETMethod(url!, jsonBody: "", truncatePrefix: 0) { (result, error) in
            if error != nil {
                print(error)
            }
            print("######### FIND USER ###### \(result?["results"])")
            /*if let userPins = result?["results"] as? [[String:AnyObject]]{
                for pin in userPins {
                    let item = StudentLocation.init(objectId: pin["objectId"] as! String, uniqueKey: pin["uniqueKey"] as! String, firstName: pin["firstName"] as! String, lastName: pin["lastName"] as! String, mapString: pin["mapString"] as! String, mediaURL: pin["mediaURL"] as! String, latitude: pin["latitude"] as! Double, longitude: pin["longitude"] as! Double, createdAt: NSDate(timeIntervalSinceNow: 0))
                    self.userPins?.append(item)
                }
            }*/
            let locationsDict = result?["results"] as! [[String : Any]]
            for item in locationsDict {
                let newLocation = StudentLocation(studentLocation: item)
                //print(item)
                self.userPins.append(newLocation)
            }

            if self.userPins.count > 0 {
                self.userPinExists = true
            }
        }
    }
    
    
    
    // MARK: PIN GET SET DESTROY REPLACE
    
    // DESTROY PINS FUNCTION TO DELETE USER PINS IN MULTIPLES.
    func destroyPins() {
        //
        
        for item in userPins {
            let string = item.uniqueKey!
            let url = URL(string:"https://parse.udacity.com/parse/users/\(string)")
            let jsonBody = ""
            Client.sharedInstance().taskForDelete(url: url!, jsonBody: jsonBody, completionHandlerForDelete: { (result, error) in
                if error != nil {
                    print(error?.localizedDescription)
                }
                else {
                    print(result)
                }
            })
        }
        
    }
    
    func doReplacePin(){
        let url = URL(string: "https://parse.udacity.com/parse/classes/StudentLocation/\(self.userPins[0].objectId as! String)")
        let jsonBody = "{\"uniqueKey\": \"\(Client.Constants.UserSession.accountKey)\", \"firstName\": \"\(Client.sharedInstance().myinfo?.firstName as! String)\", \"lastName\": \"\(Client.sharedInstance().myinfo?.lastName  as! String)\",\"mapString\": \"\(Client.sharedInstance().myinfo?.mapString  as! String)\", \"mediaURL\": \"\(Client.sharedInstance().myinfo?.mediaURL  as! String)\",\"latitude\": \(Client.sharedInstance().myinfo?.latitude as! Double), \"longitude\": \(Client.sharedInstance().myinfo?.longitude as! Double)}"
        Client.sharedInstance().taskForPut(url: url!, jsonBody: jsonBody, completionHandlerForPut:  { (result, error) in
            if error != nil {
                print(error)
            }
            print(result)
        })
    }
    
    func doSetPin(_ replacePin: Bool) {
        if latitude != 0.0 && longitude != 0.0 {
            let alert = UIAlertController(title: "You're on the Map!!",
                                          message: "Share a link!",
                                          preferredStyle: .alert)
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
                    
                    
                    Client.sharedInstance().taskForPostMethod(url: url, jsonBody: jsonBody, truncatePrefix: 0, completionHandlerForPost:{ (results, error) in
                        
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
    
    func doSubmitLocation(_ userPin: Bool){
        if userPinExists {
            let alert = UIAlertController(title: "Would you like to overwrite your previously posted location?", message: "NOTE: It may take a minute for the server to update", preferredStyle: .alert)
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
        // store lat long data
        if annotation?.coordinate.latitude != nil {
            latitude = annotation.coordinate.latitude
            longitude = annotation.coordinate.longitude
            Client.sharedInstance().myinfo?.latitude = latitude
            Client.sharedInstance().myinfo?.longitude = longitude
        }
        
        doSubmitLocation(userPinExists)
        
        
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
            print(self.locationManager.location.debugDescription)
            mapView.showsUserLocation = true
            
            
        }
        
        
        
    }

    
}
