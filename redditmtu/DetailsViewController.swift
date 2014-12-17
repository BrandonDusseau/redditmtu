//
//  DetailsViewController.swift
//  TableTest
//
//  Created by Alex Dinsmoor on 12/7/14.
//  Copyright (c) 2014 Dinsmoor. All rights reserved.
//

import UIKit


class DetailsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate,APICommentControllerProtocol {
    
    var post: Post?
    
    @IBOutlet weak var albumCover: UIImageView!
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
        // super.viewDidLoad()
        titleLabel.text = self.post?.author
        postAuthor.text = self.post?.title
        api = APICommentController(delegate: self)
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        
        api!.loadPost("http://www.reddit.com"+self.post!.permaLink+".json");
        
        self.title = self.post?.title;
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        println("Table count is")
        println(comments.count)
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
        println("Defining table")
        let cell: UITableViewCell = tableView.dequeueReusableCellWithIdentifier(kCellIdentifier) as UITableViewCell
        let comment = self.comments[indexPath.row]
        var commentText = commentBody(comment.body, width: 300.0)
        //newLabel.text = comment.body
        commentText.tag = 1
        commentText.layoutIfNeeded()
        
        
        cell.addSubview(commentText)
        
        var user = commentPoster(comment.author, width: 300.0, offset: commentText.frame.height)
        //newLabel.text = comment.body
        user.tag = 2
        user.layoutIfNeeded()
       
        
        cell.addSubview(user)
        
        
        cell.sizeThatFits(commentText.frame.size)
    tableView.rowHeight = commentText.frame.height+10+user.frame.height
        //tableView.rowHeight = 200
        cell.clipsToBounds = true
        
        
        return cell
    }
    
    func tableView(tableView: UITableView, didEndDisplayingCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        let cell: UITableViewCell = tableView.dequeueReusableCellWithIdentifier(kCellIdentifier) as UITableViewCell
        cell.prepareForReuse()
    }
    

    
    // The APIControllerProtocol method
    func didReceiveAPIResults(results: NSArray) {
        //var resultsArr: NSDictionary = results["data"]! as NSDictionary
        //var resultsArr2: NSArray = resultsArr["children"] as NSArray
        let results1: NSDictionary = results[1] as NSDictionary
        //println(results1);
        let results2: NSArray = results1["data"]!["children"] as NSArray
        dispatch_async(dispatch_get_main_queue(), {
            //self.albums = Album.albumsWithJSON(resultsArr)
            self.comments = Comment.commentsWithJSON(results2)
            println(self.comments)
            self.appsTableView!.reloadData()
            println("Table reloaded")
            UIApplication.sharedApplication().networkActivityIndicatorVisible = false
        })
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}