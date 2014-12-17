//
//  Comment.swift
//  redditmtu
//
//  Created by Chris Wallis on 12/14/14.
//
//

import Foundation

class Comment {
    
    //var replies : [Comment]
    var author: String
    var score : Int
    var body : String
    var subreddit: String
    
    /*init(commentDict: NSDictionary) {
        self.author = (commentDict["author"]! as? String)!
        self.subreddit = (commentDict["subreddit"]! as? String)!
        self.body = (commentDict["body"]! as? String)!
        self.score = (commentDict["score"]! as? Int)!
        //println(self.permaLink);
    }*/
    
    //Data should just be the dictionary that contains the data relavent to the commnet
    init(data: NSDictionary) {

        /*if let repliesDict = data["replies"] as? NSDictionary {
            replies = parseCommentsListing(repliesDict)
        } else {
            replies = [Comment]()
        }*/
        author = data["author"] as String
        score = data["score"] as Int
        body = data["body"] as String
        subreddit = data["subreddit"] as String
    }
    
    class func commentsWithJSON(allResults: NSArray) -> [Comment] {
        
        // Create an empty array of Albums to append to from this list
        var comments = [Comment]()
        
        // Store the results in our table data array
        
        if allResults.count>0 {
            println(allResults.count)
            println("Beginning comment population")
            var temp = 0
            // Sometimes iTunes returns a collection, not a track, so we check both for the 'name'
            for result in allResults {
                //println(result["data"]);
                //println(temp++)
                temp++
                if(temp+1 < allResults.count){
                var resultsArr: NSDictionary = result["data"] as NSDictionary
                var newComment = Comment(data: resultsArr)
                comments.append(newComment)
                }
                
            }
        }
        println(comments.count)
        return comments
    }

    
}