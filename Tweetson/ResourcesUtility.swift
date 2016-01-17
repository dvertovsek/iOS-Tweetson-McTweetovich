//
//  Resources.swift
//  Tweetson
//
//  Created by MTLab on 17/01/16.
//  Copyright © 2016 dare. All rights reserved.
//

public class ResourcesUtility
{
    //Im not gonna let you see my twitter API key!
    static let consumerKey = ResourcesUtility.getObfuscator("swift").reveal(MyObjectiveCInterface.getKey())
    static let consumerSecret = ResourcesUtility.getObfuscator("swift").reveal(MyObjectiveCInterface.getSecret())
    
    static var bearerToken = "none"
    
    static func getObfuscator(salt:String)->Obfuscator
    {
        return Obfuscator.newWithSaltUnsafe(salt)
    }
    
    static func encodeKeyAndSecret()->String
    {
        let urlEncodedConsKey: String = consumerKey.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())!
        let urlEncodedConsSecret: String = consumerSecret.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())!
        let keySecret = urlEncodedConsKey + ":" + urlEncodedConsSecret
        let utf8str = keySecret.dataUsingEncoding(NSUTF8StringEncoding)
        if let base64EncodedString = utf8str?.base64EncodedStringWithOptions(NSDataBase64EncodingOptions(rawValue: 0))
        {
            return base64EncodedString
        }
        return ""
    }
    
    
    
    
}