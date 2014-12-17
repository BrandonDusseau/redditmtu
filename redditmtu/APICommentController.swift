//
//  APICommentController.swift
//  redditmtu
//
//  Created by Alex Dinsmoor on 12/16/14.
//
//

import Foundation

protocol APICommentControllerProtocol {
    func didReceiveAPIResults(results: NSArray)
}

class APICommentController{
    
    var delegate: APICommentControllerProtocol
    
    init(delegate: APICommentControllerProtocol) {
        self.delegate = delegate
    }
    
    func loadPost(urlPath: String){
        println(urlPath);
        let urlPath1 = "http://www.reddit.com/r/DetroitRedWings/comments/2pigv9/i_had_to_decide_what_i_wanted_to_wear_when_i_met/.json"
        let url = NSURL(string: urlPath)
        //println(url);
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithURL(url!, completionHandler: {data, response, error -> Void in
            println("Task completed")
            if(error != nil) {
                // If there is an error in the web request, print it to the console
                println(error.localizedDescription)
            }
            var err: NSError?
            println("Defining JSON")
            
            var jsonResult = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers, error: &err) as NSArray
            if(err != nil) {
                // If there is an error parsing JSON, print it to the console
                println("JSON Error \(err!.localizedDescription)")
            }
            //println("Accessing JSON")
            //println(jsonResult)
            println("Finished JSON")
            let results1: NSDictionary = jsonResult[1] as NSDictionary
            //println(results1);
            let results: NSArray = results1["data"]!["children"] as NSArray
            //println(results);
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