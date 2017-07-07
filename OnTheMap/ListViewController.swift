//
//  ListViewController.swift
//  OnTheMap
//
//  Created by JacobRakidzich on 7/6/17.
//  Copyright © 2017 Jacob Rakidzich. All rights reserved.
//

import UIKit

class ListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    // outlet for table
    @IBOutlet weak var tableView: UITableView!
    // array of results
    var locations = Client.sharedInstance().locations
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
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
            if (toOpen.range(of: "://") != nil){
                app.open(URL(string: toOpen)!, options: [:] , completionHandler: nil)
            } else {
                app.open(URL(string: "http://\(toOpen)")!, options: [:] , completionHandler: nil)
            }
        }

    }
    
    @IBAction func doAddLocation(_ sender: Any) {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let vc: AddAnnotationViewController = storyBoard.instantiateViewController(withIdentifier: "AddAnnotation") as! AddAnnotationViewController
        present(vc , animated: true, completion: nil)
    }
    
    @IBAction func doReload(_ sender: Any) {
        Client.sharedInstance().getLocations()
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
        
    }

    
    
}
