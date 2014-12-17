//
// Handles view for account details
// Alex Dinsmoor, Brandon Dusseau, Clayton Marriott, Chris Wallis
//

import UIKit

class AccountViewController: UIViewController {
    
    // Variables to set before segue
    var username: String!
    var accountDate: String!
    var commentKarma: String!
    var linkKarma: String!
    
    // Outlets for UI
    @IBOutlet weak var userLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var linkKarmaLabel: UILabel!
    @IBOutlet weak var commentKarmaLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the labels to the given information
        userLabel.text = username
        dateLabel.text = accountDate
        commentKarmaLabel.text = commentKarma
        linkKarmaLabel.text = linkKarma
    }
    
    // Gets called when "Logout" button is pressed
    @IBAction func logout() {
        
        // Delete tokens so another user can login
        auth_token = nil
        refresh_token = nil
        navigationController?.popViewControllerAnimated(true)
        
        // Get rid of the cookies from the previous login
        let storage : [NSHTTPCookie] = NSHTTPCookieStorage.sharedHTTPCookieStorage().cookies as [NSHTTPCookie]
        for current in storage {
            NSHTTPCookieStorage.sharedHTTPCookieStorage().deleteCookie(current)
        }
    }
}