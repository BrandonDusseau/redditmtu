//
// Loads comments via JSON
// Alex Dinsmoor, Brandon Dusseau, Clayton Marriott, Chris Wallis
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
        let url = NSURL(string: urlPath)
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithURL(url!, completionHandler: {data, response, error -> Void in
            if(error != nil) {
                // If there is an error in the web request, print it to the console
                println(error.localizedDescription)
            }
            var err: NSError?
            
            var jsonResult = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers, error: &err) as NSArray
            if(err != nil) {
                // If there is an error parsing JSON, print it to the console
                println("JSON Error \(err!.localizedDescription)")
            }
            let results1: NSDictionary = jsonResult[1] as NSDictionary
            let results: NSArray = results1["data"]!["children"] as NSArray
            self.delegate.didReceiveAPIResults(jsonResult)
        })
        
        task.resume()
        
    }
    
}