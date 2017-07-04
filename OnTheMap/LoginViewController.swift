//
//  LoginViewController.swift
//  OnTheMap
//
//  Created by JacobRakidzich on 7/2/17.
//  Copyright © 2017 Jacob Rakidzich. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    @IBOutlet var userIDTextField: UITextField!
    @IBOutlet var passwordTextField: UITextField!
    var session = URLSession.shared

    override func viewDidLoad() {
        
        super.viewDidLoad()

        //let student = StudentLocation.init(objectId: "", uniqueKey: Client.Constants.UserSession.accountKey, firstName: "Jacob", lastName: "Rakidzich", mapString: "Delavan, WI 53115", mediaURL: "https//Udacity.com", latitude: 42.6331, longitude: -88.6437, createdAt: NSDate.init(timeIntervalSinceNow: 0)    )
        //print(student.firstName!,student.lastName!,student.mapString!)
        
    }
   
    
  
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    private func getRequestToken(_ completionHandlerForToken: @escaping (_ success: Bool, _ requestToken: String?, _ errorString: String?) -> Void) {
        
        /* 1. Specify parameters, the API method, and the HTTP body (if POST) */
        let parameters = [String:AnyObject]()
        taskForGETMethod(Client.Constants.Methods.Session, parameters: parameters) { (results, error) in
            if let error = error {
                print(error)
                completionHandlerForToken(false, nil, "Failed to get token")
            } else {
                if let token = results?[TMDBClient.JSONResponseKeys.RequestToken] as? String {
                    print(token,TMDBClient.JSONResponseKeys.RequestToken)
                    completionHandlerForToken(true, token, nil)
                } else {
                    print("Could not find Request token in '\(results)'")
                    completionHandlerForToken(false,nil,"Failed to find token")
                }
                
            }
        }
        
    }
 */
    
    
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    @IBAction func doLogInButton(_ sender: Any) {
        
        // set parameters
        let parameters = [String:AnyObject]()
        
        // url with Method
        let url = Client.udacityURLFromParameters(parameters, withPathExtension: Client.Constants.Methods.Session)
        
        // json for log in credentials pulling from text fields.
        let jsonBody = "{\"\(Client.Constants.LoginKeys.Udacity)\": {\"\(Client.Constants.LoginKeys.Username)\":\"\(userIDTextField.text as! String)\", \"\(Client.Constants.LoginKeys.Password)\":\"\(passwordTextField.text as! String)\"}}"
        
        // call task for post with url and jsonBody to get the log in results.
        Client.sharedInstance().taskForPostMethod(url: url, jsonBody: jsonBody, truncatePrefix: 5, completionHandlerForPost:{ (results, error) in
            
            // Send values to completion handler
            if let error = error {
                print(error)
            } else {
                if let accountID = results? [Client.Constants.LoginResponseKeys.AccountID]  as? [String:AnyObject] {
                    Client.Constants.UserSession.accountKey = accountID[Client.Constants.LoginResponseKeys.Key] as! String
                } else {
                    print("Failed to get account key")
                }
                if let sessionID = results? [Client.Constants.LoginResponseKeys.SessionID] as? [String:AnyObject] {
                    Client.Constants.UserSession.sessionID = sessionID[Client.Constants.LoginResponseKeys.ID] as! String
                } else {
                    print("Failed to get session ID")
                }
            }
            print(Client.Constants.UserSession.accountKey,  Client.Constants.UserSession.sessionID)
            
            // try to get locations 
            // WORKING
            // let students = StudentLocation.downloadJSON()
            // print(students)
            
            self.getMyUser()
            
            /*
                // post location test 
             // WORKING
            let url2 = URL(string: "https://parse.udacity.com/parse/classes/StudentLocation")
            let jsonBody2 = "{\"uniqueKey\": \"\(Client.Constants.UserSession.accountKey)\", \"firstName\": \"John\", \"lastName\": \"Doe\",\"mapString\": \"Mountain View, CA\", \"mediaURL\": \"https://udacity.com\",\"latitude\": 37.386052, \"longitude\": -122.083851}"
            Client.sharedInstance().taskForPostMethod(url: url2!, jsonBody: jsonBody2, truncatePrefix: 0, completionHandlerForPost:{ (results, error) in
                
                // Send values to completion handler
                if let error = error {
                    print(error)
                } else {
                    print(results)
                }

            }) // end completionHandlerForPost
             // end post location test   
             */
            
        }) // end completionHandlerForPost
        
    }
    
    func getMyUser() {
        let url3 = URL(string: "https://www.udacity.com/api/users/\(Client.Constants.UserSession.accountKey as! String)/account")
        print(url3)
        //let jsonBody3 = "{\"\(Client.Constants.UserSession.accountKey)\"}"
        Client.sharedInstance().taskForGETMethod(url3!, jsonBody: "", truncatePrefix: 0, completionHandlerForGET:  {(results, error) in
            if let error = error {
                print(error)
            } else {
                print(results)
            }
            
        })

    }

}
