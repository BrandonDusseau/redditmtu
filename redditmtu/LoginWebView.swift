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
        
        let requestURL = NSURL(string: inputURL)
        let request = NSURLRequest(URL: requestURL!)
        
        webView.loadRequest(request)
    }
    
    func webViewDidFinishLoad(webView: UIWebView) {
        var currentURL = webView.request?.URL
        var query = currentURL?.query?.componentsSeparatedByString("&")
        
        if (query != nil) {
            for item in query! {
                var values = item.componentsSeparatedByString("=")
                if (values[0] == "code") {
                    getAuthToken(values[1])
                    webView.stopLoading()
                    navigationController?.popViewControllerAnimated(true)
                }
            }
        }
    }
}