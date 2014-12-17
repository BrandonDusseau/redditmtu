//
// Handles view for main page
// Alex Dinsmoor, Brandon Dusseau, Clayton Marriott, Chris Wallis
//

import UIKit

class SearchResultsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, APIControllerProtocol {

    @IBOutlet var appsTableView : UITableView?
    @IBOutlet var leftButton: UIBarButtonItem?
    var tableData = []
    var api : APIController?
    var imageCache = [String : UIImage]()
    var posts = [Post]()
    let kCellIdentifier: String = "SearchResultCell"

    override func viewDidLoad() {
        super.viewDidLoad()
        //API Access
        api = APIController(delegate: self)
        //Notify user of data access
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        api!.loadReddit()
        self.title = "Front Page"
    }

    func loadLogin(){
        let vc : UIViewController = self.storyboard?.instantiateViewControllerWithIdentifier("vcLogin") as UIViewController
        navigationController?.pushViewController(vc, animated:true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }

    //Dynamic post title label
    func topic(text:String, width:CGFloat) -> UILabel{
        let label:UILabel = UILabel(frame: CGRectMake(10, 10, width, CGFloat.max))
        label.numberOfLines = 0
        label.lineBreakMode = NSLineBreakMode.ByWordWrapping
        label.text = text
        //Resizes label
        label.sizeToFit()
        return label
    }
    //Dynamic subreddit label
    func subreddit(text:String, width:CGFloat, offset:CGFloat) -> UILabel{
        let label:UILabel = UILabel(frame: CGRectMake(10, (10+offset), width, (10+offset)))
        label.numberOfLines = 0
        label.lineBreakMode = NSLineBreakMode.ByWordWrapping
        label.text = text
        label.font = UIFont(name: "Helvetica", size: 10.0)
        //Resizes label
        label.sizeToFit()
        return label
    }


    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        //Grab Cell
        let cell: UITableViewCell = tableView.dequeueReusableCellWithIdentifier(kCellIdentifier) as UITableViewCell
        //Load post
        let post = self.posts[indexPath.row]
        //Create labels
        var body = topic(post.title, width: 300.0)
        body.tag = 1
        body.layoutIfNeeded()
        cell.addSubview(body)

        var subr = subreddit(post.subreddit, width: 300.0, offset: body.frame.height)
        subr.tag = 2
        subr.layoutIfNeeded()
        cell.addSubview(subr)
        
        //Set cell height
        cell.sizeThatFits(body.frame.size)
        tableView.rowHeight = body.frame.height+10+subr.frame.height
        cell.clipsToBounds = true

        return cell
    }

    //Function clears cell contents. This prevents the table from not clearing cell
    //Contents when re-used
    func tableView(tableView: UITableView, didEndDisplayingCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        let cell: UITableViewCell = tableView.dequeueReusableCellWithIdentifier(kCellIdentifier) as UITableViewCell
        cell.prepareForReuse()
    }

    // The APIControllerProtocol method
    func didReceiveAPIResults(results: NSDictionary) {
        var resultsArr: NSDictionary = results["data"]! as NSDictionary
        var resultsArr2: NSArray = resultsArr["children"] as NSArray
                dispatch_async(dispatch_get_main_queue(), {
            self.posts = Post.postsWithJSON(resultsArr2)
            self.appsTableView!.reloadData()
            UIApplication.sharedApplication().networkActivityIndicatorVisible = false
        })
    }

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
            
            // Set all of the info for the new view
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
            
            // Segue to the view
            navigationController?.pushViewController(acctViewController, animated: true)
            }

        } else {

            // Not logged in, go to Login page
            var destViewController: LoginWebView = self.storyboard?.instantiateViewControllerWithIdentifier("loginView") as LoginWebView
            
            // Get the device's UUID
            let deviceUUID = UIDevice.currentDevice().identifierForVendor.UUIDString
            var finalURL = "https://ssl.reddit.com/api/v1/authorize.compact?client_id=n7Vg85H--tQlBw&response_type=code&state=\(deviceUUID)&redirect_uri=http://www.reddit.com&duration=permanent&scope=identity,mysubreddits,read"

            // Give the web view the URL of the auth login page
            destViewController.inputURL = finalURL
            navigationController?.pushViewController(destViewController, animated: true)
        }
    }
}
