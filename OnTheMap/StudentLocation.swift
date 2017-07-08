//
//  StudentLocation.swift
//  OnTheMap
//
//  Created by JacobRakidzich on 7/2/17.
//  Copyright © 2017 Jacob Rakidzich. All rights reserved.
//

import Foundation
class StudentLocation {
    
    
   
    
    // Student Location attributes
    
    var objectId: String?
    var uniqueKey: String?
    var firstName: String?
    var lastName: String?
    var mapString: String?
    var mediaURL: String?
    var latitude: Double?
    var longitude: Double?
    var createdAt: NSDate?
    //var ACL
    
    
    //initialize
    
    init(objectId: String, uniqueKey: String, firstName: String, lastName: String, mapString: String, mediaURL: String, latitude: Double, longitude: Double, createdAt: NSDate) {
        self.objectId = objectId
        self.uniqueKey = uniqueKey
        self.firstName = firstName
        self.lastName = lastName
        self.mapString = mapString
        self.mediaURL = mediaURL
        self.latitude = latitude
        self.longitude = longitude
        self.createdAt = createdAt
        
    }
    
    init(studentLocation: [String: Any]) {
        self.objectId = studentLocation["objectId"] as? String
        self.uniqueKey = studentLocation["key"] as? String
        self.firstName = studentLocation["firstName"] as? String
        self.lastName = studentLocation["lastName"] as? String
        self.mapString = studentLocation["mapString"] as? String
        self.mediaURL = studentLocation["mediaURL"] as? String
        self.latitude = studentLocation["latitude"] as? Double
        self.longitude = studentLocation["longitude"] as? Double
        self.createdAt = studentLocation["createdAt"] as? NSDate
    }
    
    // get data
    
    static func downloadJSON(_ completion:  @escaping (_ result: AnyObject?, _ error: NSError?) -> Void ) -> URLSessionDataTask
    {
        let url = Client.URLFromParameters(Client.Constants.Parse.Scheme, Client.Constants.Parse.Host, Client.Constants.Parse.Path, withPathExtension: Client.Constants.Methods.StudentLocation)
            
        return Client.sharedInstance().doAllTasks(url: url, task: "GET", jsonBody: "", truncatePrefix: 0, completionHandlerForAllTasks:  completion)
        
    }
    
}

