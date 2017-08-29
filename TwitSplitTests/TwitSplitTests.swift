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
    
    let viewModel = TweetViewModel()
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        viewModel.options = .none
        super.tearDown()
    }
    
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        
        
        viewModel.options = [.removeMultipleWhiteSpaces, .removeNewLines]
        
        viewModel.options = [.removeMultipleWhiteSpaces, .removeNewLines]
        guard let path = Bundle.main.path(forResource: "Big", ofType: "txt") else { return }
        let string = try! String(contentsOfFile: path)
        
//        let string = """
//            We want to see how you create a new projectzz and what technologies you decide to you use. A good project will be cleanly structured, will only contain the dependencies it needs, and will be well-documented and well-tested. What matters is not the technologies you use, but the reasons for your decisions. Bonus points will be given for demonstrating knowledge of modern Swift techniques and best practices1. Create an iOS application that serves the Tweeter interface. It will support the following functionality:
//                a. Allow the user to input and send messages.
//                b Display the user's messages.
//                c. If a user's input is less than or equal to 50 characters, post it as is.
//                d. If a user's input is greater than 50 characters, split it into chunks that
//                each is less than or equal to 50 characters and post each chunk as a separate message.
//                e. Messages will only be split on whitespace. If the message contains a span of non-whitespace characters longer than 50 characters, display an error.
//                f. Split messages will have a "part indicator" appended to the beginning of each section. In the example above, the message was split into two chunks, so the part indicators read "1/2" an "2/2". Be aware that these count toward the character limit.
//                2. The functionality that splits messages should be a standalone function. Given the above example, its function call would look like:
//                3. The app must be in Swift.
//            """
        do {
            let result = try viewModel.splitMessage(message: string)
            print(result.map { "\($0.count) | \($0)_\n" }.reduce("", +))
        }
        catch {
            print(error)
        }
        
    
        assert(true)
    }
    
    
    /// Message <= 50 characters
    func testMessageLessThanOrEqualCharactersLimit() {
        let string = "123456789_123456789_123456789_123456789_123456789_"
        XCTAssert(try viewModel.splitMessage(message: string) == [string])
    }
    
    /// Message > 50 characters
    func testMessageExceedCharactersLimit() {
        let string = "123456789_123456789_123456789_123456789_123456789_1"
        XCTAssertThrowsError(try viewModel.splitMessage(message: string))
    }
    
    func testExceedWordAtBeginningOfMessage() {
        let string = "123456789_123456789_123456789_123456789_12345678 - less than 50 characters but still throw error saying that number is too long"
        XCTAssertThrowsError(try viewModel.splitMessage(message: string))
    }
    
    func testExceedWordInMiddleOfMessage() {
        let string = "First tweet content 123456789_123456789_123456789_123456789_12345678 - less than 50 characters but still throw error saying that number is too long"
        XCTAssertThrowsError(try viewModel.splitMessage(message: string))
        
    }
    
    func testExceedWordAtEndOfMessage() {
        let string = "Same as above we put some text first and the exceed word at the end 123456789_123456789_123456789_123456789_12345678"
        XCTAssertThrowsError(try viewModel.splitMessage(message: string))
    }
    
    func testSplitUnderTenPartsMessage() {
        let string = """
        We want to see how you create a new project and what technologies you decide to you use. A good project will be cleanly structured, will only contain the dependencies it needs, and will be well-documented and well-tested. What matters is not the technologies you use, but the reasons for your decisions. Bonus points will be given for demonstrating knowledge of modern Swift techniques and best practices.
        """
        let result = [
            "1/9 We want to see how you create a new project",
            "2/9 and what technologies you decide to you use. A",
            "3/9 good project will be cleanly structured, will",
            "4/9 only contain the dependencies it needs, and",
            "5/9 will be well-documented and well-tested. What",
            "6/9 matters is not the technologies you use, but",
            "7/9 the reasons for your decisions. Bonus points",
            "8/9 will be given for demonstrating knowledge of",
            "9/9 modern Swift techniques and best practices."
        ]
        
        XCTAssertEqual(result, try! viewModel.splitMessage(message: string))
    }
    
    /// Notice the different at the second Tweet with the test above
    func testSplitOverTenPartsMessage() {
        let string = """
        We want to see how you create a new project and what technologies you decide to you use. A good project will be cleanly structured, will only contain the dependencies it needs, and will be well-documented and well-tested. What matters is not the technologies you use, but the reasons for your decisions. Bonus points will be given for demonstrating knowledge of modern Swift techniques and best practices. Create an iOS application that serves the Tweeter interface.
        """
        let result = [
            "1/11 We want to see how you create a new project",
            "2/11 and what technologies you decide to you use.",
            "3/11 A good project will be cleanly structured,",
            "4/11 will only contain the dependencies it needs,",
            "5/11 and will be well-documented and well-tested.",
            "6/11 What matters is not the technologies you use,",
            "7/11 but the reasons for your decisions. Bonus",
            "8/11 points will be given for demonstrating",
            "9/11 knowledge of modern Swift techniques and best",
            "10/11 practices. Create an iOS application that",
            "11/11 serves the Tweeter interface."
        ]
        
        XCTAssertEqual(result, try! viewModel.splitMessage(message: string))
    }
    
    
    func testPerformanceExample() {
//        viewModel.options = [.removeMultipleWhiteSpaces, .removeNewLines]
        guard let path = Bundle.main.path(forResource: "Big", ofType: "txt") else { return }
        let string = try! String(contentsOfFile: path)
        self.measure {
            _ = try! viewModel.splitMessage(message: string)
        }
    
        assert(true)
    }
    
}
