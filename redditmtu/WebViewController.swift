//
//  WebViewController.swift
//  redditmtu
//
//  Created by Clayton Marriott on 12/13/14.
//
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