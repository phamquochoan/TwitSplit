//
//  Counter.swift
//  TwitSplit
//
//  Created by Hoan Pham on 8/27/17.
//  Copyright © 2017 Hoan Pham. All rights reserved.
//

import Foundation

func == (lhs: Counter, rhs: Counter) -> Bool {
    return lhs.index == rhs.index
}

/// The counter for each Splited Tweet
struct Counter: Equatable {
    let index: Int
    let total: Int
    
    init(index: Int, total: Int) {
        self.index = index
        self.total = total
    }
    
    init(counter: Counter, total: Int) {
        self.index = counter.index
        self.total = total
    }
    
    var displayText: String {
        return String(index) + Config.Joinner + String(total) + " "
    }
}
