//
//  ViewController.swift
//  MusicPlayer
//
//  Created by Jameson Quave on 9/16/14.
//  Copyright (c) 2014 JQ Software LLC. All rights reserved.
//

import UIKit

class SearchResultsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, APIControllerProtocol {
    
    @IBOutlet var appsTableView : UITableView?
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
        
        // Check if we're going to the Login Page
        if (segue.identifier == "loginSegue") {
            var destViewController = segue.destinationViewController as WebViewController
        }
    }
    
}
