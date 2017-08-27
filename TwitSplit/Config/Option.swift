//
//  Option.swift
//  TwitSplit
//
//  Created by Hoan Pham on 8/27/17.
//  Copyright © 2017 Hoan Pham. All rights reserved.
//

import Foundation

struct SplitOption: OptionSet {
    let rawValue: Int
    
    init(rawValue: Int) {
        self.rawValue = rawValue
    }
    
    static let none                         = SplitOption(rawValue: 0)
    static let removeMultipleWhiteSpaces    = SplitOption(rawValue: 1 << 0)
    static let removeNewLines               = SplitOption(rawValue: 1 << 1)
}
