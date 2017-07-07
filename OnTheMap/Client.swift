//
//  Client.swift
//  OnTheMap
//
//  Created by JacobRakidzich on 7/2/17.
//  Copyright © 2017 Jacob Rakidzich. All rights reserved.
//

import Foundation

class Client: NSObject {
    // MARK: Properties
    
    // shared session
    var session = URLSession.shared
    
    // configuration object
    //var config = TMDBConfig()
    
    // authentication state
    var requestToken: String? = nil
    var sessionID : String? = nil
    var userID : Int? = nil
    
    // locations
    var locations = [StudentLocation]()
    var myinfo: StudentLocation? = nil
    
    // MARK: Initializers
    
    override init() {
        super.init()
    }
    
    
    
    
    
    
    // MARK: MAKE JSON
    func makeJSON(_ jsonBody: [String:[String:AnyObject]]) -> String {
        
        let json = try? JSONSerialization.data(withJSONObject: jsonBody, options: .prettyPrinted)
        let dataString = NSString(data: json!, encoding: String.Encoding.utf8.rawValue)
        return dataString as! String
    }
    
    
    
    
    
    
    
    // MARK: GET
    
    func taskForGETMethod(_ url: URL, jsonBody: String, truncatePrefix: Int, completionHandlerForGET: @escaping (_ result: AnyObject?, _ error: NSError?) -> Void) -> URLSessionDataTask {
        //let request = NSMutableURLRequest(url: URL(string: "https://parse.udacity.com/parse/classes/StudentLocation")!)
        
        let request = NSMutableURLRequest(url: url)
        request.httpMethod = "GET"
        let urlstring = url.absoluteString
        if (urlstring.range(of: "api.udacity") != nil)   {
            // if loging in
            request.addValue("application/json", forHTTPHeaderField: "Accept")
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.httpBody = jsonBody.data(using: String.Encoding.utf8)
            
        } else {
            // if requesting to post data to the parse api
            
            request.addValue(Client.Constants.ParameterValues.ParseAppID, forHTTPHeaderField: "X-Parse-Application-Id")
            request.addValue(Client.Constants.ParameterValues.ParseAppID, forHTTPHeaderField: "X-Parse-REST-API-Key")
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            
            request.httpBody = jsonBody.data(using: String.Encoding.utf8)
            
        }
        
        return doRequestWithCompletion(request, truncatePrefix: truncatePrefix, completion: completionHandlerForGET)

    }
    
    // MARK:  POST
    
    // method takes url, jsonBody, truncatePrefix, and a completion handler as parameters
    // url - prebuilt before passing in based on method being performed,
    // jsonBody - prebuilt before passing in based on method being performed,
    // truncatePrefix - Used to remove the first x characters in the data in the doRequestWithCompletion method
    //  -> truncatePrefix used for the Udacity Log in with a value of 5 to pass their security technique
    // completion handler to handle the result or error via passthroughs.
    func taskForPostMethod(url: URL, jsonBody: String, truncatePrefix: Int, completionHandlerForPost: @escaping (_ result: AnyObject?, _ error: NSError?) -> Void) -> URLSessionDataTask {
        
        let request = NSMutableURLRequest(url: url)
        request.httpMethod = "POST"
        let urlstring = url.absoluteString
        if (urlstring.range(of: "api.udacity") != nil)   {
            // if loging in
            request.addValue("application/json", forHTTPHeaderField: "Accept")
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.httpBody = jsonBody.data(using: String.Encoding.utf8)
            
        } else {
            // if requesting to post data to the parse api
            request.addValue(Client.Constants.ParameterValues.ParseAppID, forHTTPHeaderField: "X-Parse-Application-Id")
            request.addValue(Client.Constants.ParameterValues.ParseAppID, forHTTPHeaderField: "X-Parse-REST-API-Key")
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.httpBody = jsonBody.data(using: String.Encoding.utf8)
            
        }
        
        print(request)
        return doRequestWithCompletion(request, truncatePrefix: truncatePrefix, completion: completionHandlerForPost)
        
        
    }
    
    
    //
    
