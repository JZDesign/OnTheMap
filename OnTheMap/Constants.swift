//
//  Constants.swift
//  OnTheMap
//
//  Created by JacobRakidzich on 7/2/17.
//  Copyright © 2017 Jacob Rakidzich. All rights reserved.
//


// MARK: - Constants
extension Client {
    
    struct Constants {
        
        //MARK: UDACITY
        struct Udacity {
            static let Scheme = "https"
            static let Host = "www.udacity.com"
            static let Path = "/api"
            static let UserPath = "/users/"
        }
        
        //MARK: PARSE
        
        struct Parse {
            static let Scheme = "https"
            static let Host = "parse.udacity.com"
            static let Path = "/parse/classes"
            static let UsersPath = "/parse/users/"
            static let UniqueKey = "uniqueKey"
            static let FirstName = "firstName"
            static let LastName = "lastName"
            static let MapString = "mapString"
            static let MediaURL = "mediaURL"
            static let Latitude = "latitude"
            static let Longitude = "longitude"
        }
        
        //MARK: PARAMETER KEYS
        struct ParameterKeys {
            static let Method = "method"
            static let APIKey = "api_key"
        }
        
        // MARK: VALUES

        struct ParameterValues {
            static let SearchMethod = "search"
            static let APIKey = "QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY"
            static let ParseAppID = "QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr"
        }

        struct Methods {
            static let Session = "/session"
            static let StudentLocation = "/StudentLocation"
            static let StudentInfo = "/users/"
        }
        
        struct LoginKeys {
            static let Udacity = "udacity"
            static let Username = "username"
            static let Password = "password"
        }
        
        struct LoginResponseKeys {
       
            // MARK: Account
            static let AccountID = "account"
            static let Registered = "registered"
            static let Key = "key"
            
            // MARK: Facebook
            
            static let FBUserId = "userId"
            static let FBAuthToken = "access_token"
            static let FBMobile = "facebook_mobile"
            
            
            // MARK: Session
            static let SessionID = "session"
            static let ID = "id"
            static let Expiration = "expiration"
            
        }
        
        //MARK: USER SESSION
        
        struct UserSession {
            static var accountKey = ""
            static var sessionID = ""
            static var sessionExpires = ""
            
            // fb
            
            static var userId = ""
            static var fbAuthToken = ""
            
        }
        
        
    }
}
