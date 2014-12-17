//
// Handles view for post details
// Alex Dinsmoor, Brandon Dusseau, Clayton Marriott, Chris Wallis
//

import UIKit


class DetailsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate,APICommentControllerProtocol {
    
    var post: Post?
    
    @IBOutlet weak var postAuthor: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet var appsTableView: UITableView?
    var api : APICommentController?
    var comments = [Comment]()
    
    let kCellIdentifier: String = "CommentCell"
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        titleLabel.text = self.post?.author
        postAuthor.text = self.post?.title
        api = APICommentController(delegate: self)
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        
        api!.loadPost("http://www.reddit.com"+self.post!.permaLink+".json");
        
        self.title = self.post?.title;
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return comments.count
    }
    
    func commentBody(text:String, width:CGFloat) -> UILabel{
        let label:UILabel = UILabel(frame: CGRectMake(10, 10, width, CGFloat.max))
        label.numberOfLines = 0
        label.lineBreakMode = NSLineBreakMode.ByWordWrapping
        label.text = text
        
        label.sizeToFit()
        return label
    }
    
    func commentPoster(text:String, width:CGFloat, offset:CGFloat) -> UILabel{
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
        let comment = self.comments[indexPath.row]
        var commentText = commentBody(comment.body, width: 300.0)
        commentText.tag = 1
        commentText.layoutIfNeeded()
        
        
        cell.addSubview(commentText)
        
        var user = commentPoster(comment.author, width: 300.0, offset: commentText.frame.height)
        user.tag = 2
        user.layoutIfNeeded()
       
        
        cell.addSubview(user)
        
        
        cell.sizeThatFits(commentText.frame.size)
        tableView.rowHeight = commentText.frame.height+10+user.frame.height
        cell.clipsToBounds = true
        
        
        return cell
    }
    
    func tableView(tableView: UITableView, didEndDisplayingCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        let cell: UITableViewCell = tableView.dequeueReusableCellWithIdentifier(kCellIdentifier) as UITableViewCell
        cell.prepareForReuse()
    }
    
    // The APIControllerProtocol method
    func didReceiveAPIResults(results: NSArray) {
        let results1: NSDictionary = results[1] as NSDictionary
        let results2: NSArray = results1["data"]!["children"] as NSArray
        dispatch_async(dispatch_get_main_queue(), {
            self.comments = Comment.commentsWithJSON(results2)
            self.appsTableView!.reloadData()
            UIApplication.sharedApplication().networkActivityIndicatorVisible = false
        })
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}