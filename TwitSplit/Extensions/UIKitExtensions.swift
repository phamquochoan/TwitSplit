//
//  UIKitExtensions.swift
//  TwitSplit
//
//  Created by Hoan Pham on 8/30/17.
//  Copyright © 2017 Hoan Pham. All rights reserved.
//

import UIKit

extension UIColor {
    func alpha(_ value: CGFloat) -> UIColor {
        return withAlphaComponent(value)
    }
}
