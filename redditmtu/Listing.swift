//
// Listing.swift
// Alex Dinsmoor, Brandon Dusseau, Clayton Marriott, Chris Wallis
//

import Foundation

class Listing {
    var after: String
    var before: String?
    var posts: [Post]
    
    init(jsonResult : NSDictionary) {
        var data = jsonResult["data"] as NSDictionary
        after = data["after"] as String
        if let beforeData = data["before"] as? String {
            before = beforeData
        } else {
            before = nil
        }
        
        posts = Post.postsWithJSON(data["children"] as NSArray)
    }
}