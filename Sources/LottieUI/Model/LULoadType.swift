//
//  LULoadType.swift
//  LottieUI
//
//  Created by jasu on 2022/02/12.
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

/// The type to load animation models.
public enum LULoadType: Equatable {
    
    /// Loads an animation model from a bundle by its name.
    case name(String, Bundle)
    /// Loads a Lottie animation asynchronously from the URL.
    case loadedFrom(URL)
    /// Loads an animation from a specific filepath.
    case filepath(String)
    
    public static func == (lhs: LULoadType, rhs: LULoadType) -> Bool {
        switch (lhs, rhs) {
        case (.name(let lhsName, let lhsBundle), .name(let rhsName, let rhsBundle)):
            return lhsName == rhsName && lhsBundle == rhsBundle
        case (.loadedFrom(let lhsURL), .loadedFrom(let rhsURL)):
            return lhsURL == rhsURL
        case (.filepath(let lhsPath), .filepath(let rhsPath)):
            return lhsPath == rhsPath
        default:
            return false
        }
    }
}
