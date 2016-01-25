//
//  dictTest.swift
//  Tweetson
//
//  Created by MTLab on 25/01/16.
//  Copyright © 2016 dare. All rights reserved.
//

import XCTest

class dictTest: XCTestCase {

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    var tweetArray = [String]()
    var tableView = [String]()
    
    var isAlreadyInserted = [Int:Bool]()
    
    func testExample() {
    
        tweetArray.append("ios")
        isAlreadyInserted[tweetArray.count-1] = false
        insertCell(tweetArray.count-1)
        
        tweetArray.append("android")
        isAlreadyInserted[tweetArray.count-1] = false
        insertCell(tweetArray.count-1)
        
        tweetArray.append("gass auto")
        isAlreadyInserted[tweetArray.count-1] = false
        insertCell(tweetArray.count-1)
        
        for (key,value) in isAlreadyInserted{
            print(key," ==> ",value)
        }
        
        insertCell(0)
        insertCell(1)
        insertCell(2)
        insertCell(0)
        insertCell(1)
        insertCell(2)
        insertCell(0)
        insertCell(1)
        insertCell(2)
        insertCell(3)
        insertCell(4)
        insertCell(5)
        
        print(tableView)
//        let index = dictionary.startIndex.advancedBy(0)
//        let value = dictionary.keys[index]
//        print(value)
        
    }

    private func insertCell(indexPath: Int)
    {
        print("i want to insert a cell at index", indexPath)
        if (isAlreadyInserted[indexPath] == false)
        {
            tableView.append(tweetArray[indexPath])
            print("cell inserted at index",indexPath)
            isAlreadyInserted[indexPath] = true
        }
    }

}
