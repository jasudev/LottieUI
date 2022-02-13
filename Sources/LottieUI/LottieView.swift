//
//  LottieView.swift
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

public struct LottieView: View, LUStateProtocol {
    
    /// The Lottie status information.
    var state: LUStateData = .init()
    /// The current animation time with a progress value. The default value is 0.
    var value: CGFloat = 0
    private var cancellables = Set<AnyCancellable>()
    
    /// Initialize `LottieView`
    ///
    /// - Parameters:
    ///   - state: The Lottie status information.
    ///   - value: The current animation time with a progress value. Note: Setting this will stop the current animation.
    ///   - onCompleted: An optional completion closure to be called when the animation completes playing.
    ///   - onDownloaded: An optional completion closure to be called when the animation model has completes loading.
    ///
    public init(state: LUStateData, value: CGFloat = 0,
                onCompleted: @escaping (Bool) -> Void = { _ in },
                onDownloaded: @escaping (Bool) -> Void = { _ in }) {
        self.state = state
        self.value = value
        
        self.state.onCompleted
            .sink(receiveValue: onCompleted)
            .store(in: &cancellables)
        self.state.onDownloaded
            .sink(receiveValue: onDownloaded)
            .store(in: &cancellables)
    }
    
    public var body: some View {
        GeometryReader { proxy in
            ZStack {
                Color.clear
                LUContent(state: state, size: proxy.size, value)
            }
        }
    }
}

struct LottieView_Previews: PreviewProvider {
    static var previews: some View {
        LottieView(state: LUStateData(), value: 0)
    }
}
