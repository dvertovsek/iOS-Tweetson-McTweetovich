//
//  TweetTableViewController.swift
//  Tweetson
//
//  Created by MTLab on 25/01/16.
//  Copyright © 2016 dare. All rights reserved.
//

import UIKit
import CoreLocation

import ws
import SwiftyJSON
import Alamofire

import TwitterKit

public class TweetTableViewController: UIViewController {
    
    @IBOutlet weak var scrollView: UIScrollView!
    private static var scrollViewContentSize: CGFloat = 0
    private static var yPosition: CGFloat = 0
    
    public var location = CLLocation()
    public var query = String()
    
    var httpreq: HTTPReq!
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        
        let sgr = UISwipeGestureRecognizer.init(target: self, action: "handleSwipeLeft:")
        sgr.direction = UISwipeGestureRecognizerDirection.Left;
        view.addGestureRecognizer(sgr)
        
        httpreq = HTTPReq(delegate: self)
        
        let headers = [
            "Authorization" : "Bearer "+ResourcesUtility.bearerToken
        ]
        let lat = String(location.coordinate.latitude)
        let long = String(location.coordinate.longitude)
        let params = [
            "q" : query,
            "geocode" : lat+","+long+",50km"
        ]
        httpreq.httprequest(Alamofire.Method.GET, url: "https://api.twitter.com/1.1/search/tweets.json", headers: headers, parameters: params)
    }
    
    func handleSwipeLeft(gesture: UIGestureRecognizer){
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}

extension TweetTableViewController: WebServiceResultDelegate
{
    public func getResult(result: AnyObject) {
        let jsonStatuses = JSON(result)["statuses"]
        
        TweetTableViewController.scrollViewContentSize = 0
        TweetTableViewController.yPosition = 0
        
        for (_,status) in jsonStatuses {
            
            TWTRAPIClient().loadTweetWithID(String(status["id"])) { (tweet, error) in
                if let unwrappedTweet = tweet {
                    let tweetView = TWTRTweetView(tweet: unwrappedTweet)
                    tweetView.center = CGPointMake(self.view.center.x, self.topLayoutGuide.length + tweetView.frame.size.height / 2);
                    
                    tweetView.contentMode = UIViewContentMode.ScaleAspectFit
                    
                    tweetView.frame.origin.y = TweetTableViewController.yPosition
                    
                    print("adding tweet to scroll view:",unwrappedTweet.tweetID)
                    self.scrollView.addSubview(tweetView)
                    
                    TweetTableViewController.yPosition += tweetView.frame.size.height + 20
                    TweetTableViewController.scrollViewContentSize += tweetView.frame.size.height
                    
                    self.scrollView.contentSize = CGSize(width: tweetView.frame.size.width, height: TweetTableViewController.scrollViewContentSize)
                } else {
                    print("Tweet load error: ",error!.localizedDescription)
                }
            }
        }
    }
}
