//
//  LUView.swift
//  LottieUI
//
//  Created by jasu on 2022/02/11.
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

import Combine
import Lottie

#if os(iOS) || os(visionOS)
import UIKit
/// A wrapper view for LottieAnimationView. (for iOS)
class LUView: UIView {
    
    private var animationView: LottieAnimationView?
    private var cancellables = Set<AnyCancellable>()
    
    /**
     Sets the current animation time with a progress value.
     Note: Setting this will stop the current animation, if any.
     Note 2: If `animation` is nil, setting this will fallback to 0.
     */
    var currentProgress: AnimationProgressTime {
        get { return animationView?.currentProgress ?? 0 }
        set { animationView?.currentProgress = newValue }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.setSize(self.bounds.size)
    }
    
    /// Create an LottieAnimationView object.
    ///
    /// - Parameters:
    ///   - state: The Lottie status information.
    ///
    func setAnimation(_ state: LUStateData) {
        switch state.type {
            /// Loads an animation model from a bundle by its name.
        case .name(let name, let bundle):
            let aniView = LottieAnimationView(animation: LottieAnimation.named(name, bundle: bundle))
            let loopMode = self.getLoopMode(state: state, aniView: aniView)
            self.setupAnimation(aniView, state: state)
            self.downloaded(state: state, value: true)
            if !state.isControlEnabled {
                DispatchQueue.main.async {
                    self.animationView?.play(fromProgress: state.range.from,
                                             toProgress: state.range.to,
                                             loopMode: loopMode,
                                             completion: { value in
                        self.completed(state: state, value: value)
                    })
                }
            }
            /// Loads a Lottie animation asynchronously from the URL.
        case .loadedFrom(let url):
            var aniView: LottieAnimationView?
            aniView = LottieAnimationView(url: url) { error in
                guard let aniView = aniView else {
                    return
                }
                self.downloaded(state: state, value: error == nil)
                if !state.isControlEnabled {
                    DispatchQueue.main.async {
                        let loopMode = self.getLoopMode(state: state, aniView: aniView)
                        self.animationView?.play(fromProgress: state.range.from,
                                                 toProgress: state.range.to,
                                                 loopMode: state.loopMode,
                                                 completion: { value in
                            state.onCompleted.send(value)
                        })
                    }
                }
            }
            if let aniView = aniView {
                self.setupAnimation(aniView, state: state)
            }
            /// Loads an animation from a specific filepath.
        case .filepath(let path):
            let aniView = LottieAnimationView(filePath: path)
            let loopMode = self.getLoopMode(state: state, aniView: aniView)
            self.setupAnimation(aniView, state: state)
            self.downloaded(state: state, value: true)
            if !state.isControlEnabled {
                DispatchQueue.main.async {
                    self.animationView?.play(fromProgress: state.range.from,
                                             toProgress: state.range.to,
                                             loopMode: loopMode,
                                             completion: { value in
                        self.completed(state: state, value: value)
                    })
                }
            }
        }
    }
    
    /// Stops the animation and resets the view to its start frame.
    func stop() {
        animationView?.stop()
    }
    
    /// Gets the desired loop mode if the animation duration is set
    func getLoopMode(state: LUStateData, aniView: LottieAnimationView) -> LottieLoopMode {
        guard let duration = state.desiredDuration else {
            return state.loopMode
        }
        
        let loopCount = max(1, Int(ceil(duration / TimeInterval(aniView.animation?.duration ?? 0.0))))
        return .repeat(Float(loopCount))
    }
    
    /// Updates the current size of the LottieAnimationView.
    ///
    /// - Parameters:
    ///   - size: Size to update.
    ///
    func setSize(_ size: CGSize) {
        let rect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        self.animationView?.frame = rect
    }
    
    /// An optional completion closure to be called when the animation completes playing.
    private func completed(state: LUStateData, value: Bool) {
        DispatchQueue.main.async {
            state.onCompleted.send(value)
        }
    }
    
    /// An optional completion closure to be called when the animation model has completes loading.
    private func downloaded(state: LUStateData, value: Bool) {
        DispatchQueue.main.async {
            state.onDownloaded.send(value)
        }
    }
    
    /// After setting the LottieAnimationView property, add it to the current view.
    ///
    /// - Parameters:
    ///   - aniView: A new LottieAnimationView object.
    ///   - state: The Lottie status information.
    ///
    private func setupAnimation(_ aniView: LottieAnimationView, state: LUStateData) {
        animationView?.removeFromSuperview()
        self.animationView = aniView
        aniView.contentMode = state.contentMode == .fit ? UIView.ContentMode.scaleAspectFit : UIView.ContentMode.scaleAspectFill
        aniView.loopMode = state.loopMode
        aniView.animationSpeed = state.speed
        self.addSubview(aniView)
    }
}
#else
import Cocoa
/// A wrapper view for LottieAnimationView. (for macOS)
class LUView: NSView {
    