    func taskForPut(url: URL, jsonBody: String, completionHandlerForPut: @escaping (_ result: AnyObject?, _ error: NSError?) -> Void ) -> URLSessionDataTask {
        let request = NSMutableURLRequest(url: url)
        request.httpMethod = "PUT"
        request.addValue("QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr", forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue("QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY", forHTTPHeaderField: "X-Parse-REST-API-Key")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = jsonBody.data(using: String.Encoding.utf8)
        return doRequestWithCompletion(request, truncatePrefix: 0, completion: completionHandlerForPut)
    }
    
    
    func taskForDelete(url: URL, jsonBody: String, completionHandlerForDelete: @escaping (_ result: AnyObject?, _ error: NSError?) -> Void) -> URLSessionDataTask {
    
        let request = NSMutableURLRequest(url: url)
        request.httpMethod = "DELETE"
        let urlstring = url.absoluteString
        
        if (urlstring.range(of: "api.udacity") != nil)   {
            // if loging in
            request.addValue("application/json", forHTTPHeaderField: "Accept")
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            var xsrfCookie: HTTPCookie? = nil
            let sharedCookieStorage = HTTPCookieStorage.shared
            for cookie in sharedCookieStorage.cookies! {
                if cookie.name == "XSRF-TOKEN" { xsrfCookie = cookie }
            }
            if let xsrfCookie = xsrfCookie {
                request.setValue(xsrfCookie.value, forHTTPHeaderField: "X-XSRF-TOKEN")
            }
            request.httpBody = jsonBody.data(using: String.Encoding.utf8)
        
        } else {
            // if requesting to post data to the parse api
            request.addValue(Client.Constants.ParameterValues.ParseAppID, forHTTPHeaderField: "X-Parse-Application-Id")
            request.addValue(Client.Constants.ParameterValues.ParseAppID, forHTTPHeaderField: "X-Parse-REST-API-Key")
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.httpBody = jsonBody.data(using: String.Encoding.utf8)
        
        }
        
        print(request)
        return doRequestWithCompletion(request, truncatePrefix: 0, completion: completionHandlerForDelete)
    
    
    }
    
    
    
    
    
    
    // GET LOCATIONS
    
    func getLocations() {
        locations.removeAll()
        StudentLocation.downloadJSON({ (result, error) in
        let locationsDict = result?["results"] as! [[String : Any]]
        for item in locationsDict {
            let newLocation = StudentLocation(studentLocation: item)
            self.locations.append(newLocation)
            }
        
        })
    }

    
    
    
    
    
    // MARK: GET MY USER INFO
    func getMyUser() {
        let url = URL(string: "https://www.udacity.com/api/users/\(Client.Constants.UserSession.accountKey as! String)")
        Client.sharedInstance().taskForGETMethod(url!, jsonBody: "", truncatePrefix: 5, completionHandlerForGET:  {(results, error) in
            if let error = error {
                print(error)
            } else {
                let user = results?["user"] as! [String : Any]
                self.myinfo = StudentLocation.init(objectId: "", uniqueKey: user["key"] as! String, firstName: user["first_name"] as! String, lastName: user["last_name"] as! String, mapString: "", mediaURL: "", latitude: 0, longitude: 0, createdAt: NSDate.init(timeIntervalSinceNow: 0))
            }
            
        })
        
    }

    
    
    
    
    
    // MARK: Helpers
    
    // substitute the key for the value that is contained within the method name
    func substituteKeyInMethod(_ method: String, key: String, value: String) -> String? {
        if method.range(of: "{\(key)}") != nil {
            return method.replacingOccurrences(of: "{\(key)}", with: value)
        } else {
            return nil
        }
    }
    
    
    // request - prebuilt when passed in,
    // truncate prefix - remove x from the front of the data before parsing it.
    // completion handler to process result or error via passthroughs
    func doRequestWithCompletion(_ request: NSMutableURLRequest, truncatePrefix: Int, completion: @escaping (_ result: AnyObject?, _ error: NSError?) -> Void) -> URLSessionDataTask {
        /* 4. Make the request */
        let task = session.dataTask(with: request as URLRequest) { (data, response, error) in
            print(request)
            func sendError(_ error: String) {
                print(error)
                let userInfo = [NSLocalizedDescriptionKey : error]
                completion(nil, NSError(domain: "taskForGETMethod", code: 1, userInfo: userInfo))
            }
            
            /* GUARD: Was there an error? */
            guard (error == nil) else {
                sendError("There was an error with your request: \(error)")
                return
            }
            
            /* GUARD: Did we get a successful 2XX response? */
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else {
                sendError("Your request returned a status code other than 2xx! Response: \(response as? HTTPURLResponse)?.statusCode)")
                
                return
            }
            
            /* GUARD: Was there any data returned? */
            guard var data = data else {
                sendError("No data was returned by the request!")
                return
            }
            
            if truncatePrefix != 0 {
                let range = Range(truncatePrefix..<data.count)
                data = data.subdata(in: range)
            }
            
            /* 5/6. Parse the data and use the data (happens in completion handler) */
            self.convertDataWithCompletionHandler(data, completionHandlerForConvertData: completion)
        }
        
        /* 7. Start the request */
        task.resume()
        
        return task
        
    }
    
    
    
    
    // given raw JSON, return a usable Foundation object
    private func convertDataWithCompletionHandler(_ data: Data, completionHandlerForConvertData: (_ result: AnyObject?, _ error: NSError?) -> Void) {
        
        var parsedResult: AnyObject! = nil
        do {
            parsedResult = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as AnyObject
        } catch {
            let userInfo = [NSLocalizedDescriptionKey : "Could not parse the data as JSON: '\(data)'"]
            completionHandlerForConvertData(nil, NSError(domain: "convertDataWithCompletionHandler", code: 1, userInfo: userInfo))
        }
        completionHandlerForConvertData(parsedResult, nil)
    }
    
    
    
    
    // create a URL from parameters

    class func URLFromParameters(_ scheme: String, _ host: String, _ path: String, withPathExtension: String? = nil, withQuery: String? = nil) -> URL{
        var parameters = [String:AnyObject]()
        var components = URLComponents()
        components.scheme = scheme
        components.host = host
        components.path = path + (withPathExtension ?? "")
        components.query = (withQuery ?? "")
        
        components.queryItems = [URLQueryItem]()
        
        for (key, value) in parameters {
            let queryItem = URLQueryItem(name: key, value: "\(value)")
            components.queryItems!.append(queryItem)
        }
        
        return components.url!
    }
    
    
    
    
    //MARK: SHARED INSTANCE
    
    
    class func sharedInstance() -> Client {
        struct Singleton {
            static var sharedInstance = Client()
        }
        return Singleton.sharedInstance
    }

}
