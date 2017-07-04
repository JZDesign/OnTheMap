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
        }
        
        //MARK: PARSE
        
        struct Parse {
            static let Scheme = "https"
            static let Host = "parse.udacity.com"
            static let Path = "/parse/classes"
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
            static let ParseAppID = "gallery_id"
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
            
        }
        
        
        /*
        // MARK: Flickr
        struct Flickr {
            static let APIScheme = "https"
            static let APIHost = "api.flickr.com"
            static let APIPath = "/services/rest"
            
            static let SearchBBoxHalfWidth = 1.0
            static let SearchBBoxHalfHeight = 1.0
            static let SearchLatRange = (-90.0, 90.0)
            static let SearchLonRange = (-180.0, 180.0)
        }
        
        // MARK: Flickr Parameter Keys
        struct FlickrParameterKeys {
            static let Method = "method"
            static let APIKey = "api_key"
            static let GalleryID = "gallery_id"
            static let Extras = "extras"
            static let Format = "format"
            static let NoJSONCallback = "nojsoncallback"
            static let SafeSearch = "safe_search"
            static let Text = "text"
            static let BoundingBox = "bbox"
            static let Page = "page"
        }
        
        // MARK: Flickr Parameter Values
        struct FlickrParameterValues {
            static let SearchMethod = "flickr.photos.search"
            static let APIKey = "YOUR KEY HERE"
            static let ResponseFormat = "json"
            static let DisableJSONCallback = "1" /* 1 means "yes" */
            static let GalleryPhotosMethod = "flickr.galleries.getPhotos"
            static let GalleryID = "5704-72157622566655097"
            static let MediumURL = "url_m"
            static let UseSafeSearch = "1"
        }
        
        // MARK: Flickr Response Keys
        struct FlickrResponseKeys {
            static let Status = "stat"
            static let Photos = "photos"
            static let Photo = "photo"
            static let Title = "title"
            static let MediumURL = "url_m"
            static let Pages = "pages"
            static let Total = "total"
        }
        
        // MARK: Flickr Response Values
        struct FlickrResponseValues {
            static let OKStatus = "ok"
        }
     */
        
        
    }
}
