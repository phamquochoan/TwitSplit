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
    
    func splitMessage(message: String) throws -> [String] {
        let messageContent = message.trimmingCharacters(in: .whitespaces)
        if messageContent.count <= Config.TweetLength { return [messageContent] }
        userInputMessage = messageContent
        try processMessage(messageContent)
    
        return items.map { $0.displayText }
    }
    
    private func processMessage(_ message: String, validating: Bool = false) throws {
        
        guard !message.isEmpty else {
            items = updateCounters(in: items)
            try scanForInvalidTweet()
            return
        }
        
        let counter = Counter(index: items.count + 1, total: total + (validating ? 0 : 1))
        let tweetStartIndex: String.Index = message.startIndex
        let tweetEndIndex: String.Index = try getTweetEndIndex(in: message, counter: counter)
        
        items += [
            Tweet(
                counter: counter,
                content: message[tweetStartIndex..<tweetEndIndex].toString(),
                tweetStartIndex: tweetStartIndex,
                tweetEndIndex: tweetEndIndex
            )
        ]
        
        /// index(after:) is needed to trim the first white spaces on the next message
        /// trimmingCharacters(.whiteSpaces) will violate data intergrity
        let nextString = message.suffix(from: message.index(after: tweetEndIndex)).toString()
        try processMessage(nextString)
    }
    
    private func getNextSearchRange(in message: String, counter: Counter) -> Range<String.Index> {
        let offset = min(message.count, Config.TweetLength - counter.displayText.count)
        let endIndex = message.index(message.startIndex, offsetBy: offset)
        return Range<String.Index>(message.startIndex..<endIndex)
    }
    
    private func getTweetEndIndex(in message: String, counter: Counter) throws -> String.Index {
        
        /// Search for a `whiteSpace` backward in a valid range (include counter.characters.count)
        if let validRange = message.range(of: " ", options: .backwards, range: getNextSearchRange(in: message, counter: counter), locale: nil) {
            return validRange.lowerBound
        }
        
        let nextIndex: String.Index
        
        /// Search for `whiteSpace` forward in case we didn't found it in an allowed range
        /// It maybe too long or at the end of message
        if let range = message.range(of: " ") {
            nextIndex = range.lowerBound
        } else {
            nextIndex = message.endIndex
        }
        
        /// If `message` contains a word that its length + current counter length > allowed
        /// Throw an error
        if message.distance(from: message.startIndex, to: nextIndex) + counter.displayText.count > Config.TweetLength {
            throw SplitError.exceedsWordLength(message[message.startIndex..<nextIndex].toString())
        }
        
        return message.endIndex
    }
    
    private func updateCounters(in items: [Tweet]) -> [Tweet] {
        return items.map {
            Tweet(tweet: $0, counter: Counter(counter: $0.counter, total: total))
        }
    }
    
    private func scanForInvalidTweet() throws {
        guard let index = items.index(where: { $0.invalidTweet }) else { return }
        items[index..<items.count] = []
        let string: String
        if let lastItem = items.last {
            string = userInputMessage[lastItem.tweetEndIndex..<userInputMessage.endIndex].trimmingCharacters(in: .whitespaces)
        } else {
            string = userInputMessage
        }
        try processMessage(string, validating: true)
        
    }
   
}
