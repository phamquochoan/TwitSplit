//
//  TwitSplitTests.swift
//  TwitSplitTests
//
//  Created by Hoan Pham on 8/26/17.
//  Copyright © 2017 Hoan Pham. All rights reserved.
//

import XCTest
@testable import TwitSplit

class TwitSplitTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        
        let viewModel = TweetViewModel()
        viewModel.options = [.removeMultipleWhiteSpaces, .removeNewLines]
        let string = """
            We want to see how you create a new projectzz and what technologies you decide to you use. A good project will be cleanly structured, will only contain the dependencies it needs, and will be well-documented and well-tested. What matters is not the technologies you use, but the reasons for your decisions. Bonus points will be given for demonstrating knowledge of modern Swift techniques and best practices1. Create an iOS application that serves the Tweeter interface. It will support the following functionality:
                a. Allow the user to input and send messages.
                b Display the user's messages.
                c. If a user's input is less than or equal to 50 characters, post it as is.
                d. If a user's input is greater than 50 characters, split it into chunks that
                each is less than or equal to 50 characters and post each chunk as a separate message.
                e. Messages will only be split on whitespace. If the message contains a span of non-whitespace characters longer than 50 characters, display an error.
                f. Split messages will have a "part indicator" appended to the beginning of each section. In the example above, the message was split into two chunks, so the part indicators read "1/2" an "2/2". Be aware that these count toward the character limit.
                2. The functionality that splits messages should be a standalone function. Given the above example, its function call would look like:
                3. The app must be in Swift.
            """
        do {
            let result = try viewModel.splitMessage(message: string)
            print(result.map { "\($0.count) | \($0)_\n" }.reduce("", +))
        }
        catch {
            print(error)
        }
        
    
        assert(true)
    }
    
    // Test <= 50 characters
    // Test >50 characters (single word)
    // New line characters
    // Test when tweet count 9 -> 10 (length changing)
    // Test when tweet count 10 -> 9 (length changing)
    // Test adding characters in middle of tweet
    // Test deleting characters in middle of tweet
    // Test exceed length word at begin - middle - end of text
    // Test option - preprocess
    // Test validate
    
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
