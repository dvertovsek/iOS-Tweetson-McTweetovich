//
//  semaphoretests.swift
//  Tweetson
//
//  Created by MTLab on 25/01/16.
//  Copyright © 2016 dare. All rights reserved.
//

import XCTest

class semaphoretests: XCTestCase {

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testExample() {
//        let semaphore = dispatch_semaphore_create(0) // 1
        
        let expectation = expectationWithDescription("fail!")
                dispatch_async(dispatch_get_global_queue(QOS_CLASS_BACKGROUND, 0), {
                        NSThread.sleepForTimeInterval(5)
                        expectation.fulfill()
//                        dispatch_semaphore_signal(semaphore)
                })
//        dispatch_semaphore_wait(sem, DISPATCH_TIME_FOREVER){
//            XCTFail()
//        }
            waitForExpectationsWithTimeout(6, handler: nil)
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measureBlock {
            // Put the code you want to measure the time of here.
        }
    }

}
