//
//  TweetCell.swift
//  Tweetson
//
//  Created by MTLab on 17/01/16.
//  Copyright © 2016 dare. All rights reserved.
//

import UIKit

class TweetCell: UITableViewCell {

    let name = UILabel()
    let urlButton = UIButton()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        name.translatesAutoresizingMaskIntoConstraints = false
        urlButton.translatesAutoresizingMaskIntoConstraints = false
        
        urlButton.addTarget(
            self,
            action: "openUrl",
            forControlEvents: UIControlEvents.TouchUpInside
        )
        
        contentView.addSubview(name)
        contentView.addSubview(urlButton)
        
        let viewsDict = [
            "text" : name,
            "url" : urlButton
        ]
        
    }
    
    func openUrl(sender: UIButton!)
    {
        let targetUrl = NSURL(string: (sender.titleLabel?.text)!)
        
        let application = UIApplication.sharedApplication()
        
        application.openURL(targetUrl!)
    }

}
