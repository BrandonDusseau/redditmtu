//
//  Comment.swift
//  redditmtu
//
//  Created by Chris Wallis on 12/14/14.
//
//

import Foundation

class Comment {
    
    var replies : [Comment]
    var author: String
    var score : Int
    var body : String
    var subreddit: String
    
    //Data should just be the dictionary that contains the data relavent to the commnet
    init(data: NSDictionary) {

        if let repliesDict = data["replies"] as? NSDictionary {
            replies = parseCommentsListing(repliesDict)
        } else {
            replies = [Comment]()
        }
        author = data["author"] as String
        score = data["score"] as Int
        body = data["body"] as String
        subreddit = data["subreddit"] as String
    }
}