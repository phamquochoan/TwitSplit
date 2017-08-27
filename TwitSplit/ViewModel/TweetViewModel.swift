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
    var userInputMessage: String    = ""
    
    var total: Int {
        return items.count
    }
    
    func splitMessage(message: String) -> [String] {
        if message.count <= Config.TweetLength { return [message] }
        userInputMessage = message
        processMessage(message.trimmingCharacters(in: .whitespaces))
        return items.map { $0.displayText }
    }
    
    private func processMessage(_ string: String, validating: Bool = false) throws {
        
        guard !string.isEmpty else {
            items = items.map { Tweet(tweet: $0, counter: Counter(counter: $0.counter, total: total)) }
            scanForInvalidTweet()
            return
        }
        
        let counter = Counter(index: items.count + 1, total: total + (validating ? 0 : 1))
        let tweetStartIndex: String.Index = string.startIndex
        let tweetEndIndex: String.Index
        
        if let x = string.range(of: " ", options: .backwards, range: getNextSearchRange(in: string, counter: counter), locale: nil) {
            tweetEndIndex = x.lowerBound
        } else {
            tweetEndIndex = string.endIndex
        }
        
        items += [
            Tweet(
                counter: counter,
                content: string[tweetStartIndex..<tweetEndIndex].toString(),
                tweetStartIndex: tweetStartIndex,
                tweetEndIndex: tweetEndIndex
            )
        ]
        
        let nextString = string.suffix(from: tweetEndIndex).trimmingCharacters(in: .whitespaces)
        processMessage(nextString)
    }
    
    private func getNextSearchRange(in string: String, counter: Counter) -> Range<String.Index> {
        let offset = min(string.count, Config.TweetLength - counter.displayText.count)
        let endIndex = string.index(string.startIndex, offsetBy: offset)
        return Range<String.Index>(string.startIndex..<endIndex)
    }
    
    private func updateCounters(in items: [Tweet]) -> [Tweet] {
        let result = items.map {
            Tweet(tweet: $0, counter: Counter(counter: $0.counter, total: total))
        }
        
        return result
    }
    
    private func scanForInvalidTweet() {
        guard let index = items.index(where: { $0.invalidTweet }) else { return }
        items[index..<items.count] = []
        let string: String
        if let lastItem = items.last {
            string = userInputMessage[lastItem.tweetEndIndex...userInputMessage.endIndex].trimmingCharacters(in: .whitespaces)
        } else {
            string = userInputMessage
        }
        processMessage(string, validating: true)
        
    }
   
}
