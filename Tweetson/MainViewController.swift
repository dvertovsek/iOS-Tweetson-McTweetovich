//
//  MainViewController.swift
//  Tweetson
//
//  Created by MTLab on 16/01/16.
//  Copyright © 2016 dare. All rights reserved.
//

import UIKit

import TwitterKit

class MainViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "My view"
        self.view.backgroundColor = UIColor.grayColor()
        
        let openItem = UIBarButtonItem(image: UIImage(named :"open"), style: UIBarButtonItemStyle.Plain, target: self, action: "onOpenButtonPressed")
//        openItem.enabled = false
        self.navigationItem.leftBarButtonItem = openItem
        
        let logInButton = TWTRLogInButton { (session, error) in
            if let unwrappedSession = session {
                
                openItem.enabled = true
                
                let alert = UIAlertController(title: "Logged In",
                    message: "User \(unwrappedSession.userName) has logged in",
                    preferredStyle: UIAlertControllerStyle.Alert
                )
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
                self.presentViewController(alert, animated: true, completion: nil)
            } else {
                NSLog("Login error: %@", error!.localizedDescription);
            }
        }
        
        // TODO: Change where the log in button is positioned in your view
        logInButton.center = self.view.center
        
        self.view.addSubview(logInButton)

        //Tweet view example
        // TODO: Base this Tweet ID on some data from elsewhere in your app
        TWTRAPIClient().loadTweetWithID("631879971628183552") { (tweet, error) in
            if let unwrappedTweet = tweet {
                let tweetView = TWTRTweetView(tweet: unwrappedTweet)
                tweetView.center = CGPointMake(self.view.center.x, self.topLayoutGuide.length + tweetView.frame.size.height / 2);
                self.view.addSubview(tweetView)
            } else {
                NSLog("Tweet load error: %@", error!.localizedDescription);
            }
        }

    }
    
    @IBAction private func onOpenButtonPressed()
    {
        let a = self.sideMenuViewController?.menuViewController as! MenuViewController
        
        a.animate()
        
        self.sideMenuViewController?.openMenuAnimated(true, completion:nil)
    }
}
