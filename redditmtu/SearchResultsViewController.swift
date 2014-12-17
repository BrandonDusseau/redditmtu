//
//  ViewController.swift
//  MusicPlayer
//
//  Created by Jameson Quave on 9/16/14.
//  Copyright (c) 2014 JQ Software LLC. All rights reserved.
//
//  Modified for use on RedditMTU
//  Alex Dinsmoor, Brandon Dusseau, Clayton Marriott, Chris Wallis
//

import UIKit

class SearchResultsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, APIControllerProtocol {
    
    @IBOutlet var appsTableView : UITableView?
    @IBOutlet var leftButton: UIBarButtonItem?
    var tableData = []
    var api : APIController?
    var imageCache = [String : UIImage]()
    var albums = [Album]()
    var posts = [Post]()
    let kCellIdentifier: String = "SearchResultCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        api = APIController(delegate: self)
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        api!.loadReddit()
        
        self.title = "Front Page"
        
        // Testing code
        //sendHTTPQuery("/api/v1/me", postdata:"")
       
    }
    func printNo(){
        println("No")
    }
    
    func loadLogin(){
        let vc : UIViewController = self.storyboard?.instantiateViewControllerWithIdentifier("vcLogin") as UIViewController
        //self.window!.rootViewController = viewcontroller
        //let vc = LoginController
        navigationController?.pushViewController(vc, animated:true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell: UITableViewCell = tableView.dequeueReusableCellWithIdentifier(kCellIdentifier) as UITableViewCell
        
        let post = self.posts[indexPath.row]
        cell.textLabel?.text = post.title
        /*cell.imageView?.image = UIImage(named: "Blank52")
        
        // Get the formatted price string for display in the subtitle
        let formattedPrice = album.price
        
        // Grab the artworkUrl60 key to get an image URL for the app's thumbnail
        let urlString = album.thumbnailImageURL
        
        // Check our image cache for the existing key. This is just a dictionary of UIImages
        //var image: UIImage? = self.imageCache.valueForKey(urlString) as? UIImage
        var image = self.imageCache[urlString]
        
        
        if( image == nil ) {
            // If the image does not exist, we need to download it
            var imgURL: NSURL = NSURL(string: urlString)!
            
            // Download an NSData representation of the image at the URL
            let request: NSURLRequest = NSURLRequest(URL: imgURL)
            NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue(), completionHandler: {(response: NSURLResponse!,data: NSData!,error: NSError!) -> Void in
                if error == nil {
                    image = UIImage(data: data)
                    
                    // Store the image in to our cache
                    self.imageCache[urlString] = image
                }
                else {
                    println("Error: \(error.localizedDescription)")
                }
            })
            
        }
        
        dispatch_async(dispatch_get_main_queue(), {
            if let cellToUpdate = tableView.cellForRowAtIndexPath(indexPath) {
                cellToUpdate.imageView?.image = image
            }
        })
        */
        cell.detailTextLabel?.text = post.subreddit
        
        return cell
    }
    
    // The APIControllerProtocol method
    func didReceiveAPIResults(results: NSDictionary) {
        var resultsArr: NSDictionary = results["data"]! as NSDictionary
        var resultsArr2: NSArray = resultsArr["children"] as NSArray
                dispatch_async(dispatch_get_main_queue(), {
            //self.albums = Album.albumsWithJSON(resultsArr)
            self.posts = Post.postsWithJSON(resultsArr2)
            self.appsTableView!.reloadData()
            UIApplication.sharedApplication().networkActivityIndicatorVisible = false
        })
    }
//    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
//        // Get the row data for the selected row
//        var rowData: NSDictionary = self.tableData[indexPath.row] as NSDictionary
//        
//        var name: String = rowData["trackName"] as String
//        var formattedPrice: String = rowData["formattedPrice"] as String
//        
//        var alert: UIAlertView = UIAlertView()
//        alert.title = name
//        alert.message = formattedPrice
//        alert.addButtonWithTitle("Ok")
//        alert.show()
//    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        // See if we're headed to the Detail View
        if (segue.identifier == "detailSegue") {
            
            // Get the controller so we can pass info to it.
            var detailsViewController = segue.destinationViewController as DetailsViewController
            var postIndex = appsTableView!.indexPathForSelectedRow()!.row
            var selectedPost = self.posts[postIndex]
            detailsViewController.post = selectedPost
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        if (auth_token != nil) {
            leftButton?.title = "Account"
        } else {
            leftButton?.title = "Login"
        }
    }
    
    @IBAction func manualSegue(sender: AnyObject) {
        // Check if we're logged in
        if (auth_token != nil) {
            
            // Already logged in, go to Account page
            if let acctInfo = getAccountIdentity() {
        
            var acctViewController: AccountViewController = self.storyboard?.instantiateViewControllerWithIdentifier("accountView") as AccountViewController
            
            if let create : Double = acctInfo["created_utc"] as? Double {
                let dateFormatter = NSDateFormatter()
                dateFormatter.dateFormat = "MMMM d, y"
                let formattedTimestamp = dateFormatter.stringFromDate(NSDate(timeIntervalSince1970: create))
                acctViewController.accountDate = "Redditor since \(formattedTimestamp)"
            }
            
            if let user : String = acctInfo["name"] as? String {
                acctViewController.username = "User \(user)"
            }
                
            if let commentKarma : Int = acctInfo["comment_karma"] as? Int {
                acctViewController.commentKarma = "Comment Karma: \(commentKarma)"
            }
                
            if let linkKarma : Int = acctInfo["link_karma"] as? Int {
                acctViewController.linkKarma = "Link Karma: \(linkKarma)"
            }
            
            navigationController?.pushViewController(acctViewController, animated: true)
                
            }
            
        } else {
            
            // Not logged in, go to Login page
            var destViewController: LoginWebView = self.storyboard?.instantiateViewControllerWithIdentifier("loginView") as LoginWebView
            
            let deviceUUID = UIDevice.currentDevice().identifierForVendor.UUIDString
            var finalURL = "https://ssl.reddit.com/api/v1/authorize.compact?client_id=n7Vg85H--tQlBw&response_type=code&state=\(deviceUUID)&redirect_uri=http://www.reddit.com&duration=permanent&scope=identity,mysubreddits,read"
            
            destViewController.inputURL = finalURL
            navigationController?.pushViewController(destViewController, animated: true)
        }
    }
    
    @IBAction func TriggerThing(sender: AnyObject) {
        //if (auth_token == nil) {
        //    getAuthToken("lT6GHnJG0TJR4FlkS5DIYXafOC4")
        //}
        
        getAccountIdentity()
        //getAccountFriends()
        //getAccountKarma()
        //getAccountTrophies()
        //getAccountSubreddits()
    }
    
}
