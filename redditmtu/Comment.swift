//
// Handles comment loading via JSON
// Alex Dinsmoor, Brandon Dusseau, Clayton Marriott, Chris Wallis
//

import Foundation

class Comment {
    
    //var replies : [Comment]
    var author: String
    var score : Int
    var body : String
    var subreddit: String
    
    //Data should just be the dictionary that contains the data relavent to the commnet
    init(data: NSDictionary) {
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
            var temp = 0
            for result in allResults {
                temp++
                if(temp+1 < allResults.count){
                var resultsArr: NSDictionary = result["data"] as NSDictionary
                var newComment = Comment(data: resultsArr)
                comments.append(newComment)
                }
                
            }
        }
        
        return comments
    }

    
}