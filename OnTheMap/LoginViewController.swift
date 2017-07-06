//
//  LoginViewController.swift
//  OnTheMap
//
//  Created by JacobRakidzich on 7/2/17.
//  Copyright © 2017 Jacob Rakidzich. All rights reserved.
//

import UIKit
import FacebookLogin
import FacebookCore

class LoginViewController: UIViewController, LoginButtonDelegate {
    @IBOutlet var userIDTextField: UITextField!
    @IBOutlet var passwordTextField: UITextField!
    var session = URLSession.shared
    
    

    // MARK: LIFECYLE
    
    override func viewDidLoad() {
        
        super.viewDidLoad()

        
        // get locations
        Client.sharedInstance().getLocations()
        
        // Facebook
        // set requested permissions
        let loginButton = LoginButton(readPermissions: [ .publicProfile ])
        // set delegate
        loginButton.delegate = self
        //center near bottom
        loginButton.center = CGPoint(x: view.bounds.width / 2, y: view.bounds.height - loginButton.bounds.height * 2)
        // display button
        view.addSubview(loginButton)
        
        checkFB()
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    // MARK: Facebook Helper
    
    func checkFB() {
        if let token = FBSDKAccessToken.current() {
            
            // TODO:
            //fetchProfile()
            
            
            let url = URL(string: "https://www.udacity.com/api/session")
            
            let jsonBody = Client.sharedInstance().makeJSON([ Client.Constants.LoginResponseKeys.FBMobile : [ Client.Constants.LoginResponseKeys.FBAuthToken: FBSDKAccessToken.current().tokenString as AnyObject]] as [String:[String:AnyObject]] )
            
            
            Client.sharedInstance().taskForPostMethod(url: url!, jsonBody: jsonBody, truncatePrefix: 5, completionHandlerForPost: { (result, error) in
                if error != nil {
                    print(error)
                }
                self.getKey(result as! [String : AnyObject])
                self.getMyUser()
            })
        }

    }
    
    // MARK: Facebook Delegate
    
    func loginButtonDidCompleteLogin(_ loginButton: LoginButton, result: LoginResult) {
        //getMyUser()
        print(result)
        print("Token:", FBSDKAccessToken.current().tokenString)
        checkFB()
    }
    
    func loginButtonDidLogOut(_ loginButton: LoginButton) {
        // todo
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
    
    // MARK: Buttons
    
    @IBAction func doSignUp(_ sender: Any) {
        if let url = URL(string: "https://auth.udacity.com/sign-up?next=https%3A%2F%2Fclassroom.udacity.com%2Fauthenticated"){
            UIApplication.shared.openURL(url)
        }
    }
    
    
    
    @IBAction func doLogInButton(_ sender: Any) {
        
        // set parameters
        let parameters = [String:AnyObject]()
        
        // url with Method
        let url = Client.udacityURLFromParameters(parameters, withPathExtension: Client.Constants.Methods.Session)
        
        // json for log in credentials pulling from text fields.
        let jsonBody = "{\"\(Client.Constants.LoginKeys.Udacity)\": {\"\(Client.Constants.LoginKeys.Username)\":\"\(userIDTextField.text as! String)\", \"\(Client.Constants.LoginKeys.Password)\":\"\(passwordTextField.text as! String)\"}}"
        //let jsonBody = Client.sharedInstance().makeJSON([ Client.Constants.LoginKeys.Udacity : [ Client.Constants.LoginKeys.Username: userIDTextField.text as AnyObject] [Client.Constants.LoginKeys.Password : ]] as [String:[String:AnyObject]] )

        // call task for post with url and jsonBody to get the log in results.
        Client.sharedInstance().taskForPostMethod(url: url, jsonBody: jsonBody, truncatePrefix: 5, completionHandlerForPost:{ (results, error) in
            
            // Send values to completion handler
            if let error = error {
                print(error)
            } else {
                self.getKey(results as! [String : AnyObject])
            }
            print(Client.Constants.UserSession.accountKey,  Client.Constants.UserSession.sessionID)
            
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
    
    func getKey(_ results: [String:AnyObject] ) {
        if let accountID = results[Client.Constants.LoginResponseKeys.AccountID]  as? [String:AnyObject] {
            Client.Constants.UserSession.accountKey = accountID[Client.Constants.LoginResponseKeys.Key] as! String
        } else {
            print("Failed to get account key")
        }
        if let sessionID = results[Client.Constants.LoginResponseKeys.SessionID] as? [String:AnyObject] {
            Client.Constants.UserSession.sessionID = sessionID[Client.Constants.LoginResponseKeys.ID] as! String
        } else {
            print("Failed to get session ID")
        }
    }
    
    func getMyUser() {
        let url = URL(string: "https://www.udacity.com/api/users/\(Client.Constants.UserSession.accountKey as! String)")
        Client.sharedInstance().taskForGETMethod(url!, jsonBody: "", truncatePrefix: 5, completionHandlerForGET:  {(results, error) in
            if let error = error {
                print(error)
            } else {
                let user = results?["user"] as! [String : Any]
                var myUser = StudentLocation.init(objectId: "", uniqueKey: user["key"] as! String, firstName: user["first_name"] as! String, lastName: user["last_name"] as! String, mapString: "", mediaURL: "", latitude: 0, longitude: 0, createdAt: NSDate.init(timeIntervalSinceNow: 0))
                print(myUser.firstName,myUser.lastName,myUser.uniqueKey)
            }
            
        })

    }

}
