//
//  LUContent.swift
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

#if os(iOS)
/// Tthe content view used by iOS.
struct LUContent: UIViewRepresentable, LUStateProtocol {
    
    /// The Lottie status information.
    var state: LUStateData
    /// The size of the view to be updated.
    var size: CGSize
    /// The current animation time with a progress value. The default value is 0.
    var value: CGFloat = 0
    
    /// Initialize `LUContent`
    ///
    /// - Parameters:
    ///   - state: The Lottie status information.
    ///   - size: The size of the view to be updated.
    ///   - value: The current animation time with a progress value. The default value is 0.
    ///
    init(state: LUStateData, size: CGSize, _ value: CGFloat) {
        self.state = state
        self.size = size
        self.value = value
    }
    
    /// Creates the view object and configures its initial state.
    func makeUIView(context: UIViewRepresentableContext<LUContent>) -> UIView {
        let view = LUView(frame: CGRect(x: 0, y: 0, width: size.width, height: size.height))
        view.setAnimation(self.state)
        return view
    }
    
    /// Updates the state of the specified view with new information from SwiftUI.
    func updateUIView(_ uiView: UIView, context: Context) {
        guard let view = uiView as? LUView else { return }
        
        /// Setting value will stop the current animation.
        if value > 0 { state.isControlEnabled = true }
        if state.isControlEnabled {
            view.currentProgress = value
        }
    }
}
#else
/// The content view used by macOS.
struct LUContent: NSViewRepresentable, LUStateProtocol {
    
    /// Lottie status information.
    var state: LUStateData
    /// The size of the view to be updated.
    var size: CGSize
    /// The current animation time with a progress value. The default value is 0.
    var value: CGFloat = 0
    
    /// Initialize `LUContent`
    ///
    /// - Parameters:
    ///   - state: The Lottie status information.
    ///   - size: The size of the view to be updated.
    ///   - value: The current animation time with a progress value. The default value is 0.
    ///
    init(state: LUStateData, size: CGSize, _ value: CGFloat) {
        self.state = state
        self.size = size
        self.value = value
    }
    
    /// Creates the view object and configures its initial state.
    func makeNSView(context: NSViewRepresentableContext<LUContent>) -> NSView {
        let view = LUView(frame: CGRect(x: 0, y: 0, width: size.width, height: size.height))
        view.setAnimation(self.state)
        return view
    }
    
    /// Updates the state of the specified view with new information from SwiftUI.
    func updateNSView(_ nsView: NSView, context: Context) {
        guard let view = nsView as? LUView else { return }
        
        /// Setting value will stop the current animation.
        if value > 0 { state.isControlEnabled = true }
        if state.isControlEnabled {
            view.currentProgress = value
        }
        view.setSize(size)
    }
}
#endif
