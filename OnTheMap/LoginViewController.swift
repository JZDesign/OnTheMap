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
    let urlUdacity = Client.URLFromParameters(Client.Constants.Udacity.Scheme, Client.Constants.Udacity.Host, Client.Constants.Udacity.Path, withPathExtension: Client.Constants.Methods.Session)
    

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
    
    
    // MARK: SEGUE
    
    func doSegue() {
        // Run on main queue to avoid crashing app by calling segue in background
        DispatchQueue.main.async {
            self.performSegue(withIdentifier: "DidLogIn", sender: self)
        }
        
    
        
    }
    
    
    // MARK: Facebook Helper
    
    func checkFB() {
        if let token = FBSDKAccessToken.current() {
            
            let jsonBody = Client.sharedInstance().makeJSON([ Client.Constants.LoginResponseKeys.FBMobile : [ Client.Constants.LoginResponseKeys.FBAuthToken: FBSDKAccessToken.current().tokenString as AnyObject]] as [String:[String:AnyObject]] )
            
            Client.sharedInstance().doAllTasks(url: urlUdacity, task: "POST", jsonBody: jsonBody, truncatePrefix: 5, completionHandlerForAllTasks: { (result, error) in
            
                if error != nil {
                    print(error)
                }
                self.getKey(result as! [String : AnyObject])
                Client.sharedInstance().getMyUser()
                
                self.doSegue()

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

    
    // MARK: Buttons
    
    @IBAction func doSignUp(_ sender: Any) {
        if let url = URL(string: "https://auth.udacity.com/sign-up?next=https%3A%2F%2Fclassroom.udacity.com%2Fauthenticated"){
            UIApplication.shared.openURL(url)
        }
    }
    
    
    
    @IBAction func doLogInButton(_ sender: Any) {
        // set parameters
        let parameters = [String:AnyObject]()
        
        // json for log in credentials pulling from text fields.
        let jsonBody = "{\"\(Client.Constants.LoginKeys.Udacity)\": {\"\(Client.Constants.LoginKeys.Username)\":\"\(userIDTextField.text as! String)\", \"\(Client.Constants.LoginKeys.Password)\":\"\(passwordTextField.text as! String)\"}}"
        
        // call task for post with url and jsonBody to get the log in results.
        Client.sharedInstance().doAllTasks(url: urlUdacity,task: "POST", jsonBody: jsonBody, truncatePrefix: 5, completionHandlerForAllTasks:{ (results, error) in
            // Send values to completion handler
            if let error = error {
                print(error)
            } else {
                self.getKey(results as! [String : AnyObject])
            }
            print(Client.Constants.UserSession.accountKey,  Client.Constants.UserSession.sessionID)
            
            Client.sharedInstance().getMyUser()
            
            self.doSegue()
                       
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
    
}
