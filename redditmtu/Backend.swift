//
//  Backend.swift
//  redditmtu
//
//  Created by Chris Wallis on 12/14/14.
//
//

import Foundation

//Gets a list (I.e a list of results) from the front page or from a subreddit
//If a listing is provided it will go ahead and ge the next section of results. Otherwise it will
//get the first listing of results
func getListingURLAfter(subreddit: String?, previousListing: Listing?, count: Int) -> String {
    if let subredditName = subreddit {
        //Looking at a subreddit
        if let after = previousListing?.after {
            return getSubredditURL(subredditName) + "?count=\(count)&after=\(after)"
        } else {
            return getSubredditURL(subredditName)
        }
    } else {
        //looking at the front page
        if let after = previousListing?.after {
            return getFrontPageURL() + "?count=\(count)&after=\(after)"
        } else {
            return getFrontPageURL()
        }
    }
}

//Gets a list (I.e a list of results) from the front page or from a subreddit
//If a listing is provided it will go ahead and ge the previous section of results. Otherwise it will
//get the first listing of results
func getListingURLBefore(subreddit: String?, previousListing: Listing?, count: Int) -> String {
    if let subredditName = subreddit {
        //Looking at a subreddit
        if let before = previousListing?.before {
            return getSubredditURL(subredditName) + "?count=\(count)&before=\(before)"
        } else {
            return getSubredditURL(subredditName)
        }
    } else {
        //looking at the front page
        if let before = previousListing?.before {
            return getFrontPageURL() + "?count=\(count)&before=\(before)"
        } else {
            return getFrontPageURL()
        }
    }
}

func getPostPageUrl(post: Post) -> String {
    var permaLink = post.permaLink.substringToIndex(post.permaLink.endIndex.predecessor())
    return "http://www.reddit.com/\(permaLink).json"
}

func getFrontPageURL() -> String {
    return "http://www.reddit.com/.json"
}

func getSubredditURL(subreddit: String) -> String {
    return "http://www.reddit.com/r/" + subreddit + ".json"
}

func parseListingData(jsonResult : NSDictionary) -> Listing {
    return Listing(jsonResult: jsonResult)
}

func parsePostPageData(post : Post, jsonResult : NSArray) -> PostPage {
    return PostPage(post: post, jsonResult : jsonResult)
}

func parseCommentsListing(listing: NSDictionary) -> [Comment]{
    var comments = [Comment]()
    
    var rootComments = listing["data"]!["children"] as NSArray
    
    if rootComments.count > 0 {
        for commentDict in rootComments {
            var kind = commentDict["kind"]! as String
            if kind == "more" {
                return comments
            }
            
            var dataDict = commentDict["data"] as NSDictionary
            var comment = Comment(data: dataDict)
            comments.append(comment)
        }
    }
    
    return comments
}

func getStringOrEmpty(theString : String?) -> String{
    var text = ""
    if let tempText = theString {
        text = tempText
    }
    return text
}

