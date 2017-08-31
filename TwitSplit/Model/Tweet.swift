//
//  Tweet.swift
//  TwitSplit
//
//  Created by Hoan Pham on 8/26/17.
//  Copyright © 2017 Hoan Pham. All rights reserved.
//

import Foundation

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
        return Config.tweetLimit - counter.displayText.count - content.count
    }
    
    var invalidTweet: Bool {
        return remainSpaces < 0
    }
    
    var displayText: String {
        return counter.displayText + content
    }
    
}
