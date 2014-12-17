//
//  APIController.swift
//  TableTest
//
//  Created by Alex Dinsmoor on 12/6/14.
//  Copyright (c) 2014 Dinsmoor. All rights reserved.
//

import Foundation

protocol APIControllerProtocol {
    func didReceiveAPIResults(results: NSDictionary)
}

class APIController{
    
    var delegate: APIControllerProtocol
    
    init(delegate: APIControllerProtocol) {
        self.delegate = delegate
    }
    
    func loadReddit() {
        
            let urlPath = "http://www.reddit.com/.json"
            let url = NSURL(string: urlPath)
            let session = NSURLSession.sharedSession()
            let task = session.dataTaskWithURL(url!, completionHandler: {data, response, error -> Void in
                println("Task completed")
                if(error != nil) {
                    // If there is an error in the web request, print it to the console
                    println(error.localizedDescription)
                }
                var err: NSError?
                
                var jsonResult = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers, error: &err) as NSDictionary
                if(err != nil) {
                    // If there is an error parsing JSON, print it to the console
                    println("JSON Error \(err!.localizedDescription)")
                }
                //let results: NSArray = jsonResult["results"] as NSArray
                let results: NSArray = jsonResult["data"]!["children"] as NSArray
                //let results: NSArray = results1["children"] as NSArray
                self.delegate.didReceiveAPIResults(jsonResult)
            })
            
            task.resume()
        
    }
        
    // Returns JSON from HTTP request
    // api: API location (for example, /api/v1/me)
    // postdata: POST query (key1=val1&key2=val2)
    // Returns NSDictionary with JSON response
    class func sendHTTPQuery(api: String, postdata: String) -> NSDictionary {
        let urlPath: String = "https://www.reddit.com/\(api)"
        var url: NSURL = NSURL(string: urlPath)!
        var request: NSMutableURLRequest = NSMutableURLRequest(URL: url)
        var response: AutoreleasingUnsafeMutablePointer<NSURLResponse?
        >=nil
        
        let requestBodyData = (postdata as NSString).dataUsingEncoding(NSUTF8StringEncoding)
        request.HTTPBody = requestBodyData
        
        var error: NSErrorPointer = nil
        var dataVal: NSData =  NSURLConnection.sendSynchronousRequest(request, returningResponse: response, error:nil)!
        var err: NSError
        println(response)
        var jsonResult: NSDictionary = NSJSONSerialization.JSONObjectWithData(dataVal, options: NSJSONReadingOptions.MutableContainers, error: nil) as NSDictionary
        
        println("API call: \(api)\nPOST data: \(postdata)")
        println("Synchronous\(jsonResult)")
        return jsonResult
    }
}
