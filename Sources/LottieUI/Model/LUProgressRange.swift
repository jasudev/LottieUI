//
//  LUProgressRange.swift
//  LottieUI
//
//  Created by jasu on 2022/02/10.
//  Copyright (c) 2022 jasu All rights reserved.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is furnished
//  to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED,
//  INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A
//  PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
//  HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF
//  CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE
//  OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
//

import SwiftUI
import Lottie

/// Plays the animation from a progress (0-1) to a progress (0-1).
public struct LUProgressRange: Equatable {
    
    /// The start progress of the animation.
    var from: AnimationProgressTime = 0.0
    /// The end progress of the animation.
    var to: AnimationProgressTime = 1.0
    
    /// Plays the animation from a progress (0-1) to a progress (0-1).
    ///
    /// - Parameters:
    ///   - from: The start progress of the animation.
    ///   - to: The end progress of the animation.
    ///
    public init(from: AnimationProgressTime = 0.0, to: AnimationProgressTime = 1.0) {
        self.from = from
        self.to = to
    }
    
    public static func == (lhs: LUProgressRange, rhs: LUProgressRange) -> Bool {
        return lhs.from == rhs.from && lhs.to == rhs.to
    }
}
