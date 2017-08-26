//
//  SplitedTweet.swift
//  TwitSplit
//
//  Created by Hoan Pham on 8/26/17.
//  Copyright © 2017 Hoan Pham. All rights reserved.
//

import Foundation

func == (lhs: SplitedTweet, rhs: SplitedTweet) -> Bool {
    return lhs.index == rhs.index
}

struct SplitedTweet: Equatable {
    
    /// Index of this one inside a tweet
    let index: Int
    
    /// Number of characters of current splited tweet count in a message
    let tweetCountDigits: Int
    
    /// Content of this splited tweet
    /// Always not empty
    let content: String
    
    /// End index of this tweet in a message
    let messageEndIndex: String.Index
    
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
        return Config.TweetLength - String(index).count - tweetCountDigits - Config.Joinner.count - content.count - 1
    }
    
    
}
