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

// Keep tokens and expiry time for authentication
var auth_token : String? = nil
var refresh_token : String? = nil
var auth_expires : NSDate = NSDate()

// Complete authentication by retrieving access token
func getAuthToken(code: String) {
    // If we do not yet have an access token, request one.
    var request : String = "grant_type=authorization_code&code=\(code)&redirect_uri=http://www.reddit.com"
    
    println("Auth: \(auth_token)\nRefresh: \(refresh_token)")
    
    // If we already have an access token, request a refresh instead.
    if (auth_token != nil && refresh_token != nil) {
        request = "grant_type=refresh_token&refresh_token=\(refresh_token!)"
    }
    
    let response : NSDictionary? = sendHTTPQuery("/api/v1/access_token", request, nil)
    
    if response != nil && response!["error"] == nil {
        println("Authentication token response:\n\(response!)")
        auth_token = response!["access_token"] as String!
        
        // Only update the refresh token if it does not exist
        if (refresh_token == nil) {
            refresh_token = response!["refresh_token"] as String!
        }

        // Calculate expiry time
        var components = NSDateComponents()
        let expire = response!["expires_in"] as Int
        components.setValue(expire, forComponent: NSCalendarUnit.CalendarUnitSecond)

        auth_expires = NSCalendar.currentCalendar().dateByAddingComponents(components, toDate: NSDate(), options: NSCalendarOptions(0))!
    } else {
        if response != nil {
            println("Error in authentication: \(response)")
        }
        auth_token = nil
        refresh_token = nil
        auth_expires = NSDate()
    }
    
}

// Begin account retrieval
func getAccountIdentity() -> NSDictionary? {
    return sendHTTPQuery("/api/v1/me", "", auth_token)
}

func getAccountFriends() -> NSDictionary? {
    return sendHTTPQuery("/api/v1/me/friends", "", auth_token)
}

func getAccountKarma() -> NSDictionary? {
    return sendHTTPQuery("/api/v1/me/karma", "", auth_token)
}

func getAccountTrophies() -> NSDictionary? {
    return sendHTTPQuery("/api/v1/me/trophies", "", auth_token)
}

func getAccountSubreddits() -> NSDictionary? {
    return sendHTTPQuery("/subreddits/mine/subscriber", "", auth_token)
}

// Returns JSON from HTTP request
// api: API location (for example, /api/v1/me)
// postdata: POST query (key1=val1&key2=val2)
// Returns NSDictionary with JSON response
func sendHTTPQuery(api: String, postdata: String, access_token: String?) -> NSDictionary? {
    
    // If our authentication is set and has expired, reauthenticate before continuing
    if (api != "/api/v1/access_token" && NSDate().compare(auth_expires) == NSComparisonResult.OrderedDescending && auth_token != nil) {
        getAuthToken("0xDEADD00D")
    }
    
    // If we do not have an access token set, we cannot make request
    if (access_token == nil && api != "/api/v1/access_token") {
        return nil
    }
    
    // Use the oauth subdomain normally, but ssl when authenticating
    var subdomain = "oauth"
    if (api == "/api/v1/access_token") {
        subdomain = "ssl"
    }
    
    // Setup authentication for getting the access token
    let loginString = NSString(format: "%@:%@", "n7Vg85H--tQlBw", "")
    let loginData: NSData = loginString.dataUsingEncoding(NSUTF8StringEncoding)!
    let base64LoginString = loginData.base64EncodedStringWithOptions(nil)
    
    // Create request and set parameters
    let urlPath: String = "https://\(subdomain).reddit.com\(api)"
    println("URL: \(urlPath)")
    var url: NSURL = NSURL(string: urlPath)!
    var request: NSMutableURLRequest = NSMutableURLRequest(URL: url)
    request.HTTPMethod = "GET";
    if (api == "/api/v1/access_token") {
        request.HTTPMethod = "POST";
    }
    let requestBodyData = (postdata as NSString).dataUsingEncoding(NSUTF8StringEncoding)
    request.HTTPBody = requestBodyData
    request.setValue("redditmtu/1.0", forHTTPHeaderField: "User-Agent")
    
    // Prepare response
    var response: AutoreleasingUnsafeMutablePointer<NSURLResponse?> = nil
    
    // Send authentication differently based on whether access_token is present
    if (access_token == nil) {
        request.setValue("Basic \(base64LoginString)", forHTTPHeaderField: "Authorization")
        println("Using basic authentication")
    } else {
        request.setValue("bearer \(access_token!)", forHTTPHeaderField: "Authorization")
        println("Using token authentication (\(access_token!))")
    }
    
    //
    var error: NSErrorPointer = nil
    var dataVal: NSData? =  NSURLConnection.sendSynchronousRequest(request, returningResponse: response, error:nil)
    var err: NSError
    
    println("API call: \(api)\nPOST data: \(postdata)")
    
    if (dataVal != nil) {
        var jsonResult: NSDictionary = NSJSONSerialization.JSONObjectWithData(dataVal!, options: NSJSONReadingOptions.MutableContainers, error: nil) as NSDictionary
        
        println("Query Result:\n\(jsonResult)")
        return jsonResult
    }
    
    return nil
}


