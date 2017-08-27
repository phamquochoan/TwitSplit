//
//  TweetViewModel.swift
//  TwitSplit
//
//  Created by Hoan Pham on 8/27/17.
//  Copyright © 2017 Hoan Pham. All rights reserved.
//

import Foundation

class TweetViewModel {
    
    /// `Tweet` storage
    var items: [Tweet]              = []
    
    /// User input message
    var userInputMessage: String    = ""
    
    /// Maxium tweet count for the current `userInputMessage`
    var totalTweets: Int = 0
    
    func splitMessage(message: String) throws -> [String] {
        let messageContent = message.trimmingCharacters(in: .whitespaces)
        if messageContent.count <= Config.TweetLength { return [messageContent] }
        items = []
        totalTweets = 0
        userInputMessage = messageContent
        try processMessage(messageContent, validating: false)
    
        return items.map { $0.displayText }
    }
    
    /// Convert message into multiple `Tweet` and store them
    ///
    /// - Note:
    /// This function will split `message` continuously (recursively) and create a `Tweet` on each valid part of `message`
    /// Contains two steps, indicate by `validating` parameter:
    ///   - processing: create `Tweet` with 1/1, 2/2, 3/3, ... counter
    ///   - validating: update counter in each `Tweet` to 1/3, 2/3, 3/3 ..
    ///     If there is an invalid `Tweet` after update (3/3 -> 3/100 | length 49 -> 51)
    ///     Then re-calculate all stored `Tweet` from that invalid index
    /// - Parameters:
    ///   - message: the remains of message
    ///   - validating: final step that validate every `Tweet` before finish.
    ///     False: increase counter after each loop | True: stop increase counter
    /// - Throws: error if contains an exceed word
    private func processMessage(_ message: String, validating: Bool) throws {
        
        guard !message.isEmpty else {
            try validateTweets()
            return
        }
        
        /// - processing: totalTweets = item.count + 1
        /// - validating: get max of `totalTweets` and count
        /// In case item.count keeps increasing
        /// For example: 999 -> 1000 (then we will have to validate one more time)
        totalTweets = max(items.count + 1, totalTweets + (validating ? 0 : 1))
        let counter = Counter(index: items.count + 1, total: totalTweets)
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
        try processMessage(nextString, validating: validating)
    }
    
    
    /// Get the next search `range` in `message`
    ///
    /// - Parameters:
    ///   - message: message
    ///   - counter: counter a.k.a. prefix for current `Tweet`
    /// - Returns: valid and searchable range in message
    private func getNextSearchRange(in message: String, counter: Counter) -> Range<String.Index> {
        let offset = min(message.count, Config.TweetLength - counter.displayText.count)
        let endIndex = message.index(message.startIndex, offsetBy: offset)
        return Range<String.Index>(message.startIndex..<endIndex)
    }
    
    
    /// Get the next end index in `message` in order to create a new `Tweet`
    ///
    /// - Parameters:
    ///   - message: message
    ///   - counter: counter for current `Tweet`
    /// - Returns: index inside the message
    /// - Throws:
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
    
    
    /// Update `counter` in `Tweet`s
    ///
    /// - Parameter items: items that need to be updated
    /// - Returns: updated `Tweet`s
    private func updateCounters(in items: [Tweet]) -> [Tweet] {
        return zip((1...items.count), items)
            .map { [count = items.count] index, item in
                Tweet(tweet: item, counter: Counter(index: index, total: count))
            }
    }
    
    
    /// Validate `Tweet`s value
    /// If there is an invalid tweet, re-calculate from its index
    ///
    /// - Throws:
    private func validateTweets() throws {
        items = updateCounters(in: items)
        guard let index = items.index(where: { $0.invalidTweet }) else { return }
        items[index..<items.count] = []
        let string: String
        if let lastItem = items.last {
            string = userInputMessage[userInputMessage.index(after: lastItem.tweetEndIndex)..<userInputMessage.endIndex].toString()
        } else {
            string = userInputMessage
        }
        try processMessage(string, validating: false)
        
    }
   
}
