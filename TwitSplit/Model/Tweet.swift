//
//  Tweet.swift
//  TwitSplit
//
//  Created by Hoan Pham on 8/26/17.
//  Copyright © 2017 Hoan Pham. All rights reserved.
//

import Foundation

/*
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
 */

func == (lhs: Tweet, rhs: Tweet) -> Bool {
    return lhs.counter == rhs.counter
}

struct Tweet: Equatable {
    
    /// Counter of this message
    let counter: Counter
    
    /// Content of this splited tweet
    /// Always not empty
    let content: String
    
    /// Start index of this tweet in a message
    let tweetStartIndex: String.Index
    
    /// End index of this tweet in a message
    let tweetEndIndex: String.Index
    
    init(counter: Counter, content: String, tweetStartIndex: String.Index, tweetEndIndex: String.Index) {
        self.counter            = counter
        self.content            = content
        self.tweetStartIndex    = tweetStartIndex
        self.tweetEndIndex      = tweetEndIndex
    }
    
    init(tweet: Tweet, counter: Counter) {
        self.counter            = counter
        self.content            = tweet.content
        self.tweetStartIndex    = tweet.tweetStartIndex
        self.tweetEndIndex      = tweet.tweetEndIndex
    }
    
    /// Length of the first word in content
    /// - Attention:
    ///     In case spilited tweet count change from 10 -> 9
    ///     We have to re-calculate from index where:
    ///     item.remainSpaces >= item[index+1].firstWordLength
    var firstWordLength: String.IndexDistance {
        if let whiteSpaceIndex = content.index(of: " ") {
            return content.distance(from: content.startIndex, to: whiteSpaceIndex)
        }
        return content.distance(from: content.startIndex, to: content.endIndex)
    }
    
    /// Remain spaces in this splited tweet
    var remainSpaces: Int {
        // 1 is the white space between counter and content
        return Config.TweetLength - counter.displayText.count - content.count
    }
    
    var invalidTweet: Bool {
        return remainSpaces < 0
    }
    
    var displayText: String {
        return counter.displayText + content
    }
    
}