    private var animationView: LottieAnimationView?
    private var cancellables = Set<AnyCancellable>()
    
    /**
     Sets the current animation time with a progress value.
     Note: Setting this will stop the current animation, if any.
     Note 2: If `animation` is nil, setting this will fallback to 0.
     */
    var currentProgress: AnimationProgressTime {
        get { return animationView?.currentProgress ?? 0 }
        set { animationView?.currentProgress = newValue }
    }
    
    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        NotificationCenter.default
            .publisher(for: NSWindow.didResizeNotification)
            .subscribe(on: DispatchQueue.main)
            .sink { [weak self] notification in
                guard let `self` = self else { return }
                self.setSize(self.bounds.size)
            }
            .store(in: &cancellables)
    }
    
    override func resizeSubviews(withOldSize oldSize: NSSize) {
        super.resizeSubviews(withOldSize: oldSize)
        self.setSize(self.bounds.size)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// Create an LottieAnimationView object.
    ///
    /// - Parameters:
    ///   - state: The Lottie status information.
    ///
    func setAnimation(_ state: LUStateData) {
        switch state.type {
            /// Loads an animation model from a bundle by its name.
        case .name(let name, let bundle):
            let aniView = LottieAnimationView(animation: LottieAnimation.named(name, bundle: bundle))
            self.setupAnimation(aniView, state: state)
            self.downloaded(state: state, value: true)
            if !state.isControlEnabled {
                DispatchQueue.main.async {
                    self.animationView?.play(fromProgress: state.range.from,
                                             toProgress: state.range.to,
                                             loopMode: state.loopMode,
                                             completion: { value in
                        self.completed(state: state, value: value)
                    })
                }
            }
            /// Loads a Lottie animation asynchronously from the URL.
        case .loadedFrom(let url):
            let aniView = LottieAnimationView(url: url) { error in
                self.downloaded(state: state, value: error == nil)
                if !state.isControlEnabled {
                    DispatchQueue.main.async {
                        self.animationView?.play(fromProgress: state.range.from,
                                                 toProgress: state.range.to,
                                                 loopMode: state.loopMode,
                                                 completion: { value in
                            state.onCompleted.send(value)
                        })
                    }
                }
            }
            self.setupAnimation(aniView, state: state)
            /// Loads an animation from a specific filepath.
        case .filepath(let path):
            let aniView = LottieAnimationView(filePath: path)
            self.setupAnimation(aniView, state: state)
            self.downloaded(state: state, value: true)
            if !state.isControlEnabled {
                DispatchQueue.main.async {
                    self.animationView?.play(fromProgress: state.range.from,
                                             toProgress: state.range.to,
                                             loopMode: state.loopMode,
                                             completion: { value in
                        self.completed(state: state, value: value)
                    })
                }
            }
        }
    }
    
    /// Stops the animation and resets the view to its start frame.
    func stop() {
        animationView?.stop()
    }
    
    /// Updates the current size of the LottieAnimationView.
    ///
    /// - Parameters:
    ///   - size: Size to update.
    ///
    func setSize(_ size: CGSize) {
        let rect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        self.animationView?.frame = rect
    }
    
    /// An optional completion closure to be called when the animation completes playing.
    private func completed(state: LUStateData, value: Bool) {
        DispatchQueue.main.async {
            state.onCompleted.send(value)
        }
    }
    
    /// An optional completion closure to be called when the animation model has completes loading.
    private func downloaded(state: LUStateData, value: Bool) {
        DispatchQueue.main.async {
            state.onDownloaded.send(value)
        }
    }
    
    /// After setting the LottieAnimationView property, add it to the current view.
    ///
    /// - Parameters:
    ///   - aniView: A new LottieAnimationView object.
    ///   - state: The Lottie status information.
    ///
    private func setupAnimation(_ aniView: LottieAnimationView, state: LUStateData) {
        animationView?.removeFromSuperview()
        self.animationView = aniView
        aniView.contentMode = state.contentMode == .fit ? LottieContentMode.scaleAspectFit : LottieContentMode.scaleAspectFill
        aniView.loopMode = state.loopMode
        aniView.animationSpeed = state.speed
        self.addSubview(aniView)
    }
}
#endif
