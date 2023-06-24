//
//  LUStateData.swift
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
import Combine
import Lottie

/// The Lottie status information.
final public class LUStateData: Equatable {
    
    /// The type to load animation models.
    let type: LULoadType
    /// Sets the speed of the animation playback. Defaults to 1
    let speed: Double
    /// Defines animation loop behavior `LottieLoopMode`
    let loopMode: LottieLoopMode
    /// Plays the animation from a progress (0-1) to a progress (0-1).
    let range: LUProgressRange
    /// Setting value will stop the current animation. The default value is `false`
    var isControlEnabled: Bool = false
    
    /// An optional completion closure to be called when the animation completes playing.
    let onCompleted = PassthroughSubject<Bool, Never>()
    /// An optional completion closure to be called when the animation model has completes loading.
    let onDownloaded = PassthroughSubject<Bool, Never>()
    /// Sets the layout of the content
    let contentMode: ContentMode
    
    public init() {
        self.type = .name("", .main)
        self.speed = 1.0
        self.loopMode = .loop
        self.range = LUProgressRange()
        self.contentMode = .fit
    }
    
    
    /// Initialize `LUStateData`
    ///
    /// - Parameters:
    ///   - type: The type to load animation models.
    ///   - speed: Sets the speed of the animation playback. Defaults to 1
    ///   - loopMode: Defines animation loop behavior `LottieLoopMode`
    ///   - range: Plays the animation from a progress (0-1) to a progress (0-1).
    ///   - isControlEnabled: Setting value will stop the current animation. The default value is `false`
    ///   - contentView: Sets the layout of the content. Defaults to `.scaleAspectFit`
    ///
    public init(type: LULoadType,
                speed: Double = 1.0,
                loopMode: LottieLoopMode = .loop,
                range: LUProgressRange? = nil,
                isControlEnabled: Bool = false,
                contentMode: ContentMode = .fit) {
        self.type = type
        self.speed = speed
        self.loopMode = loopMode
        self.range = range ?? LUProgressRange()
        self.isControlEnabled = isControlEnabled
        self.contentMode = contentMode
    }
    
    public static func == (lhs: LUStateData, rhs: LUStateData) -> Bool {
        return lhs.type == rhs.type &&
        lhs.speed == rhs.speed &&
        lhs.loopMode == rhs.loopMode &&
        lhs.range == rhs.range &&
        lhs.isControlEnabled == rhs.isControlEnabled &&
        lhs.contentMode == rhs.contentMode
    }
}
