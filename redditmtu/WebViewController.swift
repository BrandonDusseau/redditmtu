//
//  WebViewController.swift
//  redditmtu
//
//  Created by Clayton Marriott on 12/13/14.
//
//

import UIKit

class WebViewController : UIViewController {
    
    @IBOutlet weak var webView: UIWebView!
    
    override func viewDidLoad() {
        let firstHalf = "https://ssl.reddit.com/api/v1/authorize.compact?client_id=n7Vg85H--tQlBw&response_type=code&state="
        let secondHalf = "&redirect_uri=http://www.reddit.com&duration=permanent&scope=identity,edit,history,mysubreddits,read,report,vote,subscribe"
        
        let letters : NSString = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        var randomString : NSMutableString = NSMutableString(capacity: 32)
        for (var i=0; i < 32; i++){
            var length = UInt32 (letters.length)
            var rand = arc4random_uniform(length)
            randomString.appendFormat("%C", letters.characterAtIndex(Int(rand)))
        }
        
        var finalURL = firstHalf + randomString + secondHalf
        
        let requestURL = NSURL(string: finalURL)
        let request = NSURLRequest(URL: requestURL!)
        
        webView.loadRequest(request)
    }
}