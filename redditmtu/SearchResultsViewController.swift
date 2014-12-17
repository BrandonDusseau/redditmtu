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
        APIController.sendHTTPQuery("/api/v1/me", postdata:"")

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


    func topic(text:String, width:CGFloat) -> UILabel{
        let label:UILabel = UILabel(frame: CGRectMake(10, 10, width, CGFloat.max))
        label.numberOfLines = 0
        label.lineBreakMode = NSLineBreakMode.ByWordWrapping
        label.text = text

        label.sizeToFit()
        return label
    }

    func subreddit(text:String, width:CGFloat, offset:CGFloat) -> UILabel{
        println(offset)
        let label:UILabel = UILabel(frame: CGRectMake(10, (10+offset), width, (10+offset)))
        label.numberOfLines = 0
        label.lineBreakMode = NSLineBreakMode.ByWordWrapping
        label.text = text
        label.font = UIFont(name: "Helvetica", size: 10.0)

        label.sizeToFit()
        return label
    }


    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {

        let cell: UITableViewCell = tableView.dequeueReusableCellWithIdentifier(kCellIdentifier) as UITableViewCell

        let post = self.posts[indexPath.row]
        //cell.textLabel?.text = post.title
        //cell.detailTextLabel?.text = post.subreddit

        var body = topic(post.title, width: 300.0)
        body.tag = 1
        body.layoutIfNeeded()
        cell.addSubview(body)

        var subr = subreddit(post.subreddit, width: 300.0, offset: body.frame.height)
        subr.tag = 2
        subr.layoutIfNeeded()
        cell.addSubview(subr)


        cell.sizeThatFits(body.frame.size)
        tableView.rowHeight = body.frame.height+10+subr.frame.height
        cell.clipsToBounds = true

        return cell
    }

    func tableView(tableView: UITableView, didEndDisplayingCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        let cell: UITableViewCell = tableView.dequeueReusableCellWithIdentifier(kCellIdentifier) as UITableViewCell
        cell.prepareForReuse()
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
            if (true) {
                var destViewController = segue.destinationViewController as AccountViewController
                destViewController.accountDate = "Date is testy."
                destViewController.username = "Test test test."

            } else {
                var destViewController = segue.destinationViewController as LoginWebView
                let deviceUUID = UIDevice.currentDevice().identifierForVendor.UUIDString
                var finalURL = "https://ssl.reddit.com/api/v1/authorize.compact?client_id=n7Vg85H--tQlBw&response_type=code&state=\(deviceUUID)&redirect_uri=http://www.reddit.com&duration=permanent&scope=identity,edit,history,mysubreddits,read,report,vote,subscribe"

                destViewController.inputURL = finalURL
            }
        }
    }

}
