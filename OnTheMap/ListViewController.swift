//
//  ListViewController.swift
//  OnTheMap
//
//  Created by JacobRakidzich on 7/6/17.
//  Copyright © 2017 Jacob Rakidzich. All rights reserved.
//

import UIKit

class ListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    // placeholder for locations for table
    var locations = [StudentLocation]()
    // outlet for table
    @IBOutlet weak var tableView: UITableView!
    // array of results
    override func viewDidLoad() {
        locations = Client.sharedInstance().locations
    }
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        // set table limits
        return locations.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        
        
        // set reuse cell
        let CellID = "Locations"
        let placeholderCell = tableView.dequeueReusableCell(withIdentifier: CellID, for: indexPath)
        //read data in from struct objects
        placeholderCell.textLabel?.text = "\(locations[indexPath.row].firstName!) \(locations[indexPath.row].lastName!)"
        placeholderCell.detailTextLabel?.text? = "\(locations[indexPath.row].mediaURL!)"
        // display cell info
        return placeholderCell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let app = UIApplication.shared
        if let toOpen = tableView.cellForRow(at: indexPath)?.detailTextLabel?.text! {
            // set prefix to aid safari
            if (toOpen.range(of: "://") != nil){
                app.open(URL(string: toOpen)!, options: [:] , completionHandler: nil)
            } else {
                app.open(URL(string: "http://\(toOpen)")!, options: [:] , completionHandler: nil)
            }
        }

    }
    
    // MARK: BUTTONS
    // logout
    @IBAction func doLogOut(_ sender: Any) {
        Client.sharedInstance().logOut { (error) in
            if error != nil {
                self.doFailedAlert("Logout Failed",error!)
            } else {
                DispatchQueue.main.async {
                    self.dismiss(animated: true, completion: nil)
                }
            }
        }
    }

    // call AddAnnotationVC
    @IBAction func doAddLocation(_ sender: Any) {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let vc: AddAnnotationViewController = storyBoard.instantiateViewController(withIdentifier: "AddAnnotation") as! AddAnnotationViewController
        present(vc , animated: true, completion: nil)
    }
    
    
    // reload tableview
    @IBAction func doReload(_ sender: Any) {
        // display indicator
        let ai = ActivityIndicator(text:"Loading")
        self.view.addSubview(ai)
        ai.show()
        
        //reset data
        self.locations = []
        tableView.reloadData()
        Client.sharedInstance().locations.removeAll()
        Client.sharedInstance().getLocations{ (downloadError) in
            if downloadError != nil {
                self.doFailedAlert("Download Failed!",downloadError!)
                ai.hide()
            } else {
                // call on main to update UI
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
                    self.locations = Client.sharedInstance().locations
                    self.tableView.reloadData()
                    ai.hide()
                })
            }
        }
        
    }
    
    //MARK: ALERT

    func doFailedAlert(_ message: String, _ error: NSError) {
        let alert = UIAlertController(title: message, message: "\(error.localizedDescription)", preferredStyle: .alert)
        let action = UIAlertAction(title: "Crap Nuggets!", style: .destructive, handler: nil)
        alert.addAction(action)
        self.present(alert, animated: true)
    }

    
    
}
