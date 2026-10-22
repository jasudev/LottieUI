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

import Lottie

#if os(iOS)
    import UIKit

    /// A wrapper view for LottieAnimationView. (for iOS)
    class LUView: UIView {
        private var animationView: LottieAnimationView?

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
            setSize(bounds.size)
        }

        /// Updates the animation view to reflect state changes.
        func update(state: LUStateData) {
            guard let animationView = animationView else {
                setAnimation(state)
                return
            }
            if !state.isControlEnabled {
                animationView.stop()
                animationView.play(fromProgress: state.range.from,
                                   toProgress: state.range.to,
                                   loopMode: state.loopMode,
                                   completion: { [weak self] value in
                                       self?.completed(state: state, value: value)
                                   })
            }
            animationView.animationSpeed = state.speed
            animationView.contentMode = state.contentMode == .fit ? UIView.ContentMode.scaleAspectFit : UIView.ContentMode.scaleAspectFill
        }

        /// Create an LottieAnimationView object.
        ///
        /// - Parameters:
        ///   - state: The Lottie status information.
        ///
        func setAnimation(_ state: LUStateData) {
            switch state.type {
            // Loads an animation model from a bundle by its name.
            case let .name(name, bundle):
                let aniView = LottieAnimationView(animation: LottieAnimation.named(name, bundle: bundle))
                setupAnimation(aniView, state: state)
                downloaded(state: state, value: true)
                if !state.isControlEnabled {
                    animationView?.play(fromProgress: state.range.from,
                                        toProgress: state.range.to,
                                        loopMode: state.loopMode,
                                        completion: { [weak self] value in
                                            self?.completed(state: state, value: value)
                                        })
                }
            // Loads a Lottie animation asynchronously from the URL.
            case let .loadedFrom(url):
                let aniView = LottieAnimationView(url: url) { [weak self] error in
                    guard let self = self else { return }
                    self.downloaded(state: state, value: error == nil)
                    if !state.isControlEnabled {
                        self.animationView?.play(fromProgress: state.range.from,
                                                 toProgress: state.range.to,
                                                 loopMode: state.loopMode,
                                                 completion: { value in
                                                     self.completed(state: state, value: value)
                                                 })
                    }
                }
                setupAnimation(aniView, state: state)
            // Loads an animation from a specific filepath.
            case let .filepath(path):
                let aniView = LottieAnimationView(filePath: path)
                setupAnimation(aniView, state: state)
                downloaded(state: state, value: true)
                if !state.isControlEnabled {
                    animationView?.play(fromProgress: state.range.from,
                                        toProgress: state.range.to,
                                        loopMode: state.loopMode,
                                        completion: { [weak self] value in
                                            self?.completed(state: state, value: value)
                                        })
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
            animationView?.frame = rect
        }

        /// An optional completion closure to be called when the animation completes playing.
        private func completed(state: LUStateData, value: Bool) {
            state.onCompleted.send(value)
        }

        /// An optional completion closure to be called when the animation model has completes loading.
        private func downloaded(state: LUStateData, value: Bool) {
            state.onDownloaded.send(value)
        }

        /// After setting the LottieAnimationView property, add it to the current view.
        ///
        /// - Parameters:
        ///   - aniView: A new LottieAnimationView object.
        ///   - state: The Lottie status information.
        ///
        private func setupAnimation(_ aniView: LottieAnimationView, state: LUStateData) {
            animationView?.removeFromSuperview()
            animationView = aniView
            aniView.contentMode = state.contentMode == .fit ? UIView.ContentMode.scaleAspectFit : UIView.ContentMode.scaleAspectFill
            aniView.loopMode = state.loopMode
            aniView.animationSpeed = state.speed
            addSubview(aniView)
        }
    }
#else
    import Cocoa

    /// A wrapper view for LottieAnimationView. (for macOS)
    class LUView: NSView {
        private var animationView: LottieAnimationView?

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
        }

        override func resizeSubviews(withOldSize oldSize: NSSize) {
            super.resizeSubviews(withOldSize: oldSize)
            setSize(bounds.size)
        }

        @available(*, unavailable)
        required init?(coder _: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }

        /// Updates the animation view to reflect state changes.
        func update(state: LUStateData) {
            guard let animationView = animationView else {
                setAnimation(state)
                return
            }
            if !state.isControlEnabled {
                animationView.stop()
                animationView.play(fromProgress: state.range.from,
                                   toProgress: state.range.to,
                                   loopMode: state.loopMode,
                                   completion: { [weak self] value in
                                       self?.completed(state: state, value: value)
                                   })
            }
            animationView.animationSpeed = state.speed
            animationView.contentMode = state.contentMode == .fit ? LottieContentMode.scaleAspectFit : LottieContentMode.scaleAspectFill
        }

        /// Create an LottieAnimationView object.
        ///
        /// - Parameters:
        ///   - state: The Lottie status information.
        ///
        func setAnimation(_ state: LUStateData) {
            switch state.type {
            // Loads an animation model from a bundle by its name.
            case let .name(name, bundle):
                let aniView = LottieAnimationView(animation: LottieAnimation.named(name, bundle: bundle))
                setupAnimation(aniView, state: state)
                downloaded(state: state, value: true)
                if !state.isControlEnabled {
                    animationView?.play(fromProgress: state.range.from,
                                        toProgress: state.range.to,
                                        loopMode: state.loopMode,
                                        completion: { [weak self] value in
                                            self?.completed(state: state, value: value)
                                        })
                }
            // Loads a Lottie animation asynchronously from the URL.
            case let .loadedFrom(url):
                let aniView = LottieAnimationView(url: url) { [weak self] error in
                    guard let self = self else { return }
                    self.downloaded(state: state, value: error == nil)
                    if !state.isControlEnabled {
                        self.animationView?.play(fromProgress: state.range.from,
                                                 toProgress: state.range.to,
                                                 loopMode: state.loopMode,
                                                 completion: { value in
                                                     self.completed(state: state, value: value)
                                                 })
                    }
                }
                setupAnimation(aniView, state: state)
            // Loads an animation from a specific filepath.
            case let .filepath(path):
                let aniView = LottieAnimationView(filePath: path)
                setupAnimation(aniView, state: state)
                downloaded(state: state, value: true)
                if !state.isControlEnabled {
                    animationView?.play(fromProgress: state.range.from,
                                        toProgress: state.range.to,
                                        loopMode: state.loopMode,
                                        completion: { [weak self] value in
                                            self?.completed(state: state, value: value)
                                        })
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
            animationView?.frame = rect
        }

        /// An optional completion closure to be called when the animation completes playing.
        private func completed(state: LUStateData, value: Bool) {
            state.onCompleted.send(value)
        }

        /// An optional completion closure to be called when the animation model has completes loading.
        private func downloaded(state: LUStateData, value: Bool) {
            state.onDownloaded.send(value)
        }

        /// After setting the LottieAnimationView property, add it to the current view.
        ///
        /// - Parameters:
        ///   - aniView: A new LottieAnimationView object.
        ///   - state: The Lottie status information.
        ///
        private func setupAnimation(_ aniView: LottieAnimationView, state: LUStateData) {
            animationView?.removeFromSuperview()
            animationView = aniView
            aniView.contentMode = state.contentMode == .fit ? LottieContentMode.scaleAspectFit : LottieContentMode.scaleAspectFill
            aniView.loopMode = state.loopMode
            aniView.animationSpeed = state.speed
            addSubview(aniView)
        }
    }
#endif
