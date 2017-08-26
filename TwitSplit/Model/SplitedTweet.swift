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
    let index: Int
    
    var content: String
}
