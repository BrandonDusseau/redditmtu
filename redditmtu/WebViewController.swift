//
// Handles browser view
// Alex Dinsmoor, Brandon Dusseau, Clayton Marriott, Chris Wallis
//

import UIKit

class WebViewController : UIViewController {
    
    
    var inputURL: String!
    @IBOutlet weak var webView: UIWebView!
    
    override func viewDidLoad() {
        
        // Create a URL from the given string
        let requestURL = NSURL(string: inputURL)
        let request = NSURLRequest(URL: requestURL!)
        
        // Have the web view load the page
        webView.loadRequest(request)
    }
}