//
//  HTTPReq.swift
//  Tweetson
//
//  Created by MTLab on 17/01/16.
//  Copyright © 2016 dare. All rights reserved.
//

import Alamofire

public protocol WebServiceResultDelegate
{
    func getResult(result: AnyObject)
}

public class HTTPReq
{
    private var delegate: WebServiceResultDelegate?
    
    public init(delegate: WebServiceResultDelegate)
    {
        self.delegate = delegate
    }
    
    public func httprequest(method: Alamofire.Method,url: String, headers: [String:String], parameters: [String:String])
    {
        Alamofire.request(method, url,headers: headers, parameters: parameters)
            .responseJSON { response in
                if let json = response.result.value{
                    
                    self.delegate?.getResult(json)
                    
                }
        }
    }
}