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
   
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        // set table limits
        return StudentDataSource.sharedInstance.studentData.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        
        
        // set reuse cell
        let CellID = "Locations"
        let placeholderCell = tableView.dequeueReusableCell(withIdentifier: CellID, for: indexPath)
        //read data in from struct objects
        if let first = StudentDataSource.sharedInstance.studentData[indexPath.row].firstName as? String, let last = StudentDataSource.sharedInstance.studentData[indexPath.row].lastName as? String, let mediaURL = StudentDataSource.sharedInstance.studentData[indexPath.row].mediaURL as? String {
            
            placeholderCell.textLabel?.text = "\(first as! String) \(last as! String)"
            placeholderCell.detailTextLabel?.text? = "\(mediaURL as! String)"
            
        } else {
            // don't display bad data
            // size of these cells will be set to 0
            placeholderCell.textLabel?.text? = "Pin stored nil values"
            
        }
        // display cell info
        return placeholderCell
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if let first = StudentDataSource.sharedInstance.studentData[indexPath.row].firstName as? String, let last = StudentDataSource.sharedInstance.studentData[indexPath.row].lastName as? String, let mediaURL = StudentDataSource.sharedInstance.studentData[indexPath.row].mediaURL as? String {
            // set height to display row
            return 50.0
            
        } else {
            // don't display bad data
            return 0.0
            
        }

    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let app = UIApplication.shared
        if let toOpen = tableView.cellForRow(at: indexPath)?.detailTextLabel?.text! {
            // mutable object to edit value
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
        StudentDataSource.sharedInstance.studentData.removeAll()  
        Client.sharedInstance().getLocations{ (downloadError) in
            if downloadError != nil {
                self.doFailedAlert("Download Failed!",downloadError!)
                ai.hide()
            } else {
                // call on main to update UI
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                    ai.hide()
                }
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
