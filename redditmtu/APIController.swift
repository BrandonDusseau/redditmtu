//
// Handles some API functions
// Alex Dinsmoor, Brandon Dusseau, Clayton Marriott, Chris Wallis
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
            //Define URL Path
            let urlPath = "http://www.reddit.com/.json"
            let url = NSURL(string: urlPath)
        //Create a session to grab JSON
            let session = NSURLSession.sharedSession()
            let task = session.dataTaskWithURL(url!, completionHandler: {data, response, error -> Void in
                if(error != nil) {
                    // If there is an error in the web request, print it to the console
                    println(error.localizedDescription)
                }
                var err: NSError?
                //JSON from URL
                var jsonResult = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers, error: &err) as NSDictionary
                if(err != nil) {
                    // If there is an error parsing JSON, print it to the console
                    println("JSON Error \(err!.localizedDescription)")
                }
                //Proper initial unwrapping of JSON
                let results: NSArray = jsonResult["data"]!["children"] as NSArray
                //Send it to delegate
                self.delegate.didReceiveAPIResults(jsonResult)
            })

            task.resume()

    }
    
    }
