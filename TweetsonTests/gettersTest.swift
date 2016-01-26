//
//  gettersTest.swift
//  Tweetson
//
//  Created by MTLab on 26/01/16.
//  Copyright © 2016 dare. All rights reserved.
//

import XCTest

class gettersTest: XCTestCase {

    var randomQueries:String
        {
        get {
            let array = [
                "Star wars", "#starwars", "LOTR", "Ammon Bundy","#nightlife","restaurants","Ultra Music Festival","#Miami","#NYC","#country","#marines","#usn","#ocean","Canada"
                ,"Croatia","Montreal","Zadar"]
            let randomIndex = Int(arc4random_uniform(UInt32(array.count)))
            return array[randomIndex]
        }
    }
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
//        XCTAssertEqual("Mile zile", randomQueries, "KAKO SAD OPET NIJE??")
        
        for(var i = 0;i<5;i++)
        {
            print(self.randomQueries)
        }
    }

}
