//
//  Post.swift
//  TableTest
//
//  Created by Alex Dinsmoor on 12/8/14.
//  Copyright (c) 2014 Dinsmoor. All rights reserved.
//


import Foundation

class Post {
    var title: String
    var author: String
    var subreddit: String
    var postURL: String
    var domain: String
    var selfText: String
    var score: Int
    var permaLink: String
    var numberOfComments: Int
    
//    init(title: String, author: String, subreddit: String, postURL: String) {
//        self.title = title
//        self.author = author
//        self.subreddit = subreddit
//        self.postURL = postURL
//    }
    
    init(postDict: NSDictionary) {
        self.title = (postDict["title"]! as? String)!
        self.author = (postDict["author"]! as? String)!
        self.subreddit = (postDict["subreddit"]! as? String)!
        self.postURL = (postDict["url"]! as? String)!
        self.domain = (postDict["domain"]! as? String)!
        self.selfText = (postDict["selftext"]! as? String)!
        self.score = (postDict["score"]! as? Int)!
        self.permaLink = (postDict["permalink"]! as? String)!
         //println(self.permaLink);
        self.numberOfComments = (postDict["num_comments"]! as? Int)!
    }
    
    class func postsWithJSON(allResults: NSArray) -> [Post] {
        
        // Create an empty array of Albums to append to from this list
        var posts = [Post]()
        
        // Store the results in our table data array
        
        if allResults.count>0 {
            //println(allResults.count)
            //println()
            
            // Sometimes iTunes returns a collection, not a track, so we check both for the 'name'
            for result in allResults {
                var resultsArr: NSDictionary = result["data"] as NSDictionary
                var newPost = Post(postDict: resultsArr)
                posts.append(newPost)
                
    
            }
        }
        return posts
    }
    
}