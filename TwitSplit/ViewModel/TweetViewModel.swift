//
//  TweetViewModel.swift
//  TwitSplit
//
//  Created by Hoan Pham on 8/27/17.
//  Copyright © 2017 Hoan Pham. All rights reserved.
//

import Foundation

class TweetViewModel {
    var items: [Tweet]              = []
    var counterDigits: Counter      = Counter(index: 1, total: 1)
    var userInputMessage: String    = ""
    
    
    func processMessage(_ string: String, completionHandler: (() -> Void)) {
        
        guard !string.isEmpty else {
            items = updateCounters(in: items)
            completionHandler()
            return
        }
        
        let searchingRange = Range<String.Index>(string.startIndex..<string.index(string.startIndex, offsetBy: Config.TweetLength))
        let range: Range<String.Index>
        
        if let x = string.range(of: " ", options: .backwards, range: searchingRange, locale: nil) {
            range = x
        } else {
            range = Range<String.Index>(string.startIndex..<string.endIndex)
        }
        
        items += [
            Tweet(
                counter: counterDigits,
                content: string[range.lowerBound...range.upperBound].toString(),
                tweetStartIndex: range.lowerBound,
                tweetEndIndex: range.upperBound
            )
        ]
        
        counterDigits = Counter(index: counterDigits.index + 1, total: counterDigits.total + 1)
        
        let nextString = string.suffix(from: string.index(after: range.upperBound)).toString()
        processMessage(nextString, completionHandler: completionHandler)
    }
    
    func updateCounters(in items: [Tweet]) -> [Tweet] {
        return items.map {
            Tweet(tweet: $0, counter: Counter(counter: $0.counter, total: counterDigits.total))
        }
    }
   
}
