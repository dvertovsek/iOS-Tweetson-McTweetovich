//
//  ViewController.swift
//  Tweetson
//
//  Created by MTLab on 16/01/16.
//  Copyright © 2016 dare. All rights reserved.
//

import UIKit

import Alamofire
import SwiftyJSON

class ViewController: UIViewController {

    var consumerKey = String()
    var consumerSecret = String()
    
    var base64encoded = String()
    
    var token = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        let o: Obfuscator = Obfuscator.newWithSaltUnsafe("swift")
        
        consumerKey = o.reveal(MyObjectiveCInterface.getKey())
        consumerSecret = o.reveal(MyObjectiveCInterface.getSecret())
        
        let urlEncodedConsKey: String = consumerKey.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())!
        
        let urlEncodedConsSecret: String = consumerSecret.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())!
        
        let keySecret = urlEncodedConsKey + ":" + urlEncodedConsSecret
        let utf8str = keySecret.dataUsingEncoding(NSUTF8StringEncoding)
        
        if let base64EncodedString = utf8str?.base64EncodedStringWithOptions(NSDataBase64EncodingOptions(rawValue: 0))
        {
            base64encoded = base64EncodedString

        }
        
        let headers = [
            "Authorization": "Basic "+base64encoded,
            "Content-Type": "application/x-www-form-urlencoded;charset=UTF-8"
        ]
        let params = ["grant_type" : "client_credentials"]
        
//        Alamofire.request(.POST, "https://api.twitter.com/oauth2/token", headers: headers, parameters: params)
//            .responseJSON { response in
//                
//                let bearerToken = String(JSON(response.result.value!)["access_token"])
//                
//                self.token = bearerToken
//                
//                self.sendRequestToTwitter()
//                
//        }
        
        
        
    }
    
    private func sendRequestToTwitter()
    {
        let headers = [
            "Authorization" : "Bearer "+token
        ]

        let params = [
            "lat" : "37",
            "long" : "-122"
        ]
        Alamofire.request(.GET, "https://api.twitter.com/1.1/trends/closest.json", headers: headers, parameters : params)
            .responseJSON { response in
                
//                print(response.result.value)
                
                let json = JSON(response.result.value!)
                
                let woeid = String(json[0]["woeid"])
                
                self.getTrends(woeid)
        }

    }
    
    private func getTrends(woeid: String)
    {
        let headers = [
            "Authorization" : "Bearer "+token
        ]
        
        let params = [
            "id" : woeid
        ]
        print("get trends for ",woeid,"\n\n")
        Alamofire.request(.GET, "https://api.twitter.com/1.1/trends/place.json", headers: headers, parameters : params)
            .responseJSON { response in
                
                print(response.result.value)
        }

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

