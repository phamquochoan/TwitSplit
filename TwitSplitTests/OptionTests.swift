//
//  OptionTests.swift
//  TwitSplitTests
//
//  Created by Hoan Pham on 8/28/17.
//  Copyright © 2017 Hoan Pham. All rights reserved.
//

import XCTest
@testable import TwitSplit

class OptionTests: XCTestCase {
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
    
    func testOptionRemoveMultipleWhiteSpaces() {
        viewModel.options = [.removeMultipleWhiteSpaces]
        
        let stringWithMultipleWhiteSpaces = "   We   want   to see how you   create     a new project   "
        let originalString = "We want to see how you create a new project"
        
        XCTAssertEqual(
            try viewModel.splitMessage(message: stringWithMultipleWhiteSpaces),
            try viewModel.splitMessage(message: originalString)
        )
    }
    
    func testOptionRemoveNewLines() {
        viewModel.options = [.removeNewLines]
        let stringWithMultipleWhiteSpaces = "\nWe want\nto see how you create a new project\n"
        let originalString = "We want to see how you create a new project"
        
        XCTAssertEqual(
            try viewModel.splitMessage(message: stringWithMultipleWhiteSpaces),
            try viewModel.splitMessage(message: originalString)
        )
    }
    
    func testRemoveNewLinesAndWhiteSpaces() {
        viewModel.options = [.removeNewLines, .removeMultipleWhiteSpaces]
        
        let stringWithMultipleWhiteSpaces = "\nWe want\nto see   \n  how you create   a new \n project\n"
        let originalString = "We want to see how you create a new project"
        
        XCTAssertEqual(
            try viewModel.splitMessage(message: stringWithMultipleWhiteSpaces),
            try viewModel.splitMessage(message: originalString)
        )
    }
    
}
