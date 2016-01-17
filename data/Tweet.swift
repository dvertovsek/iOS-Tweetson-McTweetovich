//
//  Tweet.swift
//  Tweetson
//
//  Created by MTLab on 17/01/16.
//  Copyright © 2016 dare. All rights reserved.
//

public class Tweet {
    
    public var name: String
    public var tweetCount: String
    public var url: String
    
    public init(name: String, tweetCount: String, url: String)
    {
        self.name = name
        self.tweetCount = tweetCount
        self.url = url
    }
    
}
