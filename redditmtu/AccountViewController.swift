//
//  AccountViewController.swift
//  redditmtu
//
//  Created by Clayton Marriott on 12/16/14.
//
//

import UIKit

class AccountViewController: UIViewController {
    
    var username: String?
    var accountDate: String?
    
    @IBOutlet weak var userLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        userLabel.text = username
        dateLabel.text = accountDate
    }
}