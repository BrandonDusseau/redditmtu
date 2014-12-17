//
// Handles view for account details
// Alex Dinsmoor, Brandon Dusseau, Clayton Marriott, Chris Wallis
//

import UIKit

class AccountViewController: UIViewController {
    
    var username: String!
    var accountDate: String!
    var commentKarma: String!
    var linkKarma: String!
    
    @IBOutlet weak var userLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var linkKarmaLabel: UILabel!
    @IBOutlet weak var commentKarmaLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        userLabel.text = username
        dateLabel.text = accountDate
        commentKarmaLabel.text = commentKarma
        linkKarmaLabel.text = linkKarma
    }
    
    @IBAction func logout() {
        auth_token = nil
        refresh_token = nil
        navigationController?.popViewControllerAnimated(true)
        
        // Get rid of the cookies from the login
        let storage : [NSHTTPCookie] = NSHTTPCookieStorage.sharedHTTPCookieStorage().cookies as [NSHTTPCookie]
        for current in storage {
            NSHTTPCookieStorage.sharedHTTPCookieStorage().deleteCookie(current)
        }
    }
}