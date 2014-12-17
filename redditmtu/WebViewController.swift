//
// Handles browser view
// Alex Dinsmoor, Brandon Dusseau, Clayton Marriott, Chris Wallis
//

import UIKit

class WebViewController : UIViewController {
    
    
    var inputURL: String!
    @IBOutlet weak var webView: UIWebView!
    
    override func viewDidLoad() {
        
        let requestURL = NSURL(string: inputURL)
        let request = NSURLRequest(URL: requestURL!)
        
        webView.loadRequest(request)
    }
}