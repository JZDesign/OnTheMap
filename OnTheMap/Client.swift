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
    
    // MARK: Initializers
    
    override init() {
        super.init()
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
            
            print("Request: \(request)")
        } else {
            // if requesting to post data to the parse api
            request.addValue(Client.Constants.ParameterValues.ParseAppID, forHTTPHeaderField: "X-Parse-Application-Id")
            request.addValue(Client.Constants.ParameterValues.ParseAppID, forHTTPHeaderField: "X-Parse-REST-API-Key")
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.httpBody = jsonBody.data(using: String.Encoding.utf8)
            
            print("Request: \(request)")
        }
        
        
        return doRequestWithCompletion(request, truncatePrefix: truncatePrefix, completion: completionHandlerForGET)
        
            
        

    }
    
    // MARK: POST
    /*
    func taskForPostMethod(_ method: String, parameters: [String:AnyObject], jsonBody: String, completionHandlerForPOST: @escaping (_ result: AnyObject?, _ error: NSError?) -> Void) -> URLSessionDataTask {
        /* 1. Set the parameters */
        var parametersWithApiKey = parameters
        parametersWithApiKey[Constants.ParameterKeys.APIKey] = Constants.ParameterValues.APIKey as AnyObject?
        
        /* 2/3. Build the URL, Configure the request */
        let request = NSMutableURLRequest(url: Client.udacityURLFromParameters(parametersWithApiKey, withPathExtension: method))
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = jsonBody.data(using: String.Encoding.utf8)
        
        return doRequestWithCompletion(request, completion: completionHandlerForPOST)
    }
 
 */
    
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
            
            print("Request: \(request)")
        } else {
            // if requesting to post data to the parse api
            request.addValue(Client.Constants.ParameterValues.ParseAppID, forHTTPHeaderField: "X-Parse-Application-Id")
            request.addValue(Client.Constants.ParameterValues.ParseAppID, forHTTPHeaderField: "X-Parse-REST-API-Key")
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.httpBody = jsonBody.data(using: String.Encoding.utf8)
            
            print("Request: \(request)")
        }
       
        
        return doRequestWithCompletion(request, truncatePrefix: truncatePrefix, completion: completionHandlerForPost)
        
        
    }

    
    // MARK: GET Image
    /*
    func taskForGETImage(_ size: String, filePath: String, completionHandlerForImage: @escaping (_ imageData: Data?, _ error: NSError?) -> Void) -> URLSessionTask {
        
        /* 1. Set the parameters */
        // There are none...
        
        /* 2/3. Build the URL and configure the request */
        let baseURL = URL(string: config.baseImageURLString)!
        let url = baseURL.appendingPathComponent(size).appendingPathComponent(filePath)
        let request = URLRequest(url: url)
        /* 4. Make the request */
        let task = session.dataTask(with: request) { (data, response, error) in
            
            func sendError(_ error: String) {
                print(error)
                let userInfo = [NSLocalizedDescriptionKey : error]
                completionHandlerForImage(nil, NSError(domain: "taskForGETMethod", code: 1, userInfo: userInfo))
            }
            
            /* GUARD: Was there an error? */
            guard (error == nil) else {
                sendError("There was an error with your request: \(error!)")
                return
            }
            
            /* GUARD: Did we get a successful 2XX response? */
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else {
                sendError("Your request returned a status code other than 2xx!")
                return
            }
            
            /* GUARD: Was there any data returned? */
            guard let data = data else {
                sendError("No data was returned by the request!")
                return
            }
            
            /* 5/6. Parse the data and use the data (happens in completion handler) */
            completionHandlerForImage(data, nil)
        }
        
        /* 7. Start the request */
        task.resume()
        
        return task
    }
 */
    
    
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
    private func doRequestWithCompletion(_ request: NSMutableURLRequest, truncatePrefix: Int, completion: @escaping (_ result: AnyObject?, _ error: NSError?) -> Void) -> URLSessionDataTask {
        /* 4. Make the request */
        let task = session.dataTask(with: request as URLRequest) { (data, response, error) in
            
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
                sendError("Your request returned a status code other than 2xx!")
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
        print(parsedResult)
        completionHandlerForConvertData(parsedResult, nil)
    }
    
    // create a URL from parameters
    class func udacityURLFromParameters(_ parameters: [String:AnyObject], withPathExtension: String? = nil) -> URL {
        
        var components = URLComponents()
        components.scheme = Client.Constants.Udacity.Scheme
        components.host = Client.Constants.Udacity.Host
        components.path = Client.Constants.Udacity.Path + (withPathExtension ?? "")
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
