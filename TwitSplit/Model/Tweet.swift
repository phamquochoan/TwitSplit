//
//  Tweet.swift
//  TwitSplit
//
//  Created by Hoan Pham on 8/26/17.
//  Copyright © 2017 Hoan Pham. All rights reserved.
//

import Foundation

struct Tweet {
    
    var splitedTweetCountChanged: ((Int, Int) -> Void)?
    
    /// The original data user input
    var userInputMessage: String
    
    /// The part that hasn't pushed into `items`
    /// The performance will be slight affect if we accessing and modifying `items.last` all the times.
    /// Instead, we will process and push it into `items` when it exceeds the rules.
    /// - Attention: On the edge case, where `remainsMessage.count` > 0 && `items.count` == 9 (or 99)
    /// We have to re-calculate from index where `items.remainSpaces == 0`
    var remainsMessage: String {
        guard let lastItem = items.last else { return userInputMessage }
        // index(after:) will remove the first white space
        return userInputMessage
            .suffix(from: userInputMessage.index(after: lastItem.tweetEndIndex))
            .string
    }
    
    var count: Int {
        return items.count
    }
    
    var items: [SplitedTweet] {
        didSet {
            guard let handler = splitedTweetCountChanged else { return }
            let oldDigits = String(oldValue.count).count
            let newDigits = String(items.count).count
            if  oldDigits != newDigits  {
                handler(oldDigits, newDigits)
            }
        }
    }
}
