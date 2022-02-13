//
//  ScrollerLottieContent.swift
//  LottieUIExample
//
//  Created by jasu on 2022/02/12.
//  Copyright (c) 2022 jasu All rights reserved.
//

import SwiftUI
import LottieUI
import Scroller

struct ScrollerLottieContent: ScrollerContent {
    
    var value: CGFloat = 0
    let state: LUStateData
    
    var body: some View {
        GeometryReader { proxy in
            ZStack(alignment: .bottom) {
                LottieView(state: state, value: value)
                Text("Value: \(value)")
                    .font(.caption)
                    .padding()
            }
            .offset(x: proxy.size.width * 0.56 * value)
        }
    }
}

struct ScrollerLottieContent_Previews: PreviewProvider {
    static var previews: some View {
        ScrollerLottieContent(state: LUStateData())
    }
}
