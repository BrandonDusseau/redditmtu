//
// Handles web browser view for authentication
// Alex Dinsmoor, Brandon Dusseau, Clayton Marriott, Chris Wallis
//

import UIKit

class LoginWebView : UIViewController, UIWebViewDelegate {
    
    var inputURL: String!
    @IBOutlet weak var webView: UIWebView!
    
    override func viewDidLoad() {
        
        webView.delegate = self;
        
        // Create a URL and set it in the view
        let requestURL = NSURL(string: inputURL)
        let request = NSURLRequest(URL: requestURL!)
        
        webView.loadRequest(request)
    }
    
    func webViewDidFinishLoad(webView: UIWebView) {
        
        // Get the URL of the page the view is displaying
        var currentURL = webView.request?.URL
        var query = currentURL?.query?.componentsSeparatedByString("&")
        
        // Get the query portion from the URL
        if (query != nil) {
            for item in query! {
                var values = item.componentsSeparatedByString("=")
                
                // Check if we logged in successfully
                if (values[0] == "code") {
                    
                    // If we did, set the auth token and close the view
                    getAuthToken(values[1])
                    webView.stopLoading()
                    navigationController?.popViewControllerAnimated(true)
                }
            }
        }
    }
}