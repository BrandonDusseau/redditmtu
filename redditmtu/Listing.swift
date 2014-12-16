//
//  Listing.swift
//  redditmtu
//
//  Created by Chris Wallison 12/14/14.
//
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
        println(before)
        posts = Post.postsWithJSON(data["children"] as NSArray)
    }
}