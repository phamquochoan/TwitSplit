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
    
    /// This test depends on the number of objects that are allowed
    /// to push into a stack
    /// May varies from 3000~4000 objects (iMac, MBP ...)
    func testPerformanceExample() {
        viewModel.options = [.removeMultipleWhiteSpaces, .removeNewLines]
        guard let path = Bundle.main.path(forResource: "Big", ofType: "txt") else { return }
        let string = try! String(contentsOfFile: path).replacingOccurrences(of: "\"", with: "")
        self.measure {
            _ = try! viewModel.splitMessage(message: string)
        }
    
        assert(true)
    }
    
}
