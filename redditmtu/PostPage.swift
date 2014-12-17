//
// PostPage
// Alex Dinsmoor, Brandon Dusseau, Clayton Marriott, Chris Wallis
//

import Foundation

class PostPage {
    
    var post : Post
    var comments : [Comment]
    
    //Expects the entire json result and not just part of it
    init(post: Post, jsonResult : NSArray) {
        self.post = post
        
        //First part of the array is the post. Second part is the comments
        var swiftArray = jsonResult as [AnyObject]
        if let commentsDict = swiftArray[1] as? NSDictionary {
            comments = parseCommentsListing(commentsDict)
        } else {
            comments = [Comment]()
        }
    }
}