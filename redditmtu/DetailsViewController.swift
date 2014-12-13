//
//  DetailsViewController.swift
//  TableTest
//
//  Created by Alex Dinsmoor on 12/7/14.
//  Copyright (c) 2014 Dinsmoor. All rights reserved.
//

import UIKit

class DetailsViewController: UIViewController {
    
    var post: Post?
    
    @IBOutlet weak var albumCover: UIImageView!
    @IBOutlet weak var postAuthor: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        // super.viewDidLoad()
        titleLabel.text = self.post?.title
        postAuthor.text = self.post?.author
        //albumCover.image = UIImage(data: NSData(contentsOfURL: NSURL(string: self.album!.largeImageURL)!)!)
    }
}