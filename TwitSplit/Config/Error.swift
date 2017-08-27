//
//  Error.swift
//  TwitSplit
//
//  Created by Hoan Pham on 8/27/17.
//  Copyright © 2017 Hoan Pham. All rights reserved.
//

import Foundation

enum SplitError: Error {
    case exceedsWordLength(String)
}
